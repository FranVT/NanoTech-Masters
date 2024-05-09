"""
    Script ot create th graphs
"""

using Plots
using Nord
using FileIO
using JLD
using LaTeXStrings
using Distributions

include("parameters.jl")

# Get the info
"""
(energ25,magn25) = load(string(path,"Ng_25/rangeT_",first(T),"_",last(T),"hamiltonian.jld"),"hamiltonian");
(meanT25,varT25) = load(string(path,"Ng_25/rangeT_",first(T),"_",last(T),"meanVar.jld"),"info");


(energ15,magn15) = load(string(path,"Ng_15/rangeT_",first(T),"_",last(T),"hamiltonian.jld"),"hamiltonian");
(meanT15,varT15) = load(string(path,"Ng_15/rangeT_",first(T),"_",last(T),"meanVar.jld"),"info");

(energ5,magn5) = load(string(path,"Ng_5/rangeT_",first(T),"_",last(T),"hamiltonian.jld"),"hamiltonian");
(meanT5,varT5) = load(string(path,"Ng_5/rangeT_",first(T),"_",last(T),"meanVar.jld"),"info");


# Get the mean and varaince of the magnetization

meanM25 = map(nT->mean( mean.(map(nexp->abs.(magn25[nT][nexp][div(Ng*Ng*Nsteps,5):end]),1:Nexp))),eachindex(magn25));
varM25 = map(nT->var( var.(map(nexp->abs.(magn25[nT][nexp][div(Ng*Ng*Nsteps,5):end]),1:Nexp))),eachindex(magn25));

meanM15 = map(nT->mean( mean.(map(nexp->abs.(magn15[nT][nexp][div(Ng*Ng*Nsteps,5):end]),1:Nexp))),eachindex(magn15));
varM15 = map(nT->var( var.(map(nexp->abs.(magn15[nT][nexp][div(Ng*Ng*Nsteps,5):end]),1:Nexp))),eachindex(magn15));

meanM5 = map(nT->mean( mean.(map(nexp->abs.(magn5[nT][nexp][div(Ng*Ng*Nsteps,5):end]),1:Nexp))),eachindex(magn5));
varM5 = map(nT->var( var.(map(nexp->abs.(magn5[nT][nexp][div(Ng*Ng*Nsteps,5):end]),1:Nexp))),eachindex(magn5));
"""

# Graphics

"""
    One experiment for each one of the temperatures, energy ang magnetization
"""

pE25 = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Energy}",
    xlabel = L"\mathrm{Monte~Carlo~Steps}",
    size = (1.5*480,480),
    framestyle = :box,
    gridaplha = 1,
    background_color = Nord.black
)
plot!(pE25,(last.(energ25)[1:33:100])/25^2,
    ylabel= L"E ",
    linecolor = [Nord.blue Nord.orange Nord.red Nord.green],
    label = [L"T=1.3" L"T=1.8" L"T=2.4" L"T=3"],
    legend_position =:topleft
)

pM25 = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Magnetization}",
    xlabel = L"\mathrm{Monte~Carlo~Steps}",
    size = (1.5*480,480),
    framestyle = :box,
    gridaplha = 1,
    background_color = Nord.black
)
plot!(pM25,(last.(magn25)[1:33:100])/25^2,
    ylabel= L"M ",
    linecolor = [Nord.blue Nord.orange Nord.red Nord.green],
    label = [L"T=1.3" L"T=1.8" L"T=2.4" L"T=3"],
    legend_position =:bottomleft
)


savefig(pE25,"energyN25MOnteCarlosteps.pdf")
savefig(pM25,"magnetizationN25MOnteCarlosteps.pdf")


""" 
    Variance and mean of the Energy
"""
mkszμ = 2;
mkszσ = 4;

# Plot of the Variance and the Mean of the Energy
μσEplot = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Energy~Average~and~Variance}",
    xlabel = L"T",
    size = (1.5*480,480),
    framestyle = :box,
    gridaplha = 1,
    background_color = Nord.black
)
μσEplot_twin = twinx(μσEplot)

# Mean
#plot!(μσEplot,T,meanT/Ng^2,label=false,linecolor=Nord.blue)
scatter!(μσEplot,T,meanT25/25^2,
    ylabel= L"\langle E \rangle",
    label = L"\langle E \rangle_{N = 25}",
    legend_position =:topleft,
    markercolor = Nord.blue,
    markerstrokecolor = Nord.blue,
    markersize = mkszμ,
)
scatter!(μσEplot,T,meanT15/15^2,
    ylabel= L"\langle E \rangle",
    label = L"\langle E \rangle_{N = 15}",
    legend_position =:topleft,
    markercolor = Nord.orange,
    markerstrokecolor = Nord.orange,
    markersize = mkszμ,
)
scatter!(μσEplot,T,meanT5/5^2,
    ylabel= L"\langle E \rangle",
    label = L"\langle E \rangle_{N = 5}",
    legend_position =:topleft,
    markercolor = Nord.green,
    markerstrokecolor = Nord.green,
    markersize = mkszμ,
)

