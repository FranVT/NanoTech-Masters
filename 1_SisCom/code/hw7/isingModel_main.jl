"""
    Ising Model 

"""

# Packages
using Random, Distributions
using LinearAlgebra
using Plots

 # Configure the random generator
 Random.seed!(4321)

 # Include functions and parameters
 include("isingModel_parameters.jl")
 include("isingModel_functions.jl")

# Start the system with random spins
sys = wsample(σs,[1-η,η],(Ng,Ng));

# ids with its neighbors
part = idNeighbors(Ng);

# Compute the energy 
energ = computeEnergy(J,B,sys,part,Ng);

# Make an energy comparsion between systems
idc = rand(1:Ng*Ng,10);
nsys = map(s->smallSysChange(sys,part,σs,Ng,s),idc);

nenerg = map(s->computeEnergy(J,B,nsys[s],part,Ng),1:length(nsys))

denerg = nenerg .- energ

