module getData
"""
    Script to get the energies of the simulation given by
    fix fixEng Energy ave/time 1 1 1 c_t c_ep c_ek c_PairljCL c_PairswCL c_PairljMO c_PairswMO file info/energy_clean.fixf
"""

export timestep, temp, pote, kine, cllj, clsw, molj, mosw

# Functions
function getInfo(filename,totallines)
    """
        Converts the data file into arrays
    """
    # Allocate memory
    aux = ["" for it ∈ 1:totallines];
    info = [[] for it ∈ 3:totallines];

    # Get the information
    open(filename) do file
        line = 1;
        for ln in eachline(file)
            aux[line] = "$(ln)" #parse.(Float64,split("$(ln)"," "))
            line += 1
        end
    end

    # Convert the information
    for it in eachindex(info)
        info[it] = parse.(Float64,split(aux[it+2]," "))
    end

    # Reshape the information
    return stack(info,dims=1)
end


filename = "energy_clean.fixf";

#fileOpen = open(filename)

# Get the numberr of lines
totaltime, totallines = open(filename) do f
    linecounter = 0
    timetaken = @elapsed for l in eachline(f)
        linecounter += 1
    end
    (timetaken, linecounter)
end

data = getInfo(filename,totallines)
timestep = data[:,1];
temp = data[:,2];
pote = data[:,3];
kine = data[:,4];
cllj = data[:,5];
clsw = data[:,6];
molj = data[:,7];
mosw = data[:,8];


end