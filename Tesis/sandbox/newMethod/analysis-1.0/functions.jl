"""
    Script to declare usefull functions to analyse data
"""

function norm(xx,yy,zz,xy,xz,yz)
"""
    Compute the norm of a symetric tensor
"""
    return sqrt.(xx.^2 .+ yy.^2 .+ zz.^2 .+ (2).*(xy.^2 .+ xz.^2 .+ yz.^2))
end

function trace(xx,yy,zz)
"""
    Computes the trace
"""
    return xx.+yy.+zz
end

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
    aux_head=["TimeStep","p","press_xx","press_yy","press_zz","press_xy","press_xz","press_yz","virialpress_xx","virialpress_yy","virialpress_zz","virialpress_xy","virialpress_xz","virialpress_yz","virialpressmod_xx","virialpressmod_yy","virialpressmod_zz","virialpressmod_xy","virialpressmod_xz","virialpressmod_yz","stress_xx","stress_yy","stress_zz","stress_xy","stress_xz","stress_yz","virialstress_xx","virialstress_yy","virialstress_zz","virialstress_xy","virialstress_xz","virialstress_yz","virialstressmod_xx","virialstressmod_yy","virialstressmod_zz","virialstressmod_xy","virialstressmod_xz","virialstressmod_yz"];#aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_stressA=DataFrame(aux_info',aux_head);
    
    data_path=joinpath.(df_new."main-directory",df_new."file6");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","p","press_xx","press_yy","press_zz","press_xy","press_xz","press_yz","virialpress_xx","virialpress_yy","virialpress_zz","virialpress_xy","virialpress_xz","virialpress_yz","virialpressmod_xx","virialpressmod_yy","virialpressmod_zz","virialpressmod_xy","virialpressmod_xz","virialpressmod_yz","stress_xx","stress_yy","stress_zz","stress_xy","stress_xz","stress_yz","virialstress_xx","virialstress_yy","virialstress_zz","virialstress_xy","virialstress_xz","virialstress_yz","virialstressmod_xx","virialstressmod_yy","virialstressmod_zz","virialstressmod_xy","virialstressmod_xz","virialstressmod_yz"];#aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_stressS=DataFrame(aux_info',aux_head);

    return (df_assembly, df_shear, df_stressA, df_stressS) 
end

function normStressPressure(data_ass,data_she)
"""
    data is a data frame with the following information:
    time-step pressure stress-xx stress-yy stress-zz stress-xy stress-xz stress-yz virial-xx virial-yy virial-zz virial-xy virial-xz virialMod-xx virialMod-yy virialMod-zz virialMod-xy virialMod-xz 
"""

    # Full pressure
    norm_press_ass = norm(data_ass."press_xx",data_ass."press_yy",data_ass."press_zz",data_ass."press_xy",data_ass."press_xz",data_ass."press_yz");
    norm_press_she = norm(data_she."press_xx",data_she."press_yy",data_she."press_zz",data_she."press_xy",data_she."press_xz",data_she."press_yz");

    # Virial pressure
    norm_virialpress_ass = norm(data_ass."virialpress_xx",data_ass."virialpress_yy",data_ass."virialpress_zz",data_ass."virialpress_xy",data_ass."virialpress_xz",data_ass."virialpress_yz");
    norm_virialpress_she = norm(data_she."virialpress_xx",data_she."virialpress_yy",data_she."virialpress_zz",data_she."virialpress_xy",data_she."virialpress_xz",data_she."virialpress_yz");

    # Virial Mod pressure
    norm_virialModpress_ass = norm(data_ass."virialpressmod_xx",data_ass."virialpressmod_yy",data_ass."virialpressmod_zz",data_ass."virialpressmod_xy",data_ass."virialpressmod_xz",data_ass."virialpressmod_yz");
    norm_virialModpress_she = norm(data_she."virialpressmod_xx",data_she."virialpressmod_yy",data_she."virialpressmod_zz",data_she."virialpressmod_xy",data_she."virialpressmod_xz",data_she."virialpressmod_yz");

    # Full stress
    norm_stress_ass = norm(data_ass."stress_xx",data_ass."stress_yy",data_ass."stress_zz",data_ass."stress_xy",data_ass."stress_xz",data_ass."stress_yz");
    norm_stress_she = norm(data_she."stress_xx",data_she."stress_yy",data_she."stress_zz",data_she."stress_xy",data_she."stress_xz",data_she."stress_yz");

    # Virial stress
    norm_virialstress_ass = norm(data_ass."virialstress_xx",data_ass."virialstress_yy",data_ass."virialstress_zz",data_ass."virialstress_xy",data_ass."virialstress_xz",data_ass."virialstress_yz");
    norm_virialstress_she = norm(data_she."virialstress_xx",data_she."virialstress_yy",data_she."virialstress_zz",data_she."virialstress_xy",data_she."virialstress_xz",data_she."virialstress_yz");

    # Virial Mod stress
    norm_virialModstress_ass = norm(data_ass."virialstressmod_xx",data_ass."virialstressmod_yy",data_ass."virialstressmod_zz",data_ass."virialstressmod_xy",data_ass."virialstressmod_xz",data_ass."virialstressmod_yz");
    norm_virialModstress_she = norm(data_she."virialstressmod_xx",data_she."virialstressmod_yy",data_she."virialstressmod_zz",data_she."virialstressmod_xy",data_she."virialstressmod_xz",data_she."virialstressmod_yz");

    return (norm_press_ass,norm_press_she,
            norm_virialpress_ass,norm_virialpress_she,
            norm_virialModpress_ass,norm_virialModpress_she,
            norm_stress_ass,norm_stress_she,
            norm_virialstress_ass,norm_virialstress_she,
            norm_virialModstress_ass,norm_virialModstress_she
           )
end


