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

function getDataFiles(path,file_name)
"""
    Function that retrieves data files from the path
"""
    # Read the file from the path
    return DataFrame(CSV.File(joinpath(path,file_name)))
end

function extractFixScalar(path_system,df,file_name)
"""
    Function that extracts the information of fix files that stores global scalar values
"""
    aux=split.(readlines(joinpath(path_system,file_name))," ");
    return reduce(hcat,map(s->parse.(Float64,s),aux[3:end]));
end

function extractFixCluster(path_system,df,file_name)
"""
    Function that extracts the information of fix mode vector files 
"""
    aux=split.(readlines(joinpath(path_system,file_name))," ");
    ind_o=4;
    nrows=[];
    data=[];

    # Initializa the stuff 
    # Get the time headder information 
    (ts,nr)=parse.(Int64,aux[ind_o]);
    # Get the ids of each cluster 
    idclust=map(s->parse.(Int64,s[2]),aux[ind_o+1:ind_o+nr]);   
    # Get the size of each cluster
    sizes=map(s->parse.(Int64,s),last.(aux[ind_o+1:ind_o+nr]));
    # Add the data into auxiliary varaible for future dataframe
    push!(data,(TimeStep=ts,NClust=nr,IDClust=idclust,SizeClust=sizes));
    
    append!(nrows,nr); # Keep track of the length of the file

    while isassigned(aux,ind_o+sum(nrows)+length(nrows))
        local ts 
        local nr
        local idclust
        local sizes
        ind=ind_o+sum(nrows)+length(nrows);
        (ts,nr)=parse.(Int64,aux[ind]);
        # Get the ids of each cluster 
        idclust=map(s->parse.(Int64,s[2]),aux[ind+1:ind+nr]);   
        # Get the size of each cluster
        sizes=map(s->parse.(Int64,s),last.(aux[ind+1:ind+nr]));
        # Add the data into auxiliary varaible for future dataframe
        push!(data,(TimeStep=ts,NClust=nr,IDClust=idclust,SizeClust=sizes));
        
        append!(nrows,nr); # Keep track of the length of the file
        
    end

    return DataFrame(data);
end

