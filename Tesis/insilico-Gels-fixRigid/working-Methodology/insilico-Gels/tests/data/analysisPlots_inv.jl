"""
    Individual visual analysis
"""

using FileIO
using Plots 
using Statistics

include("functions.jl")

# Create the file with the dirs names
run(`bash getDir.sh`)
# Store the dirs names
dirs_aux = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
    end

#dirs=dirs_aux;

#aux_indx=map(s->split(dirs_aux[1],"Nexp")[1] == split(dirs_aux[s],"Nexp")[1],eachindex(dirs_aux));
"""
   Start of the classification process.
   Parameters to select the system:
   phi -> Packing fraction
   NPart -> Number of central particles
   damp -> damp langevin parameter
   T -> Temperature of the system
   cCL -> CrossLink concentration
   ShearRate -> Self explanatory
   Nexp -> Number of simulation
"""

selc_phi="5000";
selc_Npart="500";
selc_damp="500";
selc_T="500";
selc_cCL="300";
selc_ShearRate="100";

aux_dirs_ind=split.(last.(split.(dirs_aux,"Phi")),"NPart");
auxs_indPhi=findall(r->r==selc_phi, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"damp");
auxs_indNPart=findall(r->r==selc_Npart, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"T");
auxs_indDamp=findall(r->r==selc_damp, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"cCL");
auxs_indT=findall(r->r==selc_T, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"ShearRate");
auxs_indcCL=findall(r->r==selc_cCL, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"-");
auxs_indShearRate=findall(r->r==selc_ShearRate, first.(aux_dirs_ind) );

# Get the idixes that meet the criteria
auxs_ind=intersect(auxs_indPhi,auxs_indNPart,auxs_indDamp,auxs_indT,auxs_indcCL,auxs_indShearRate);

# Select the number of experiments
auxs_ind=auxs_ind;

# Selcet the directories woth the criteria
dirs=dirs_aux[auxs_ind];


# File names 
file_name = (
             "parameters",
             "energy_assembly.fixf",
             "wcaPair_assembly.fixf",
             "patchPair_assembly.fixf",
             #"swapPair_assembly.fixf",
             "cmdisplacement_assembly.fixf",
             "stressVirial_assembly.fixf",
             "energy_shear.fixf",
             "wcaPair_shear.fixf",
             "patchPair_shear.fixf",
             #"swapPair_shear.fixf",
             "cmdisplacement_shear.fixf",
             "stressVirial_shear.fixf"
            );

#"""
# Get parameters from the directories
"""
    Relation of index with parameter
    1 -> Packing fraction
    2 -> Number of particles
    3 -> Number of Cross-Linkers
    4 -> Number of Monomers
    5 -> Cross-Linker Concentration
    6 -> Box Volume
    7 -> L in lammps (Half length of box) 
    8 -> Temperature
    9 -> Damp
   10 -> Time step in assembly
   11 -> Number of time steps in heating process in assembly
   12 -> Number of time steps in isothermal process in assembly 
   13 -> Save every N time steps in dumps files
   14 -> Save every N time steps in fix files
   15 -> Time step in shear
   16 -> Shear rate
   17 -> Max deformation per cycle
   18 -> Relax time 1 [Time steps]
   19 -> Relax time 2 [Time steps]
   20 -> Relax time 3 [Time steps]
   21 -> Relax time 4 [Time steps]
   22 -> Save every N time steps in dumps files
   23 -> Save every N time steps in fix files
   24 -> Save every N time steps for Stress fix files
"""

parameters=getParameters(dirs,file_name,auxs_ind);

# Retrieve all the data from every experiment
data=map(s->getData2(dirs[s],file_name,parameters[s]),eachindex(dirs));

# Separate the data from assembly and shear experiment
data_assembly=first.(data);
data_shear=last.(data);

# From time steps to time units

time_assembly=map(s->parameters[s][10].*data_assembly[s][1],eachindex(data_assembly));
time_assemblyStress=map(s->parameters[s][10].*data_assembly[s][2],eachindex(data_assembly));

time_shear=map(s->last(time_assembly[s]).+parameters[s][15].*data_shear[s][1],eachindex(data_assembly));
time_shearStress=map(s->parameters[s][15].*data_shear[s][2],eachindex(data_assembly));

# Get time instants
tm_endAssembly=parameters[1][10]*(parameters[1][11]+parameters[1][12]);

tm_shear=parameters[1][15]*parameters[1][17]*parameters[1][18];

tm_rlx1o=last(time_assembly[1])+tm_shear;
tm_rlx1f=tm_rlx1o+parameters[1][15]*parameters[1][18];

tm_rlx2o=tm_rlx1f+tm_shear;
tm_rlx2f=tm_rlx2o+parameters[1][15]*parameters[1][19];

tm_rlx3o=tm_rlx2f+tm_shear;
tm_rlx3f=tm_rlx3o+parameters[1][15]*parameters[1][20];

tm_rlx4o=tm_rlx3f+tm_shear;
tm_rlx4f=tm_rlx4o+parameters[1][15]*parameters[1][21];

csh=:tab20;

## Temperature

tf=last(time_assembly);

# Mean and standard values of Temperature
mean_T_ass=mean(data_assembly[1][3][Int64(parameters[1][12]/parameters[1][14]):end]);
std_T_ass=std(data_assembly[1][3][Int64(parameters[1][12]/parameters[1][14]):end],mean=mean_T_ass);

mean_T_shear=mean(data_shear[1][3]);
std_T_shear=std(data_shear[1][3],mean=mean_T_shear);

fig_Temp=plot(
              title="Temperature in Assembly",
              xlabel="Time",
              ylabel="Temperature"
             )
plot!(fig_Temp,time_assembly[1],data_assembly[1][3])
plot!(fig_Temp,time_shear[1],data_shear[1][3])


## Energy Plot

# Mean and standard values of Temperature
mean_Eng_ass=mean(data_assembly[1][8][Int64(parameters[1][12]/parameters[1][14]):end]);
std_Eng_ass=std(data_assembly[1][8][Int64(parameters[1][12]/parameters[1][14]):end],mean=mean_T_ass);

fig_Eng=plot(
            title="Energy",
            xlabel="Time [log10]}",
            ylabel="Energy",
            xscale=:log10
          )
plot!(fig_Eng,time_assembly[1],data_assembly[1][8])
plot!(fig_Eng,time_shear[1],data_shear[1][8])


