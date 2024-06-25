"""
    Script to graph histograms of clusters
"""

using GLMakie

#include("getDataClusterOvito.jl")


f = Figure()
ax = Axis(f[1,1],
    #xscale = log10,
    #limits = (nothing,nothing,minimum(minimum.((getData.pote,getData.kine,getData.pote+getData.kine))),maximum(maximum.((getData.pote,getData.kine,getData.pote+getData.kine)))),
    #xminorticksvisible = true, xminorgridvisible = true,
    xlabel = "Cluster size [particles]", ylabel = "Counts",
    title = "Cluster counts"
    )
hist!(f[1,1],getDataClusterOvito.clusterOvito,bins=10)


