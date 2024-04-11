"""
    Assigment 6
    Asymmetric Simple Exlusion Process
"""

# Packages and stuff
using Random, Distributions
using FileIO, JLD
include("asepFunc.jl")

# Set the path to save the data
path = "/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk6_3";

# Setting the sead and the random number generator
Random.seed!(4321)

# Define the parameters
"""
    Nb:     Number of boxes
    η:      Packing fraction
    Np:     Number of particles
    α:      Rate to move forward
    β:      Rate to move backward
    ϕ:      Possible change 
"""
Nb = 100;
η = 3/4;
Np = ceil(Int64,η*Nb);
α = 3;
β = 2;
parms = (Nb,η,Np,α,β);

# Discretize the values
"""
    dx:     Spatial interval (Can be interpreted as particle size)
    dt:     Temporal interval
    Nt:     Time Steps
    Ne:     Number of experiments
"""
dx = 1;
dt = 1e-2;
Nt = 500;
Ne = 100;
values = (dx,dt,Nt,Ne);

# Save parameters and stuff 
save(File(format"JLD",string(path,"/parameters.jld")),"parms",parms);
save(File(format"JLD",string(path,"/values.jld")),"values",values);

# Make Ne experiments
for ite ∈ 1:Ne
    propagation(parms...,values[1:3]...,ite,0)
end
