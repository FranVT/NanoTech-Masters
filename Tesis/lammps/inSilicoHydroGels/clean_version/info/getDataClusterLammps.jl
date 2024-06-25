"""
    Script to read the informatino of the clusters from lammps
"""

filename = "histoCluster_clean.fixf";

totaltime, totallineslammps = open(filename) do f
    linecounter = 0
    timetaken = @elapsed for l in eachline(f)
        linecounter += 1
    end
    (timetaken, linecounter)
end

# Allocate memory
aux = ["" for it ∈ 1:totallineslammps];
aux = open(filename) do file
    line = 1;
    for ln in eachline(file)
        aux[line] = "$(ln)" #parse.(Float64,split("$(ln)"," "))
        line += 1
    end
    (aux)
end

n_bins = parse.(Int64,split(aux[4]," "))[2];
ids = Iterators.partition(4:totallineslammps,n_bins+1)|>collect;

t_step = length(ids);
auxHisto = aux[ids[t_step]];
infoHisto = [[] for it ∈ eachindex(ids[t_step])]
for it in 1:n_bins+1
    infoHisto[it] = parse.(Float64,split(auxHisto[it]," "))
end

infoHisto = stack(infoHisto[2:end],dims=1);

#using GLMakie

f = Figure()
Axis(f[1, 1])

barplot!(infoHisto[:,2],infoHisto[:,3])