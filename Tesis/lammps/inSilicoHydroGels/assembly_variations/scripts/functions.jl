"""
    Script with all the neccesary functions to create the lammps files
                                  
        Create_Infile           -> lines: 10 
        Create_Swapfile         -> lines: 109
        Create_PatchTablefile   -> lines: 132
        Create_Swaptable        -> lines: 190
"""

## In file
function Create_Infile(L_box,N_CL,N_MO)
"""
    Create the input file for the assembly of an hydrogel.
    The units are LJ.

"""

# Include necesary parameters
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
"""
("L","NCL","NMO","seed1","seed2","steps","tstep","sstep")
(L_box,N_CL,N_MO,seed1,seed2,N_steps,t_step,N_saves)
"""
var_names = ("L","NCL","NMO","seed1","seed2","tstep","sstep");
var_values = (L_box,N_CL,N_MO,seed1,seed2,t_step,N_saves);

vars = map(s->string("variable ",var_names[s]," equal ",var_values[s],"\n"),eachindex(var_names));

region = "region simulation_box block -\$L \$L -\$L \$L -\$L \$L\n";

box = string("create_box ",length(m)," simulation_box bond/types 1 extra/bond/per/atom 4 extra/special/per/atom 5\n\n")

a_types = map(t->string("mass ",t," ",m[t],"\n"),eachindex(m));
coeffs = ("bond_coeff * nocoeff","pair_coeff 1 3 zero","pair_coeff 1 4 zero","pair_coeff 2 3 zero","pair_coeff 2 4 zero","pair_coeff 3 3 zero","pair_coeff 1 1 lj/cut/omp 1.0 1.0 1.12","pair_coeff 2 2 lj/cut/omp 1.0 1.0 1.12","pair_coeff 1 2 lj/cut/omp 1.0 1.0 1.12","pair_modify shift yes","pair_coeff 3 4 table/omp pachTab.table POT 0.6","pair_coeff 4 4 table/omp pachTab.table POT 0.6","pair_coeff * * threebody/table swapMech.3b NULL NULL PA PB");
coeffs = map(t->t*"\n",coeffs);

molCL = "molecule CL molecule.patchy.CL\n";
molMO = "molecule MO molecule.patchy.MO\n\n";

spawn = "region spawn_box block -\$L \$L -\$L \$L -\$L \$L\n\n";

cr_CL = string("create_atoms 0 random \${NCL} \${seed1} spawn_box mol CL \${seed1} overlap ",L_overlap," maxtry ",N_tries,"\n");
cr_MO = string("create_atoms 0 random \${NMO} \${seed2} spawn_box mol MO \${seed2} overlap ",L_overlap," maxtry ",N_tries,"\n\n");

#cr_CL = string("create_atoms 0 random ",N_CL," ",seed1," spawn_box mol CL ",seed1," overlap ",L_overlap," maxtry ",N_tries,"\n");
#cr_MO = string("create_atoms 0 random ",N_MO," ",seed2," spawn_box mol MO ",seed2," overlap ",L_overlap," maxtry ",N_tries,"\n\n");

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

method = string("fix langevinFix all langevin ",T_sys," ",T_sys," ",damp_lg," ",seed_langevin,"\nthermo \${sstep} \n\n")

com_general = ("compute t all temp\n","compute ep all pe\n","compute ek all ke\n");
com_cluster = ("compute cluster all aggregate/atom "*string(rcut_patch)*"\n","compute cc1 all chunk/atom c_cluster compress yes pbc yes\n","compute size all property/chunk cc1 count\n");
com_voro = ("compute vorCompSimple CM voronoi/atom only_group\n","compute vorCompHisto CM voronoi/atom only_group edge_histo "*string(vor_edge)*" edge_threshold "*string(vor_edgemin)*"\n");


dp_1 = "dump dumpID all atom \${sstep} info/patchyParticles_assembly.dumpf\ndump_modify dumpID pbc yes\n";
dp_2 = "dump dumpNew all custom \${steps} info/newdata_assembly.dumpf id type mol x y z c_cluster\ndump_modify dumpNew delay \${steps}\n";
dp_3 = "dump dumpVor CM custom \${steps} info/voronoiSimple_assembly.dumpf c_vorCompSimple[1] c_vorCompSimple[2]\ndump_modify dumpVor delay \${steps}\n";

fx_1 = "fix fixvorHisto CM ave/time 1 1 \${steps} c_vorCompHisto file info/vorHisto_assembly.fixf mode vector\n";
fx_2 = string("fix fixEng Energy ave/time 1 1 ",N_energ," c_t c_ep c_ek file info/energy_assembly.fixf\n");
fx_3 = "fix 1 all ave/time 1 1 \${steps} c_size file info/sizeCluster_assembly.fixf mode vector\n";

run = "timestep \${tstep}\n run \${steps}";

# Create/modify the file
touch(filename);

# Write in the file
open(filename,"w") do f
    map(s->write(f,s),(init,a_st,b_st,p_st))
    map(s->write(f,s),vars)
    write(f,"\n")
    map(s->write(f,s),(region,box))
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

end

## Swap.3b file
function Create_Swapfile()
"""
    Function to create the threebody/table file
"""
include("parameters.jl")

filename = "swapMech.3b";

