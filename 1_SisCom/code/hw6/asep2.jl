"""
    Assigment 6
    Asymmetric Simple Exlusion Process
"""

# Packages and stuff
using Random, Distributions
using FileIO, JLD
include("asepFunc.jl")

# Set the path to save the data
path = "/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk6_4";

# Setting the sead and the random number generator
Random.seed!(4321)

# Range of packing fractions
ϕ = 20/80:20/80:1;

# Save files options
sd = 1;
sj = 0;

for itp = 1:length(ϕ) 
    experimentASEP(ϕ[itp],sd,sj);
end

