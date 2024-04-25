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
 include("isingModel_parameters_parallel.jl")
 include("isingModel_functions_parallel.jl")

# Start the system with random spins
sys = wsample(σs,[1-η,η],(Ng,Ng));

# ids with its neighbors
part = idNeighbors(Ng);

# Create the domain
domExp = 1:Nexp

# Create the partitions
chunks = Iterators.partition(domExp,Nexp÷Nth);

@time begin
# Task
task = map(chunks) do s
    Threads.@spawn map(l->metropoliAlgorithm(sys,l,Nth),s)
end

# Fetch
# (states,energ,mag)
infoSim = fetch.(task)
end

hamiltonian = last.(infoSim);

# Limits fot the average of the quantities.
indc = map(s-> (length(first(hamiltonian[s]))÷100)*10 ,1:length(hamiltonian))

