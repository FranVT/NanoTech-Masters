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

# Alocate the indixes
#inds=(
#      shearRate=parameters[16],
#      Npart=parameters[2],
#      CLcon=parameters[5],
#      strainFact=1,
 # Indixes for non stress fix files
      ind_heat=Int64.((1:1:parameters[11]/parameters[24]));#,
      ind_isothermal=Int64.(last(ind_heat).+(1:1:parameters[12]/parameters[24]));#,
      ind_deform1=Int64.(last(ind_isothermal).+(1:1:parameters[18]/parameters[24]));#,
      ind_rlx1=Int64.(last(ind_deform1).+(1:parameters[19]/parameters[24]));#,
      ind_deform2=Int64.(last(ind_rlx1).+(1:1:parameters[18]/parameters[24]));#,
      ind_rlx2=Int64.(last(ind_deform2).+(1:parameters[20]/parameters[24]));#,
      ind_deform3=Int64.(last(ind_rlx2).+(1:1:parameters[18]/parameters[24]));#,
      ind_rlx3=Int64.(last(ind_deform3).+(1:parameters[21]/parameters[24]));#,
      ind_deform4=Int64.(last(ind_rlx3).+(1:1:parameters[18]/parameters[24]));#,
      ind_rlx4=Int64.(last(ind_deform4).+(1:parameters[22]/parameters[24]));#,
# Indixes for stress fix files
      ind_heat_s=Int64.((1:1:parameters[11]/parameters[25]));#,
      ind_isothermal_s=Int64.(last(ind_heat_s).+(1:1:parameters[12]/parameters[25]));#,
      ind_deform1_s=Int64.(last(ind_isothermal_s).+(1:1:parameters[18]/parameters[25]));#,
      ind_rlx1_s=Int64.(last(ind_deform1_s).+(1:parameters[19]/parameters[25]));#,
      ind_deform2_s=Int64.(last(ind_rlx1_s).+(1:1:parameters[18]/parameters[25]));#,
      ind_rlx2_s=Int64.(last(ind_deform2_s).+(1:parameters[20]/parameters[25]));#,
      ind_deform3_s=Int64.(last(ind_rlx2_s).+(1:1:parameters[18]/parameters[25]));#,
      ind_rlx3_s=Int64.(last(ind_deform3_s).+(1:parameters[21]/parameters[25]));#,
      ind_deform4_s=Int64.(last(ind_rlx3_s).+(1:1:parameters[18]/parameters[25]));#,
      ind_rlx4_s=Int64.(last(ind_deform4_s).+(1:parameters[22]/parameters[25]));#
#     );




"""
# Start to extract the data with the energy file of all experiments of the same system
file_dir=map(s->joinpath(s,"info",files_names[2]),dirs);

# All data of N experiments of one system
data_energy=map(file_dir) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_Temp=data_aux[2,:],
     data_Pot=data_aux[3,:],
     data_Kin=data_aux[4,:],
     data_TpCM=data_aux[5,:],
     data_pressure=data_aux[6,:],
     data_Eng=data_aux[3,:].+data_aux[4,:]
   );
end

info_energy=(
             temp=reduce(vcat,mean(reduce(hcat,map(s->s.data_Temp,data_energy)),dims=2)),
             pot=reduce(vcat,mean(reduce(hcat,map(s->s.data_Pot,data_energy)),dims=2)),
             kin=reduce(vcat,mean(reduce(hcat,map(s->s.data_Kin,data_energy)),dims=2)),
             tpcm=reduce(vcat,mean(reduce(hcat,map(s->s.data_TpCM,data_energy)),dims=2)),
             pressure=reduce(vcat,mean(reduce(hcat,map(s->s.data_pressure,data_energy)),dims=2)),
             eng=reduce(vcat,mean(reduce(hcat,map(s->s.data_Eng,data_energy)),dims=2))
            );  
"""
    
# Files per fix files per experiment
file_dir=map(s->reduce(vcat,map(r->joinpath(r,"info",s),dirs)),files_names[2:end]);

# Assembly
data_energy_assembly=map(file_dir[1]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_Temp=data_aux[2,:],
     data_Pot=data_aux[3,:],
     data_Kin=data_aux[4,:],
     data_TpCM=data_aux[5,:],
     data_pressure=data_aux[6,:],
     data_Eng=data_aux[3,:].+data_aux[4,:]
   );
end

# Potential energies Assembly (2:4)
data_wca_assembly=map(file_dir[2]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_pot=data_aux[2,:]
    );
end

data_patch_assembly=map(file_dir[3]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_pot=data_aux[2,:]
    );
end

data_swap_assembly=map(file_dir[4]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_pot=data_aux[2,:]
    );
end

# Stress file assembly
data_stress_assembly=map(file_dir[5]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     XX=data_aux[2,:],
     XY=data_aux[5,:],
     norm=sqrt.( data_aux[2,:].^2 .+ data_aux[3,:].^2 .+ data_aux[4,:].^2 .+ (2).*( data_aux[5,:].^2 .+ data_aux[6,:].^2 .+ data_aux[7,:].^2) )
   );
end

