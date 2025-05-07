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

function getDF(path_system)
"""
   Function that gives the data file of the desire directory
"""

    # Read all shear experiments perform to the system
    shear_dirs=readdir(path_system);
    aux=findall(s->s==1,occursin.("shear",shear_dirs));
    shear_dirs=shear_dirs[aux];

    # Create DataFrames from the data.dat file of each directory
    df = DataFrame.(CSV.File.(joinpath.(path_system,shear_dirs,"data.dat")));

    return vcat(df...)

end

function extractFixScalar(path_system,df,file_name)
"""
    Function that extracts the information of fix files that stores global scalar values
"""
    aux=split.(readlines(joinpath(path_system,file_name))," ");
    return reduce(hcat,map(s->parse.(Float64,s),aux[3:end]));
end

function extractFixVector(path_system,df,file_name)
"""
    Function that extracts the information of fix mode vector files 
"""
    aux=split.(readlines(joinpath(path_system,file_name))," ");
   
    # Get time step and number of rows
    (TimeStep,nrows)=parse(Int64,aux[3]);




    return reduce(hcat,map(s->parse.(Float64,s),aux[3:end]));
end


function extractInfoAssembly(path_system,df)
"""
    Function that reads the files and extract all the information
    file0 -> system_assembly
    file1 -> stress_assembly
    file2 -> clust_assembly
    file3 -> profiles_assembly
    file4 -> traj_assembly
    file5 -> data.hydrogel
"""

    # Extract info from system system
    info=extractFixScalar(path_system,df,vcat(df."file0")...);
    head=["TimeStep","Temp","wca","patch","swap","V","K","Etot","ec","eC","p","eB","eA","eM","H","CM_dx","CM_dy","CM_dz","CM_d"];
    system_assembly=DataFrame(info',head);

    # Extract info from stress
    info=extractFixScalar(path_system,df,vcat(df."file1")...);
    head=["TimeStep","p","p_xx","p_yy","p_zz","p_xy","p_xz","p_yz","virialp_xx","virialp_yy","virialp_zz","virialp_xy","virialp_xz","virialp_yz","virialmodp_xx","virialmodp_yy","virialmodp_zz","virialmodp_xy","virialmodp_xz","virialmodp_yz","stress_xx","stress_yy","stress_zz","stress_xy","stress_xz","stress_yz","virialstress_xx","virialstress_yy","virialstress_zz","virialstress_xy","virialstress_xz","virialstress_yz","virialmodstress_xx","virialmodstress_yy","virialmodstress_zz","virialmodstress_xy","virialmodstress_xz","virialmodstress_yz"];
    stress_assembly=DataFrame(info',head);

    # Extract info from the cluster files
    info=extractInfo(path_system,df,vcat(df."file2")...);
    #head=[""];
    #clust_assembly=DataFrame(info',head);

    return df_assembly 

end


function extractInfoShear(shear_rate,parent_dir,df)
"""
    Function that reads the files and extract all the information
    file6 -> system_shear
    file7 -> stress_shear
    file8 -> clust_shear
    file9 -> profiles_shear
    file10 -> traj_shear
    file11 -> data.FirstShear
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