# Create the permutation stuff
aux = vec(Iterators.product(Iterators.repeated(("PA ","PB "),3)...)|>collect);
data = string(rcut_patch," swapMechTab.table SEC1 linear ",N_Swap,"\n");
info = join.(aux).*data;

touch(filename); # Create the file

# Edit the file
open(filename,"w") do f
    map(s->write(f,s),info)
end

end

## pachTab.table file
function Create_PatchTablefile()
"""
    Function to create the table filename parameter for Patch-Patch interaction
"""

include("parameters.jl")

filename = "pachTab.table";

# Create the functions
function Upatch(eps_pair,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < 1.5*sig_p 
        return 2*eps_pair*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2) 
    else
        return 0.0
    end
end

function Fpatch(eps_pair,sig_p,r)
    if r < 1.5*sig_p
        return 4*eps_pair*(sig_p^4/r^5)*exp.((sig_p)./(r.-(1.5*sig_p)).+2) + 2*eps_pair*(sig_p/(r-1.5*sig_p)^2)*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2)
    else
        return 0.0
    end
end

# Spatial domain
r_dom = range(rmin_tp,rmax_tp,length=N_Patch);

# Create the table
info = map(s->(s,r_dom[s],Upatch(eps_tp,sig,r_dom[s]),Fpatch(eps_tp,sig,r_dom[s])),eachindex(r_dom));

# Start to write the data file
touch(filename); # Create the file

# Edit the file
open(filename,"w") do f
    write(f,"DATE: 2024-07-08 UNITS: lj CONTRIBUTOR: Fco.\n\n\n")
    write(f,"POT\n")
    write(f,string("N ",N_Patch,"\n\n"))
    map(t->write(f,rstrip(join(map(s->s*" ",string.(info[t]))))*"\n" ),eachindex(info))
end

end

## threebody/table file
function Create_Swaptable()
"""
    Script to create the threebody/table filename parameter
"""
include("parameters.jl")

filename = "swapMechTab.table";

# Create the functions
function U3(eps_pair,eps_3,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < sig_p 
        return 1.0
    elseif r >= 1.5*sig_p
        return 0.0 
    else 
        return -( 2*eps_pair*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2) )./eps_3
    end
end

function SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    Potential for the swap mechanism
"""
    return w.*eps_jk.*U3(eps_ij,eps_jk,sig_p,r_ij).*U3(eps_ik,eps_jk,sig_p,r_ik)
end

function Forceij(eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    -d/drij SwapU
"""
    if r_ij < sig_p || r_ik < sig_p
        return 0.0
    elseif r_ij >= 1.5*sig_p || r_ik >= 1.5*sig_p
        return 0.0 
    else 
        t1 = (eps_ij*eps_ik/eps_jk)*( (sig_p^4/r_ij^5)*((sig_p^4/(2*r_ik^4))-1) )*( 8*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        t2 = (eps_ij*eps_ik/eps_jk)*( (sig_p/(r_ij-1.5*sig_p)^2)*((sig_p^4/(2*r_ij^4))-1)*((sig_p^4/(2*r_ik^4))-1) )*( 4*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        return t1+t2
    end
end

function Forceik(eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    -d/drij SwapU
"""
    if r_ij < sig_p || r_ik < sig_p
        return 0.0
    elseif r_ij >= 1.5*sig_p || r_ik >= 1.5*sig_p 
        return 0.0
    else
        t1 = (eps_ij*eps_ik/eps_jk)*( (sig_p^4/r_ik^5)*((sig_p^4/(2*r_ij^4))-1) )*( 8*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        t2 = (eps_ij*eps_ik/eps_jk)*( (sig_p/(r_ik-1.5*sig_p)^2)*((sig_p^4/(2*r_ij^4))-1)*((sig_p^4/(2*r_ik^4))-1) )*( 4*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        return t1+t2
    end
end

function createTable(N,rmin,rmax,info,filename)
"""
    Create the table for threebody/table filename input as follows:
        ind rij rik th fi1 fi2 fj1 fj2 fk1 fk2 e
        ind rij rik th fi1 fi2 -fi1 0 -fi2 0 e
        ind rij rik th fij fik -fij 0 -fik 0 e
"""
# map(s-> string("    ",s," ",masses[s],"\n"),1:atom_type);

    # Start to write the data file
    touch(filename); # Create the file

    # Edit the file
    open(filename,"w") do f
        write(f,"SEC1\n")
        write(f,string("N ",N," rmin ",rmin," rmax ",rmax,"\n\n"))
        map(t->write(f,rstrip(join(map(s->s*" ",string.(info[t]))))*"\n" ),eachindex(info))
    end
end

## Parameters for the file
M = 2*N_Swap*N_Swap*N_Swap;

# Create the domains of evaluation according filename nessetities
th_dom = range(180/(4*N_Swap),180 - (180/(4*N_Swap)),2*N_Swap);
r_dom = range(rmin_tbp,rmax_tbp,N_Swap);

doms = reduce(vcat,Iterators.product(r_dom,r_dom,th_dom));

# Create tuples with the information
docs =  map(eachindex(doms)) do s
            (
                 s,
                 doms[s]...,
                 -Forceij(eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]),
                 -Forceik(eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]),
                 Forceij(eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]),
                 0.0,
                 Forceik(eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]),
                 0.0,
                 SwapU(1.0,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2])
            )
        end

createTable(N_Swap,rmin_tbp,rmax_tbp,docs,filename)
end
