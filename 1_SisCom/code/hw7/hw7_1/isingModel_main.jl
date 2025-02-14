"""
    Ising Model 

"""

# Packages
using Random, Distributions
using FileIO, JLD
using LinearAlgebra

 # Configure the random generator
 Random.seed!(4321)

 # Include functions and parameters
 include("isingModel_parameters.jl")
 include("isingModel_functions.jl")

# Start the system with random spins
sys = wsample(σs,[1-η,η],(Ng,Ng));

# ids with its neighbors
part = idNeighbors(Ng);

@time begin
    # Excecute the MonteCarlo algorithm N times
    for nexp ∈ 1:Nexp
        metropoliAlgorithm(sys,nexp)
    end
end
