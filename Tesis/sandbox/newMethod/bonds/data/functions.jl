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
    aux_head=["TimeStep","xx","yy","zz","xy","xz","yz","xx_atom","yy_atom","zz_atom","xy_atom","xz_atom","yz_atom","xx_patch","yy_patch","zz_patch","xy_patch","xz_patch","yz_patch","xx_part","yy_part","zz_part","xy_part","xz_part","yz_part"];#aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_stressA=DataFrame(aux_info',aux_head);
    
    data_path=joinpath.(df_new."main-directory",df_new."file6");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","xx","yy","zz","xy","xz","yz","xx_atom","yy_atom","zz_atom","xy_atom","xz_atom","yz_atom","xx_patch","yy_patch","zz_patch","xy_patch","xz_patch","yz_patch","xx_part","yy_part","zz_part","xy_part","xz_part","yz_part"];#aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_stressS=DataFrame(aux_info',aux_head);

    return (df_assembly, df_shear, df_stressA, df_stressS) 
end


