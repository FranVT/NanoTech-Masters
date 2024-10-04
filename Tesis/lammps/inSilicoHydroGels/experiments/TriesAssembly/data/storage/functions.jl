"""
    Script with functions
"""

function getParameters(dirs,file_name)
    """
        Function that return an array with the parameters of a simulation.
        dirs is an array of directories
        file_name is an array of file names
    """
    file_dir=reduce(vcat,map(s->joinpath(dirs[s],first(file_name)),eachindex(dirs)));
    parameters=map(eachindex(dirs)) do r
        open(file_dir[r]) do f
            map(s->parse(Float64,s),readlines(f))
        end
    end
    return parameters
end

function getInfo(filename)
"""
    Function that return a matrix with the following information:
        TimeStep Temperature Potential Kinetic
    (According to the output file in lammps)
"""
	Nlines = open(filename) do f
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

    println(filename)

    # Reshape the information
    return Float64.(reduce(hcat,info))
end

function getData(dirs,file_dir)
    """
        Function that retrieve all the data from the fix files
    """
    # Get info from the directories
    file_dir=map(dirs) do s
        reduce(vcat,map(r->joinpath(s,"info",r),file_name[2:end]))
    end

    info = map(file_dir) do s
        map(r->getInfo(r),s)
    end
    return info
end