# Variance
plot!(μσEplot_twin,T,varT25/(25^2),label=false,linecolor=Nord.blue)
scatter!(μσEplot_twin,T,varT25/25^2,
    ylabel=L"\sigma^{2}",
    label = L"\sigma^{2}_{N = 25}",
    legend_position =:bottomleft,
    markershape = :xcross,
    markercolor = Nord.blue,
    markerstrokecolor = Nord.blue,
    markersize = mkszσ,
)

plot!(μσEplot_twin,T,varT15/(15^2),label=false,linecolor=Nord.orange)
scatter!(μσEplot_twin,T,varT15/15^2,
    ylabel=L"\sigma^{2}",
    label = L"\sigma^{2}_{N = 15}",
    legend_position =:bottomleft,
    markershape = :xcross,
    markercolor = Nord.orange,
    markerstrokecolor = Nord.orange,
    markersize = mkszσ,
)

plot!(μσEplot_twin,T,varT5/(5^2),label=false,linecolor=Nord.green)
scatter!(μσEplot_twin,T,varT5/5^2,
    ylabel=L"\sigma^{2}",
    label = L"\sigma^{2}_{N = 5}",
    legend_position =:bottomleft,
    markershape = :xcross,
    markercolor = Nord.green,
    markerstrokecolor = Nord.green,
    markersize = mkszσ,
)

savefig(μσEplot,"energyMean.pdf")

""" 
    Variance and mean of the Magnetization
"""
# Plot of the Variance and the Mean of the MAgnetization
μσMplot = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Magnetization~Average~and~Variance}",
    xlabel = L"T",
    size = (1.5*480,480),
    framestyle = :box,
    gridaplha = 1,
    background_color = Nord.black
)
μσMplot_twin = twinx(μσMplot)

# Mean
#plot!(μσMplot,T,meanT/Ng^2,label=false,linecolor=Nord.blue)
scatter!(μσMplot,T,meanM25/25^2,
    ylabel= L"\langle M \rangle",
    label = L"\langle M \rangle_{N=25}",
    legend_position =:topleft,
    markercolor = Nord.blue,
    markerstrokecolor = Nord.blue,
    markersize = mkszμ,
)
scatter!(μσMplot,T,meanM15/15^2,
    ylabel= L"\langle M \rangle",
    label = L"\langle M \rangle_{N=15}",
    legend_position =:topleft,
    markercolor = Nord.orange,
    markerstrokecolor = Nord.orange,
    markersize = mkszμ,
)
scatter!(μσMplot,T,meanM5/5^2,
    ylabel= L"\langle M \rangle",
    label = L"\langle M \rangle_{N=5}",
    legend_position =:topleft,
    markercolor = Nord.green,
    markerstrokecolor = Nord.green,
    markersize = mkszμ,
)


# Variance
plot!(μσMplot_twin,T,varM25/25^2,label=false,linecolor=Nord.blue)
scatter!(μσMplot_twin,T,varM25/25^2,
    ylabel=L"\sigma^{2}",
    label = L"\sigma^{2}_{N = 25}",
    legend_position =:bottomleft,
    markershape = :xcross,
    markercolor = Nord.blue,
    markerstrokecolor = Nord.blue,
    markersize = mkszσ,
)

plot!(μσMplot_twin,T,varM15/15^2,label=false,linecolor=Nord.orange)
scatter!(μσMplot_twin,T,varM15/15^2,
    ylabel=L"\sigma^{2}",
    label = L"\sigma^{2}_{N = 15}",
    legend_position =:bottomleft,
    markershape = :xcross,
    markercolor = Nord.orange,
    markerstrokecolor = Nord.orange,
    markersize = mkszσ,
)

plot!(μσMplot_twin,T,varM5/5^2,label=false,linecolor=Nord.green)
scatter!(μσMplot_twin,T,varM5/5^2,
    ylabel=L"\sigma^{2}",
    label = L"\sigma^{2}_{N = 5}",
    legend_position =:bottomleft,
    markershape = :xcross,
    markercolor = Nord.green,
    markerstrokecolor = Nord.green,
    markersize = mkszσ,
)

savefig(μσMplot,"magnetizationMean.pdf")