# Take the average of N experiments fo the same system.
info_assembly=(
            # energy file
             temp=reduce(vcat,mean(reduce(hcat,map(s->s.data_Temp,data_energy_assembly)),dims=2)),
             pot=reduce(vcat,mean(reduce(hcat,map(s->s.data_Pot,data_energy_assembly)),dims=2)),
             kin=reduce(vcat,mean(reduce(hcat,map(s->s.data_Kin,data_energy_assembly)),dims=2)),
             tpcm=reduce(vcat,mean(reduce(hcat,map(s->s.data_TpCM,data_energy_assembly)),dims=2)),
             pressure=reduce(vcat,mean(reduce(hcat,map(s->s.data_pressure,data_energy_assembly)),dims=2)),
             eng=reduce(vcat,mean(reduce(hcat,map(s->s.data_Eng,data_energy_assembly)),dims=2)),
             # Potentials files
             wca=reduce(vcat,mean(reduce(hcat,data_wca_assembly),dims=2)),
             patch=reduce(vcat,mean(reduce(hcat,data_patch_assembly),dims=2)),
             swap=reduce(vcat,mean(reduce(hcat,data_swap_assembly),dims=2)),
             # Stress files
             XX=-reduce(vcat,mean(reduce(hcat,map(s->s.XX,data_stress_assembly)),dims=2)),
             XY=-reduce(vcat,mean(reduce(hcat,map(s->s.XY,data_stress_assembly)),dims=2)),
             norm=-reduce(vcat,mean(reduce(hcat,map(s->s.norm,data_stress_assembly)),dims=2))
            );

# Shear
# Energy file
data_energy_shear=map(file_dir[7]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_Temp=data_aux[2,:],
     data_Pot=data_aux[3,:],
     data_Kin=data_aux[4,:],
     data_TpCM=data_aux[5,:],
     data_pressure=data_aux[6,:],
     data_Eng=data_aux[3,:].+data_aux[4,:]
   );
end

# Potential files 
data_wca_shear=map(file_dir[8]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_pot=data_aux[2,:]
    );
end

data_patch_shear=map(file_dir[9]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_pot=data_aux[2,:]
    );
end

data_swap_shear=map(file_dir[10]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     data_pot=data_aux[2,:]
    );
end

# Stress file
data_stress_shear=map(file_dir[end-1]) do r
    data_aux=reduce(hcat,map(s->parse.(Float64,s),split.(readlines(r)," ")[3:end]));
    (
     XX=data_aux[2,:],
     XY=data_aux[5,:],
     norm=sqrt.( data_aux[2,:].^2 .+ data_aux[3,:].^2 .+ data_aux[4,:].^2 .+ (2).*( data_aux[5,:].^2 .+ data_aux[6,:].^2 .+ data_aux[7,:].^2) )
   );
end

# Compute the mean of N experiments of the same experiment
info_shear=(
            # Energy file
             temp=reduce(vcat,mean(reduce(hcat,map(s->s.data_Temp,data_energy_shear)),dims=2)),
             pot=reduce(vcat,mean(reduce(hcat,map(s->s.data_Pot,data_energy_shear)),dims=2)),
             kin=reduce(vcat,mean(reduce(hcat,map(s->s.data_Kin,data_energy_shear)),dims=2)),
             tpcm=reduce(vcat,mean(reduce(hcat,map(s->s.data_TpCM,data_energy_shear)),dims=2)),
             pressure=reduce(vcat,mean(reduce(hcat,map(s->s.data_pressure,data_energy_shear)),dims=2)),
             eng=reduce(vcat,mean(reduce(hcat,map(s->s.data_Eng,data_energy_shear)),dims=2)),
            # Potentials files
             wca=reduce(vcat,mean(reduce(hcat,data_wca_shear),dims=2)),
             patch=reduce(vcat,mean(reduce(hcat,data_patch_shear),dims=2)),
             swap=reduce(vcat,mean(reduce(hcat,data_swap_shear),dims=2)),
             # Stress files
             XX=-reduce(vcat,mean(reduce(hcat,map(s->s.XX,data_stress_shear)),dims=2)),
             XY=-reduce(vcat,mean(reduce(hcat,map(s->s.XY,data_stress_shear)),dims=2)),
             norm=-reduce(vcat,mean(reduce(hcat,map(s->s.norm,data_stress_shear)),dims=2))
            );


# Merge Assembly and shear simualtions
info=(
     # Energy file
     temp=append!(info_assembly.temp,info_shear.temp),
     pot=append!(info_assembly.pot,info_shear.pot),
     kin=append!(info_assembly.kin,info_shear.kin),
     tpcm=append!(info_assembly.tpcm,info_shear.tpcm),
     pressure=append!(info_assembly.pressure,info_shear.pressure),
     energy=append!(info_assembly.eng,info_shear.eng),
     # Potential files
     wca=append!(info_assembly.wca,info_shear.wca),
     patch=append!(info_assembly.patch,info_shear.patch),
     swap=append!(info_assembly.swap,info_shear.swap),
     # Stress files
     XX=append!(info_assembly.XX,info_shear.XX),
     XY=append!(info_assembly.XY,info_shear.XY),
     norm=append!(info_assembly.norm,info_shear.norm)
      );