function extractFixProfile(path_system,df,file_name)
"""
    Function that extracts the information of fix mode vector files 
"""
    aux=split.(readlines(joinpath(path_system,file_name))," ");
    ind_o=4;
    nrows=[];
    data=[];

    # Initializa the stuff 
    # Get the time headder information 
    (ts,nr)=parse.(Int64,aux[ind_o]);
    # Get x coordinate of spatial chunk 
    chunk_x=map(s->parse.(Float64,s[4]),aux[ind_o+1:ind_o+nr]);
    chunk_y=map(s->parse.(Float64,s[5]),aux[ind_o+1:ind_o+nr]);
    chunk_z=map(s->parse.(Float64,s[6]),aux[ind_o+1:ind_o+nr]);
    count=map(s->parse.(Float64,s[7]),aux[ind_o+1:ind_o+nr]);
    chunk_vx=map(s->parse.(Float64,s[8]),aux[ind_o+1:ind_o+nr]);
    chunk_vy=map(s->parse.(Float64,s[9]),aux[ind_o+1:ind_o+nr]);
    chunk_vz=map(s->parse.(Float64,s[10]),aux[ind_o+1:ind_o+nr]);
    chunk_dx=map(s->parse.(Float64,s[11]),aux[ind_o+1:ind_o+nr]);
    chunk_dy=map(s->parse.(Float64,s[12]),aux[ind_o+1:ind_o+nr]);
    chunk_dz=map(s->parse.(Float64,s[13]),aux[ind_o+1:ind_o+nr]);
    chunk_dd=map(s->parse.(Float64,s[14]),aux[ind_o+1:ind_o+nr]);

    # Add the data into auxiliary varaible for future dataframe
    push!(data,(TimeStep=ts,X=chunk_x,Y=chunk_y,Z=chunk_z,Count=count,vx=chunk_vx,vy=chunk_vy,vz=chunk_vz,Dx=chunk_dx,Dy=chunk_dy,Dz=chunk_dz,Dd=chunk_dd));
    
    append!(nrows,nr); # Keep track of the length of the file

    while isassigned(aux,ind_o+sum(nrows)+length(nrows))
        local ts; local nr; local count; local chunk_dd;
        local chunk_x; local chunk_y; local chunk_z;
        local chunk_vx; local chunk_vy; local chunk_vz;
        local chunk_dx; local chunk_dy; local chunk_dz; 

        ind=ind_o+sum(nrows)+length(nrows);
        (ts,nr)=parse.(Int64,aux[ind]);
        # Get x coordinate of spatial chunk 
        chunk_x=map(s->parse.(Float64,s[4]),aux[ind_o+1:ind_o+nr]);
        chunk_y=map(s->parse.(Float64,s[5]),aux[ind_o+1:ind_o+nr]);
        chunk_z=map(s->parse.(Float64,s[6]),aux[ind_o+1:ind_o+nr]);
        count=map(s->parse.(Float64,s[7]),aux[ind_o+1:ind_o+nr]);
        chunk_vx=map(s->parse.(Float64,s[8]),aux[ind_o+1:ind_o+nr]);
        chunk_vy=map(s->parse.(Float64,s[9]),aux[ind_o+1:ind_o+nr]);
        chunk_vz=map(s->parse.(Float64,s[10]),aux[ind_o+1:ind_o+nr]);
        chunk_dx=map(s->parse.(Float64,s[11]),aux[ind_o+1:ind_o+nr]);
        chunk_dy=map(s->parse.(Float64,s[12]),aux[ind_o+1:ind_o+nr]);
        chunk_dz=map(s->parse.(Float64,s[13]),aux[ind_o+1:ind_o+nr]);
        chunk_dd=map(s->parse.(Float64,s[14]),aux[ind_o+1:ind_o+nr]);

    # Add the data into auxiliary varaible for future dataframe
        push!(data,(TimeStep=ts,X=chunk_x,Y=chunk_y,Z=chunk_z,Count=count,vx=chunk_vx,vy=chunk_vy,vz=chunk_vz,Dx=chunk_dx,Dy=chunk_dy,Dz=chunk_dz,Dd=chunk_dd));
    
        append!(nrows,nr); # Keep track of the length of the file
        
    end

    return DataFrame(data);
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
    info=extractFixScalar(path_system,df,df."file0"...);
    head=["TimeStep","Temp","wca","patch","swap","V","K","Etot","ec","eC","p","eB","eA","eM","H","CM_dx","CM_dy","CM_dz","CM_d"];
    system_assembly=DataFrame(info',head);

    # Extract info from stress
    info=extractFixScalar(path_system,df,df."file1"...);
    head=["TimeStep","p","p_xx","p_yy","p_zz","p_xy","p_xz","p_yz","virialp_xx","virialp_yy","virialp_zz","virialp_xy","virialp_xz","virialp_yz","virialmodp_xx","virialmodp_yy","virialmodp_zz","virialmodp_xy","virialmodp_xz","virialmodp_yz","stress_xx","stress_yy","stress_zz","stress_xy","stress_xz","stress_yz","virialstress_xx","virialstress_yy","virialstress_zz","virialstress_xy","virialstress_xz","virialstress_yz","virialmodstress_xx","virialmodstress_yy","virialmodstress_zz","virialmodstress_xy","virialmodstress_xz","virialmodstress_yz"];
    stress_assembly=DataFrame(info',head);

    # Extract info from the cluster files
    clust_assembly=extractFixCluster(path_system,df,df."file2"...);

    # Extract the information from the profiles file
    profile_assembly=extractFixProfile(path_system,df,df."file3"...)

    return (system_assembly,stress_assembly,clust_assembly,profile_assembly)

end


function extractInfoShear(path_shear,df)
"""
    Function that reads the files and extract all the information
    file6 -> system_shear
    file7 -> stress_shear
    file8 -> clust_shear
    file9 -> profiles_shear
    file10 -> traj_shear
    file11 -> data.FirstShear
"""
    # Extract info from system system
    info=extractFixScalar(path_shear,df,df."file6"...);
    head=["TimeStep","Temp","wca","patch","swap","V","K","Etot","ec","eC","p","eB","eA","eM","H","CM_dx","CM_dy","CM_dz","CM_d"];
    system_shear=DataFrame(info',head);

    # Extract info from stress
    info=extractFixScalar(path_shear,df,df."file7"...);
    head=["TimeStep","p","p_xx","p_yy","p_zz","p_xy","p_xz","p_yz","virialp_xx","virialp_yy","virialp_zz","virialp_xy","virialp_xz","virialp_yz","virialmodp_xx","virialmodp_yy","virialmodp_zz","virialmodp_xy","virialmodp_xz","virialmodp_yz","stress_xx","stress_yy","stress_zz","stress_xy","stress_xz","stress_yz","virialstress_xx","virialstress_yy","virialstress_zz","virialstress_xy","virialstress_xz","virialstress_yz","virialmodstress_xx","virialmodstress_yy","virialmodstress_zz","virialmodstress_xy","virialmodstress_xz","virialmodstress_yz"];
    stress_shear=DataFrame(info',head);

    # Extract info from the cluster files
    clust_shear=extractFixCluster(path_shear,df,df."file8"...);

    # Extract the information from the profiles file
    profile_shear=extractFixProfile(path_shear,df,df."file9"...)

    return (system_shear,stress_shear,clust_shear,profile_shear)

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


