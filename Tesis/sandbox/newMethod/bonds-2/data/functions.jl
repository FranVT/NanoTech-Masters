"""
    Script to declare usefull functions to analyse data
"""

function getDF()
"""
   Function that gives the data file of all directories
"""

    # Create the file with the directories names in the directory
    run(`bash getDir.sh`);

    # Store the directories names
    dirs_aux = open("dirs.txt") do f
        reduce(vcat,map(s->split(s," "),readlines(f)))
    end

    # Create DataFrames from the data.dat file of each directory
    df = DataFrame.(CSV.File.(joinpath.(dirs_aux,"data.dat")));

    return vcat(df...)

end


function extractInfo(df)
"""
    Function that reads the files and extract all the information
    file0 -> data_system_assembly
    file1 -> data_stress_assembly
    file2 -> data_clustP_assembly
    file3 -> traj_assembly
    file4 -> data.hydrogel
    file5 -> data_system_shear
    file6 -> data_stress_shear
    file7 -> data_clustP_shear
    file8 -> traj_shear
    file9 -> data.FirstShear
"""
    data_path=joinpath.(df_new."main-directory",df_new."file0");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","Temp","wca","patch","swap","V","K","Etot","ec","eC","p","eB","eA","eM","H"]; #aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_assembly=DataFrame(aux_info',aux_head);

    data_path=joinpath.(df_new."main-directory",df_new."file5");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","Temp","wca","patch","swap","V","K","Etot","ec","eC","p","eB","eA","eM","H"];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_shear=DataFrame(aux_info',aux_head);

    data_path=joinpath.(df_new."main-directory",df_new."file1");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","p","xx","yy","zz","xy","xz","yz","xx_virial","yy_virial","zz_virial","xy_virial","xz_virial","yz_virial","xx_virialMod","yy_virialMod","zz_virialMod","xy_virialMod","xz_virialMod","yz_virialMod"];#aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_stressA=DataFrame(aux_info',aux_head);
    
    data_path=joinpath.(df_new."main-directory",df_new."file6");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","p","xx","yy","zz","xy","xz","yz","xx_virial","yy_virial","zz_virial","xy_virial","xz_virial","yz_virial","xx_virialMod","yy_virialMod","zz_virialMod","xy_virialMod","xz_virialMod","yz_virialMod"];#aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_stressS=DataFrame(aux_info',aux_head);

    return (df_assembly, df_shear, df_stressA, df_stressS) 
end

function pressure(data_assembly,data_shear)
"""
    data is a data frame with the following information:
    time-step pressure stress-xx stress-yy stress-zz stress-xy stress-xz stress-yz virial-xx virial-yy virial-zz virial-xy virial-xz virialMod-xx virialMod-yy virialMod-zz virialMod-xy virialMod-xz 
"""

    # General pressure
    pressure_ass = data_assembly."p";
    pressure_she = data_shear."p";

    # Full pressure
    norm_pressure_ass = sqrt.( data_assembly."xx".^2 .+ data_assembly."yy".^2 .+ data_assembly."zz".^2 .+ (2).*(data_assembly."xy".^2 .+ data_assembly."xz".^2 .+ data_assembly."yz".^2)  );
    norm_pressure_she = sqrt.( data_shear."xx".^2 .+ data_shear."yy".^2 .+ data_shear."zz".^2 .+ (2).*(data_shear."xy".^2 .+ data_shear."xz".^2 .+ data_shear."yz".^2)  );

    pressure_tensor_ass = (1/3).*(data_assembly."xx" .+ data_assembly."yy" .+ data_assembly."zz");
    pressure_tensor_she = (1/3).*(data_shear."xx" .+ data_shear."yy" .+ data_shear."zz");
  
    # Virial pressure
    norm_virial_ass = sqrt.( data_assembly."xx_virial".^2 .+ data_assembly."yy_virial".^2 .+ data_assembly."zz_virial".^2 .+ (2).*(data_assembly."xy_virial".^2 .+ data_assembly."xz_virial".^2 .+ data_assembly."yz_virial".^2)  );
    norm_virial_she = sqrt.( data_shear."xx_virial".^2 .+ data_shear."yy_virial".^2 .+ data_shear."zz_virial".^2 .+ (2).*(data_shear."xy_virial".^2 .+ data_shear."xz_virial".^2 .+ data_shear."yz_virial".^2)  );

    pressure_virial_ass = (1/3).*(data_assembly."xx_virial" .+ data_assembly."yy_virial" .+ data_assembly."zz_virial");
    pressure_virial_she = (1/3).*(data_shear."xx_virial" .+ data_shear."yy_virial" .+ data_shear."zz_virial");

    # Virial Mod pressure
    norm_virialMod_ass = sqrt.( data_assembly."xx_virialMod".^2 .+ data_assembly."yy_virialMod".^2 .+ data_assembly."zz_virialMod".^2 .+ (2).*(data_assembly."xy_virialMod".^2 .+ data_assembly."xz_virialMod".^2 .+ data_assembly."yz_virialMod".^2)  );
    norm_virialMod_she = sqrt.( data_shear."xx_virialMod".^2 .+ data_shear."yy_virialMod".^2 .+ data_shear."zz_virialMod".^2 .+ (2).*(data_shear."xy_virialMod".^2 .+ data_shear."xz_virialMod".^2 .+ data_shear."yz_virialMod".^2)  );

    pressure_virialMod_ass = (1/3).*(data_assembly."xx_virialMod" .+ data_assembly."yy_virialMod" .+ data_assembly."zz_virialMod");
    pressure_virialMod_she = (1/3).*(data_shear."xx_virialMod" .+ data_shear."yy_virialMod" .+ data_shear."zz_virialMod");

    return (pressure_ass,pressure_she,norm_pressure_ass,norm_pressure_she,pressure_tensor_ass,pressure_tensor_she,norm_virial_ass,norm_virial_she,pressure_virial_ass,pressure_virial_she,norm_virialMod_ass,norm_virialMod_she,pressure_virialMod_ass,pressure_virialMod_she)
end


