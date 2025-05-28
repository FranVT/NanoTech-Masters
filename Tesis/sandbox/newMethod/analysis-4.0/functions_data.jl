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
    return (aux[2][2:end],reduce(hcat,map(s->parse.(Float64,s),aux[3:end])));
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
    (ts,nr)=round.(Int64,parse.(Float64,aux[ind_o]));
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
        (ts,nr)=round.(Int64,parse.(Float64,aux[ind_o]));
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
    (headers,info)=extractFixScalar(path_system,df,df."file0"...);
    system_assembly=DataFrame(info',headers);

    # Extract info from stress
    (headers,info)=extractFixScalar(path_system,df,df."file1"...);
    stress_assembly=DataFrame(info',headers);

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

    Nexp=df."Nexp";
    # Get the number of experiments done with the same shear
    path_shear=map(s->joinpath(path_shear,string("Exp",s)),1:first(Nexp));

    system_shear=map(path_shear) do s
        (headers,info)=extractFixScalar(s,df,df."file6"...);
        DataFrame(info',headers)
    end


    # Extract info from stress
    stress_shear=map(path_shear) do s
        (headers,info)=extractFixScalar(s,df,df."file7"...);
        DataFrame(info',headers)
    end

    # Extract info from the cluster files
    #clust_shear=map(s->extractFixCluster(s,df,df."file8"...),path_shear);

    # Extract the information from the profiles file
    #profile_shear=map(s->extractFixProfile(s,df,df."file9"...),path_shear)

    min_aux=minimum(first.(size.(system_shear)));
    system_shear=map(s->s[1:min_aux,:],system_shear)

    min_aux=minimum(first.(size.(stress_shear)));
    stress_shear=map(s->s[1:min_aux,:],stress_shear)


    # Compute the averages of the Nexperiments
    system_shear=reduce(.+,system_shear)./Nexp
    stress_shear=reduce(.+,stress_shear)./Nexp


    return (system_shear,stress_shear) #,clust_shear,profile_shear)

end

