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
# Excecute the MonteCarlo algorithm
metropoliAlgorithm(sys)
end

# Retreive the information
(info, frames) = getInfo(path,Ng,Nsteps);

# Compute the energy for all the states 
@time begin
    energ = map(s->computeEnergy(J,B,info[:,:,s],part,Ng),1:frames);
end

# Compute the magnetization for all the states
@time begin
    mag = map(s->sum(Int64,info[:,:,s],sr),1:1:frames);
end




