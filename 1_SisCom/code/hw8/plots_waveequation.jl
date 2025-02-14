
using Plots
using LaTeXStrings

plotswave = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Wave~propagation}",
    xlabel = L"x~[\mathrm{mts}]",
    size = (480,480),
    framestyle = :box
)
heatmap!(plotswave,r,r,sol[:,:,end],
    clims=(-3.5,3.5),
    colorbar_title = L"u(x,y,25)"
    )

savefig(plotswave,"waveEquationSols.pdf")

