"""
    Script with functions to read information from assembly_variations
"""

function getInfoEnergy(energy_filename)
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

    aux = open(energy_filename) do file
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
    return reduce(hcat,info)
end

function getInfoStress(filename)
"""
    Function that return the six components of the symmetric stress tensor.
    Retrieve the information form output file stress_shear.fixf

    id_f:   Index that reads: TimeSetp Number-of-rows from the output file
    it:     Auxiliary iterator
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

    # Reshape the information
    return reduce(hcat,info)
end
