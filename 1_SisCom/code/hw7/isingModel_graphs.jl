"""
    Script for graphs
"""

using Nord

splot = scatter(
        size = (460,460),
        label = false,
        framestyle = :box,
        xticks = false,
        yticks = false,
        xlims = (0,Ng+1),
        ylims = (0,Ng+1),
        aspect_ratio = 1/1,
        background_color = Nord.grey,
        legend_position = :outertop,
        legend_column = 2
)

scatter!(splot,first.(part)[reshape(sys.==1,Ng*Ng)],
    mc = Nord.white,
    markersize = 1.5,
    markerstrokecolor = Nord.grey,
    label = L"\sigma = 1"
)
scatter!(splot,first.(part)[reshape(sys.==-1,Ng*Ng)],
    mc =Nord.black,
    markersize = 1.5,
    markerstrokecolor = Nord.grey,
    label = L"\sigma = -1"
)


hmplot = heatmap(sys,
    xlims = (0,Ng+1),
    ylims = (0,Ng+1),
    aspect_ratio = 1/1
)