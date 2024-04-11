"""
    File t create the animation and plots require in the homework
"""

# Packages
using Plots, LaTeXStrings
using FileIO, JLD 

# Path to acces the information
path = "/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk6";

# Load the parameters
parms = load(string(path,"/parameters.jld"),"parms");
values = load(string(path,"/values.jld"),"values");

# Load all the states
states = zeros(parms[1],values[3]);

for it = 1:values[3]
    states[:,it] = load(string(path,"/state_",it,".jld"),"σ");
end

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

for it = 1:values[3]
    
end

