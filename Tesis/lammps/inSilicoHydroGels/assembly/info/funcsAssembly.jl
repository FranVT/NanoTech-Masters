"""
    Auxiliary functions for graphsAssembly.jl
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

function graphs(info)
"""
    Return a figure of the energy
"""
    timestep = info[1,:];
    Eng_cin = info[4,:];
    Eng_pot = info[3,:];
    Eng_tot = Eng_cin .+ Eng_pot;

    f = Figure()

    ax_e = Axis(f[1,1],
        title = "Energy",
        xlabel = "Time steps [Log10]",
        ylabel = "Energy",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        xscale = log10,
        limits = (10e0,exp10(1+round(log10(length(timestep)))),nothing,nothing)
        #limits = (10e0,10e8,nothing,nothing)
    )

    lines!(ax_e,timestep,Eng_pot,label="U", color = :red)
    lines!(ax_e,timestep,Eng_cin,label="K", color = :orange)
    lines!(ax_e,timestep,Eng_tot,label="U+K", color = :black)

    f[1,2] = Legend(f,ax_e,"Legends",framevisible=true)

    return f
end
