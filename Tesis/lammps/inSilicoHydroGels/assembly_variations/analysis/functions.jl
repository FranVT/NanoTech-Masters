"""
    Script with functions to read information from assembly_variations
"""

function getInfoCluster(filename)
"""
    Function that return the number of atoms in N clusters
    Retrieve the information form output file sizeCluster_clean.fixf

    id_f:   Index that reads: TimeSetp Number-of-rows from the output file
    it:     Auxiliary iterator
"""
    info_cluster = readlines(filename,keep=false);

    # Take into account the headers of the file
    id_f = 4;
    it = 1;

    # Allocate memory
    itt = zeros(Int64,length(info_cluster));
    
    # Get all the index that store: TimeSetp Number-of-rows
    while id_f < length(info_cluster)
        id_aux = parse.(Int64,split(info_cluster[id_f]," "))[2];
        id_f += id_aux+1;
        it += 1;
        itt[it] = id_f;
    end

    # Clean the array
    ids = deleteat!(itt[:],itt[:].==0);
    
    # Extract the rows corresponds to the last time step
    info_cluster = info_cluster[ids[end-1]:end];

    # Allocate memory
    info = zeros(Int64,length(info_cluster)-1);

    # Convert the information to Int68
    for it in eachindex(info)
        info[it] = parse.(Int64,split(info_cluster[it+1]," "))[2];
    end

    return info
end

function getInfoVoroSimple(filename)
"""
    Function that return the Volume and number of faces in each atom based on voronoi tessellation.
    Retrieve the information form output file voronoiSimple_assembly.dumpf

    id_a:   Read The number of atoms
    it_d:   Firt line with the values of interest
"""
    info_voro = readlines(filename,keep=false);

    # Take into account the headers of the file
    id_a = parse(Int64,(info_voro[4]));
    it_d = 10;
    
    # Get all Volume | Number of faces
    info = reduce(hcat,map(s->parse.(Float64,split(info_voro[s]," ")),it_d:it_d+id_a-1));

    return info
end

function getInfoVoroHisto(filename)
"""
    Function that return the number of atoms in N clusters
    Retrieve the information form output file sizeCluster_clean.fixf

    id_f:   Index that reads: TimeSetp Number-of-rows from the output file
    it:     Auxiliary iterator
"""
    info_voro = readlines(filename,keep=false);

    # Take into account the headers of the file
    id_f = 4;
    it = 1;

    # Allocate memory
    itt = zeros(Int64,length(info_voro));
    
    # Get all the index that store: TimeSetp Number-of-rows
    while id_f < length(info_voro)
        id_aux = parse.(Int64,split(info_voro[id_f]," "))[2];
        id_f += id_aux+1;
        it += 1;
        itt[it] = id_f;
    end

    # Clean the array
    ids = deleteat!(itt[:],itt[:].==0);

    # Extract the rows corresponds to the last time step
    info_voro = info_voro[ids[end-1]:end];

    # Allocate memory
    info = zeros(Int64,length(info_voro)-1,2);

    # Convert the information to Int68
    for it in eachindex(info[:,1])
        aux = parse.(Int64,split(info_voro[it+1]," "));
        info[it,1] = aux[1];
        info[it,2] = aux[2];
    end

    return info[1:end-1,:]
end
