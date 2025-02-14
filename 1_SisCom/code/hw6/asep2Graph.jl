"""
    File that create the animation
"""

# Packages
using Plots, LaTeXStrings
using FileIO, JLD 

# Path to acces the information
path = "/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk6_4";

# Packing fraction
η = 10000;

# Number of experiment
ne = 1;

# Load the parameters
parms = load(string(path,"/",η,"parameters.jld"),"parms");
values = load(string(path,"/",η,"values.jld"),"values");

# Plots 
function graph(states,Np,it)
    scatter(states,
            markersize = 2,
            legend_position = :outertop,
            title = L"\mathrm{Particles}",
            xlabel = L"\mathrm{Position}",
            label = string(L"t = ",latexstring("$(round(it;digits=2))")),
            ylims = (0.5,1.5),
            xlims = (0,Np+1),
            size = (480,180),
            aspect_ratio = 1,
            formatter = :plain,
            grid = false,
            framestyle = :box,
            ticks = false
    )
end

anim = @animate for it ∈ 1:1:values[3]
    aux = load(string(path,"/",η,"state",ne,"_",it,".jld"),"σ");
    aux[aux.==0].=-10;
    graph(aux,parms[1],it*values[2])
end
gif(anim,string(path,"/",η,"gifASEP.gif"),fps=24)
