"""
    Temporal script to create a function that reads the fix file of stress
"""

pwdDir = "/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/shearTests/assembly_deformation/info/";
workdir = cd(pwdDir)
filename = "stress_shear.fixf";

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
    info_stress = reduce(hcat,info)
