module getDataClusterOvito
"""
    Script to get the data for cluster given by ovito
"""

export clusterOvito

function getInfo(filename,totallines)
    """
        Converts the data file into arrays
    """
    # Allocate memory
    aux = ["" for it ∈ 1:totallines];
    info = zeros(totallines-2)#[[] for it ∈ 3:totallines];

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
        info[it] = parse(Float64,split(aux[it+2]," ")[2])
    end

    # Reshape the information
    return stack(info,dims=1)
end


filename = "clusterOvito/clusterOvito";

totaltime, totallinesovito = open(filename) do f
    linecounter = 0
    timetaken = @elapsed for l in eachline(f)
        linecounter += 1
    end
    (timetaken, linecounter)
end

clusterOvito = getInfo(filename,totallinesovito)

end

