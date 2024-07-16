"""
    Script to create in.assembly.lmp file
"""


include("parameters.jl")

filename = "in.assembly.lmp";

# Create stuff
"""
    initi: 
    a_st:
    b_st:
    p_st:
"""

init = "units lj \ndimension 3\nboundary p p p\n\n"

a_st = "atom_style bond\n";
b_st = "bond_style zero nocoeff\n"
p_st = "pair_style hybrid/overlay/omp zero 0.0 lj/cut/omp 1.12 table/omp linear 5000000 threebody/table\nnewton on\n\n"

# Variables
var_names = ("L","NCL","NMO","seed1","seed2","seed3","steps","tstep","sstep");
var_values = (L_box,N_CL,N_MO,seed1,seed2,N_steps,t_step,N_saves);

vars = map(s->string("variable ",var_names[s]," equal ",var_values),eachindex(var_names));

region = "region simulation_box block -$L $L -$L $L -$L $L";
box = string("create_box ",length(m)," simulation_box bond/types 1 extra/bond/per/atom 4 extra/special/per/atom 5\n\n")

a_types = map(t->string("mass ",t," ",m[t],"\n"),eachindex(m));
coeffs = ("bond_coeff * nocoeff","pair_coeff 1 3 zero","pair_coeff 1 4 zero","pair_coeff 2 3 zero","pair_coeff 2 4 zero","pair_coeff 3 3 zero","pair_coeff 1 1 lj/cut/omp 1.0 1.0 1.12","pair_coeff 2 2 lj/cut/omp 1.0 1.0 1.12","pair_coeff 1 2 lj/cut/omp 1.0 1.0 1.12","pair_modify shift yes","pair_coeff 3 4 table/omp pachTab.table POT 0.6","pair_coeff 4 4 table/omp pachTab.table POT 0.6","pair_coeff * * threebody/table swapMech.3b NULL NULL PA PB");
coeffs = map(t->t*"\n",coeffs);

molCL = "molecule CL molecule.patchy.CL\n";
molMO = "molecule MO molecule.patchy.MO\n\n";

spawn = "region spawn_box block -$L $L -$L $L -$L $L";

cr_CL = string("create_atoms 0 random ",N_CL," ",seed1," spawn_box mol CL ",seed1," overlap ",L_overlap," maxtry ",N_tries,"\n");
cr_MO = string("create_atoms 0 random ",N_MO," ",seed2," spawn_box mol MO ",seed2," overlap ",L_overlap," maxtry ",N_tries,"\n\n");

gr_1 = "group CrossLinker type 1 3\n";
gr_2 = "group Monomer type 2 4\n";
gr_3 = "group Patches type 3 4\n";
gr_4 = "group CL type 1\n";
gr_5 = "group MO type 2\n";
gr_6 = "group CM type 1 2\n";
gr_7 = "group Energy empty\n"

rig_CL = "fix pCL CrossLinker rigid/small/omp molecule\n";
rig_MO = "fix pMO Monomer rigid/small/omp molecule\n\n";

nei_1 = "neighbor 1.8 bin\n";
nei_2 = "neigh_modify exclude molecule/intra CrossLinker\n";
nei_3 = "neigh_modify exclude molecule/intra Monomer\n\n";

method = string("fix langevinFix all langevin ",T_sys," ",T_sys," ",damp_lg," ",seed_langevin,"\n","thermo ",N_saves,"\n\n")

com_general = ("compute t all temp\n","compute ep all pe\n","compute ek all ke\n");
com_cluster = ("compute cluster all aggregate/atom "*string(rcut_patch)*"\n","compute cc1 all chunk/atom c_cluster compress yes pbc yes\n","compute size all property/chunk cc1 count\n");
com_voro = ("compute vorCompSimple CM voronoi/atom only_group\n","compute vorCompHisto CM voronoi/atom only_group edge_histo "*string(vor_edge)*" edge_threshold "*string(vor_edgemin)*"\n");


dp_1 = string("dump dumpID all atom ",N_saves," patchyParticles_assembly.dumpf\ndump_modify dumpID pbc yes\n");
dp_2 = string("dump dumpNew all custom ",N_steps," newdata_assembly.dumpf id type mol x y z c_cluster\ndump_modify dumpNew delay ",N_steps,"\n");
dp_3 = string("dump dumpVor CM custom ",N_steps," voronoiSimple_assembly.dumpf c_vorCompSimple[1] c_vorCompSimple[2]\ndump_modify dumpVor delay ",N_steps,"\n");

fx_1 = string("fix fixvorHisto CM ave/time 1 1 ",N_steps," c_vorCompHisto file vorHisto_assembly.fixf mode vector\n");
fx_2 = string("fix fixEng Energy ave/time 1 1 ",N_energ," c_t c_ep c_ek file energy_assembly.fixf\n");
fx_3 = string("fix 1 all ave/time 1 1 ",N_steps," c_size file sizeCluster_assembly.fixf mode vector\n");

run = string("timestep ",t_step,"\n run ",N_steps);


#rstrip(join(map(s->s*" ",string.(m[t]))))*"\n"

# Create/modify the file
touch(filename);

# Write in the file
open(filename,"w") do f
    map(s->write(f,s),(init,a_st,b_st,p_st,region,box))
    map(s->write(f,s),a_types)
    write(f,"\n")   
    map(s->write(f,s),coeffs)
    write(f,"\n")
    map(t->write(f,t),(molCL,molMO,spawn,cr_CL,cr_MO))
    map(t->write(f,t),(gr_1,gr_2,gr_3,gr_4,gr_5,gr_6,gr_7))
    write(f,"\n")
    map(t->write(f,t),(rig_CL,rig_MO,nei_1,nei_2,nei_3,method))
    map(t->map(s->write(f,s),t),(com_general,com_cluster,com_voro))
    write(f,"\n")
    map(t->write(f,t),(dp_1,dp_2,dp_3))
    write(f,"\n")
    map(t->write(f,t),(fx_1,fx_2,fx_3))
    write(f,"\n")
    write(f,run)
end

