"""
    Script to visualize the diffusion
"""

using Plots
using LaTeXStrings


plot()
plot!(r,sol[:,1])
plot!(r,sol[:,end])
plot!(r,solhd[:,end])

solplot = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Difussion}",
    xlabel = L"x~[\mathrm{mts}]",
    size = (1.5*480,480),
    framestyle = :box,
    minorgrid = true,
    #gridalpha = 1.5,
    #minorgridalpha = 0.25,
    background_color = :black
)
solplot_twin = twinx(solplot)

plot!(solplot,r,sol[:,1],
    label=L"\mathrm{Initial~condition}",
    ylabel=L"P(x,0)",
    ylims=(0,1),
    legend_position =:topleft,
    linewidth = 1.5,
    linecolor = :white
)
plot!(solplot_twin,r,[solhd[:,end] sol[:,end]],
    minorgrid = true,
    label=[L"\mathrm{Final~state~harmonic~difussion}" L"\mathrm{Final~state~difussion}"],
    ylabel=L"P(x,100)",
    ylims=(0,0.25),
    legend_position =:bottomright,
    linewidth = 1.5,
    linestyle =:dash
)

savefig(solplot,"difussionSols.pdf")
