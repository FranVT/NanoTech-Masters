"""
   Script with auxiliary functions to get the information 
"""

function getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp)
"""
   Function that gives the names of the directories with the system required
"""

# Create the file with the directories names in the directory
run(`bash getDir.sh`);

# Store the directories names
dirs_aux = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
end


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

aux_dirs_ind=split.(last.(aux_dirs_ind),"Nexp");
auxs_indNexp=Iterators.flatten(map(s->findall(r->r==s, last.(aux_dirs_ind)), selc_Nexp))|>collect;

# Get the idixes that meet the criteria
auxs_ind=intersect(auxs_indPhi,auxs_indNPart,auxs_indDamp,auxs_indT,auxs_indcCL,auxs_indShearRate,auxs_indNexp);

# Select the number of experiments
#auxs_ind=auxs_ind;
#dirs=dirs_aux[auxs_ind];
return dirs_aux[auxs_ind]
end



function getDataSystem(parameters,file_dir)
"""
    Function that compute the average of all the information in the files from N numerical simulations of the same system.
    Also gives the indixes for each process in the simulation:
    Processes:
    - Heat aup
    - Iso-thermal assembly
    - First shear deformation
    - First relax interval
    - Second shear deformation
    - Second relax interval
    - Third shear deformation
    - Third relax interval
    - Fourth shear deformation
    - Fourth relax interval
"""

# Indixes
 # Indixes for non stress fix files
      ind_heat=Int64.(1:1:parameters[11]/parameters[24]);#,
      ind_isothermal=last(ind_heat).+Int64.(1:1:parameters[12]/parameters[24]);
      ind_deform1=last(ind_isothermal).+Int64.(1:1:parameters[17]*parameters[18]/parameters[24]);
      ind_rlx1=last(ind_deform1).+Int64.(1:1:parameters[19]/parameters[24]);
      ind_deform2=last(ind_rlx1).+Int64.(1:1:parameters[17]*parameters[18]/parameters[24]);
      ind_rlx2=last(ind_deform2).+Int64.(1:1:parameters[20]/parameters[24]);
      ind_deform3=last(ind_rlx2).+Int64.(1:1:parameters[17]*parameters[18]/parameters[24]);
      ind_rlx3=last(ind_deform3).+Int64.(1:1:parameters[21]/parameters[24]);
      ind_deform4=last(ind_rlx3).+Int64.(1:1:parameters[17]*parameters[18]/parameters[24]);
      ind_rlx4=last(ind_deform4).+Int64.(1:1:parameters[22]/parameters[24]);
# Indixes for stress fix files
      ind_heat_s=Int64.(1:1:parameters[11]/parameters[25]);
      ind_isothermal_s=last(ind_heat_s).+Int64.(1:1:parameters[12]/parameters[25]);
      ind_deform1_s=last(ind_isothermal_s).+Int64.(1:1:parameters[17]*parameters[18]/parameters[25]);
      ind_rlx1_s=last(ind_deform1_s).+Int64.(1:1:parameters[19]/parameters[25]);
      ind_deform2_s=last(ind_rlx1_s).+Int64.(1:1:parameters[17]*parameters[18]/parameters[25]);
      ind_rlx2_s=last(ind_deform2_s).+Int64.(1:1:parameters[20]/parameters[25]);
      ind_deform3_s=last(ind_rlx2_s).+Int64.(1:1:parameters[17]*parameters[18]/parameters[25]);
      ind_rlx3_s=last(ind_deform3_s).+Int64.(1:1:parameters[21]/parameters[25]);
      ind_deform4_s=last(ind_rlx3_s).+Int64.(1:1:parameters[17]*parameters[18]/parameters[25]);
      ind_rlx4_s=last(ind_deform4_s).+Int64.(1:1:parameters[22]/parameters[25]);

      inds=(
           heat=ind_heat, #Int64.(1:1:parameters[11]/parameters[24]),
           isothermal=Int64.(parameters[11]/parameters[24]).+Int64.(1:1:parameters[12]/parameters[24]),
           assembly=reduce(vcat,[ind_heat,ind_isothermal]),
           deform1=ind_deform1, #Int64.(parameters[12]/parameters[24]).+Int64.(1:1:parameters[18]/parameters[24]),
           rlx1=ind_rlx1, #Int64.(parameters[12]/parameters[24]+parameters[18]/parameters[24]).+Int64.(1:1:parameters[19]/parameters[24]),
           deform2=ind_deform2,
           rlx2=ind_rlx2,
           deform3=ind_deform3,
           rlx3=ind_rlx3,
           deform4=ind_deform4,
           rlx4=ind_rlx4,
           shear=reduce(vcat,[ind_deform1,ind_rlx1,ind_deform2,ind_rlx2,ind_deform3,ind_rlx3,ind_deform4,ind_rlx4]),
           heat_s=ind_heat_s,
           isothermal_s=ind_isothermal_s,
           assembly_s=reduce(vcat,[ind_heat_s,ind_isothermal_s]),
           deform1_s=ind_deform1_s,
           rlx1_s=ind_rlx1_s,
           deform2_s=ind_deform2_s,
           rlx2_s=ind_rlx2_s,
           deform3_s=ind_deform3_s,
           rlx3_s=ind_rlx3_s,
           deform4_s=ind_deform4_s,
           rlx4_s=ind_rlx4_s,
           shear_s=reduce(vcat,[ind_deform1_s,ind_rlx1_s,ind_deform2_s,ind_rlx2_s,ind_deform3_s,ind_rlx3_s,ind_deform4_s,ind_rlx4_s])
          );

 

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
     data_Temp=data_aux[7,:],
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

return (inds,info)

end


