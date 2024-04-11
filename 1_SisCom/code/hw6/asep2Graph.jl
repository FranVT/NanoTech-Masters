"""
    File that create the animation
"""

# Packages
using Plots, LaTeXStrings
using FileIO, JLD 

# Path to acces the information
path = "/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk6";

# Load the parameters
parms = load(string(path,"/parameters.jld"),"parms");
values = load(string(path,"/values.jld"),"values");

# Plots 
function graph(states,Np,it)
scatter(states,
        markersize = 5,
        legend_position = :outertop,
        title = L"\mathrm{Particles}",
        xlabel = L"\mathrm{Position}",
        label = string(L"t = ",latexstring("$(it)")),
        ylims = (0.5,1.5),
        xlims = (0,Np+1),
        size = (480,280),
        aspect_ratio = 1,
        formatter = :plain,
        grid = false,
        framestyle = :box,
        ticks = false
)
end

anim = @animate for it ∈ 1:1:values[3]
    aux = load(string(path,"/state_",it*values[2],".jld"),"σ");
    graph(aux,parms[1],it)
end
gif(anim,string(path,"/gifASEP.gif"),fps=24)
