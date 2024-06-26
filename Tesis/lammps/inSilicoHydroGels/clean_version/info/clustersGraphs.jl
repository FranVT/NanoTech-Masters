"""
    Script to graph histograms of clusters
"""

using GLMakie

#include("getDataClusterOvito.jl")
include("getDataClusterLammps.jl")


n_bins = Int((maximum(getDataClusterOvito.clusterOvito)-3+1));

f = Figure()
ax = Axis(f[1,1],
    #xscale = log10,
    #limits = (nothing,nothing,minimum(minimum.((getData.pote,getData.kine,getData.pote+getData.kine))),maximum(maximum.((getData.pote,getData.kine,getData.pote+getData.kine)))),
    #xminorticksvisible = true, xminorgridvisible = true,
    xlabel = "Cluster size [particles]", ylabel = "Counts",
    title = "Cluster counts"
    )
hist!(f[1,1],getDataClusterOvito.clusterOvito,bins=n_bins,
    bar_labels=:values,
    label_formatter=x-> round(x, digits=2), label_size = 15
)


