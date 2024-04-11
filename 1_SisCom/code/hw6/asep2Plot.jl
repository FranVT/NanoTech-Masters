"""
    Script that create the plots
"""

# Packages
using Plots, LaTeXStrings
using FileIO, JLD 

# Path to acces the information
path = "/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk6_2";

# Load the parameters
parms = load(string(path,"/parameters.jld"),"parms");
values = load(string(path,"/values.jld"),"values");

# Load the currents
j_p = load(string(path,"/j_p.jld"),"j_p");
j_n = load(string(path,"/j_n.jld"),"j_n");

# Data manipulation
j_p = cumsum(j_p./parms[1]);
j_n = cumsum(j_n./parms[1]);
j = j_p .- j_n;

# Plots 
plot(j_p)
plot!(j_n)
plot!(j)
