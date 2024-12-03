"""
    Auxiliary script when coding
"""

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
             wca=reduce(vcat,mean(reduce(hcat,map(s->s.data_pot,data_wca_assembly)),dims=2)),
             patch=reduce(vcat,mean(reduce(hcat,map(s->s.data_pot,data_patch_assembly)),dims=2)),
             swap=reduce(vcat,mean(reduce(hcat,map(s->s.data_pot,data_swap_assembly)),dims=2)),
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
             eng=reduce(vcat,mean(reduce(hcat,map(s->s.data_Eng,data_energy_shear)),dims=2))
            # Potentials files
             wca=reduce(vcat,mean(reduce(hcat,map(s->s.data_pot,data_wca_shear)),dims=2)),
             patch=reduce(vcat,mean(reduce(hcat,map(s->s.data_pot,data_patch_shear)),dims=2)),
             swap=reduce(vcat,mean(reduce(hcat,map(s->s.data_pot,data_swap_shear)),dims=2)),
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



