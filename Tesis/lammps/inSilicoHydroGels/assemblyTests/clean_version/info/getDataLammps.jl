"""
    Script to read the information of:
        clusters from lammps
        energy from lammps
"""

using GLMakie

include("auxiliaryFunctions.jl")

energy_filename = "energy_clean.fixf";
cluster_filename = "sizeCluster_clean.fixf";

info_energy = getInfoEnergy(energy_filename);
info_cluster = getInfoCluster(cluster_filename);

## Graphics

f = Figure()

ax_e = Axis(f[1,1],
    title = "Energy",
    xlabel = "Time steps [Log10]",
    ylabel = "Energy",
    xminorticksvisible = true, 
    xminorgridvisible = true,
    xminorticks = IntervalsBetween(5),
    xscale = log10
)

ax_c = Axis(f[1,2],
    title = "Clusters",
    xlabel = "Cluster size [particles]",
    ylabel = "Counts"
)

lines!(ax_e,info_energy[:,1],info_energy[:,3],label="U", color = :red)
lines!(ax_e,info_energy[:,1],info_energy[:,4],label="K", color = :orange)
lines!(ax_e,info_energy[:,1],info_energy[:,3].+info_energy[:,4],label="U+K", color = :black)

f[1,3] = Legend(f,ax_e,"Legends",framevisible=true)

n_bins = Int((maximum(info_cluster)-3+1));
hist!(f[1,2],info_cluster,bins=n_bins,
    bar_labels=:values,
    label_formatter=x-> round(x, digits=2), label_size = 15
)


f
