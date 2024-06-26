"""
	Script that stores all auxiliry function for getDataLammps.jl
"""


function getInfoEnergy(filename)
"""
    Function that return a matrix with the following information:
        TimeStep Temperature Potential Kinetic
    (According to the output file in lammps)
"""
	Nlines = open(energy_filename) do f
	    linecounter = 0
	    for l in eachline(f)
	        linecounter += 1
	    end
	    (linecounter)
	end


    # Allocate memory
    aux = ["" for it ∈ 1:Nlines];
    info = [[] for it ∈ 3:Nlines];

    aux = open(filename) do file
        line = 1;
        for ln in eachline(file)
            aux[line] = "$(ln)" #parse.(Float64,split("$(ln)"," "))
            line += 1
        end
        (aux)
    end

    # Convert the information
    for it in eachindex(info)
        info[it] = parse.(Float64,split(aux[it+2]," "))
    end

    # Reshape the information
    return stack(info,dims=1)
end

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