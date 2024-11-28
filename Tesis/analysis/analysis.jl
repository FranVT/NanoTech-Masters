"""
   Statistical analysisi and graph
"""

using FileIO
using GLMakie
using Statistics

# Add functions to acces infromation from files
include("functions.jl")

"""
    Select the desire systems to analyse
"""

selc_phi="5500";
selc_Npart="1500";
selc_damp="5000";
selc_T="500";
selc_cCL="300";
selc_ShearRate="100";
selc_Nexp=string.(1:15);

dirs=getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp);

files_names = (
               "parameters",
               "energy_assembly.fixf",
               "wcaPair_assembly.fixf",
               "patchPair_assembly.fixf",
               "swapPair_assembly.fixf",
               "stressVirial_assembly.fixf",
               "cmdisplacement_assembly.fixf",
               "energy_shear.fixf",
               "wcaPair_shear.fixf",
               "patchPair_shear.fixf",
               "swapPair_shear.fixf",
               "stressVirial_shear.fixf",
               "cmdisplacement_shear.fixf",
              );


# Get the parameters of the system

file_dir=joinpath(first(dirs),first(files_names));
parameters=open(file_dir) do f
    map(s->parse(Float64,s),readlines(f))
end

# Pre-allocate the array with the information of the system
# The system energy and stuff are means of N experiments of the same system.
"""
    ShearRate
    Number of particles
    Concentration
    Strain factor of conversion
    Indexes for heat up
    Indexes for assembly (isothermal)
    Indexes for deformation 1
    Indexes for deformation 2
    Indexes for deformation 3
    Indexes for deformation 4
    Indexes for relax 1
    Indexes for relax 2
    Indexes for relax 3
    Indexes for relax 4
    Indexes for heat up for Stress
    Indexes for assembly (isothermal) for Stress
    Indexes for deformation 1 for Stress
    Indexes for deformation 2 for Stress
    Indexes for deformation 3 for Stress
    Indexes for deformation 4 for Stress
    Indexes for relax 1 for Stress
    Indexes for relax 2 for Stress
    Indexes for relax 3 for Stress
    Indexes for relax 4 for Stress
    Time for the whole process (Heat up, isothermal, shears and relax)
    Deformation for the whole process (Heat up, isothermal, shears and relax)
    Temperature
    Pressure
    Total energy
    Kinetic energy
    Potential energy
    Central-centra energy
    Patch-patch energy
    Swap energy
    xy component of Virial Stress
    Norm of the pressure tensor
"""

# Indixes for non stress fix files
ind_heat=Int64.((1:1:parameters[11]/parameters[24]));
ind_isothermal=Int64.(last(ind_heat).+(1:1:parameters[12]/parameters[24]));
ind_deform1=Int64.(last(ind_isothermal).+(1:1:parameters[18]/parameters[24]));
ind_rlx1=Int64.(last(ind_deform1).+(1:parameters[19]/parameters[24]));
ind_deform2=Int64.(last(ind_rlx1).+(1:1:parameters[18]/parameters[24]));
ind_rlx2=Int64.(last(ind_deform2).+(1:parameters[20]/parameters[24]));
ind_deform3=Int64.(last(ind_rlx2).+(1:1:parameters[18]/parameters[24]));
ind_rlx3=Int64.(last(ind_deform3).+(1:parameters[21]/parameters[24]));
ind_deform4=Int64.(last(ind_rlx3).+(1:1:parameters[18]/parameters[24]));
ind_rlx4=Int64.(last(ind_deform4).+(1:parameters[22]/parameters[24]));

# Indixes for stress fix files
ind_heat_s=Int64.((1:1:parameters[11]/parameters[25]));
ind_isothermal_s=Int64.(last(ind_heat_s).+(1:1:parameters[12]/parameters[25]));
ind_deform1_s=Int64.(last(ind_isothermal_s).+(1:1:parameters[18]/parameters[25]));
ind_rlx1_s=Int64.(last(ind_deform1_s).+(1:parameters[19]/parameters[25]));
ind_deform2_s=Int64.(last(ind_rlx1_s).+(1:1:parameters[18]/parameters[25]));
ind_rlx2_s=Int64.(last(ind_deform2_s).+(1:parameters[20]/parameters[25]));
ind_deform3_s=Int64.(last(ind_rlx2_s).+(1:1:parameters[18]/parameters[25]));
ind_rlx3_s=Int64.(last(ind_deform3_s).+(1:parameters[21]/parameters[25]));
ind_deform4_s=Int64.(last(ind_rlx3_s).+(1:1:parameters[18]/parameters[25]));
ind_rlx4_s=Int64.(last(ind_deform4_s).+(1:parameters[22]/parameters[25]));

# Pre-alocate the indixes
info=[
      parameters[16],
      parameters[2],
      parameters[5],
      1,
      ind_heat,ind_isothermal,ind_deform1,ind_rlx1,ind_deform2,ind_rlx2,ind_deform3,ind_rlx3,ind_deform4,ind_rlx4,
      ind_heat_s,ind_isothermal_s,ind_deform1_s,ind_rlx1_s,ind_deform2_s,ind_rlx2_s,ind_deform3_s,ind_rlx3_s,ind_deform4_s,ind_rlx4_s,
      [],[],[],[],[],[],[],[],[],[],[],[]
     ];




# Start to extract the data with the energy file

file_dir=map(s->joinpath(s,"info",files_names[2]),dirs);

data_test=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(file_dir[1])," ")[3:end]));

#ind_assembly=(1:sum(parameters[11:12]))
#time_assembly=parameters[10].*()

"""
file_dir=joinpath(first(dirs),first(files_names));
parameters=open(file_dir) do f
    map(s->parse(Float64,s),readlines(f))
end
"""


