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
    # Excecute the MonteCarlo algorithm Nexp times
    for nexp ∈ 1:Nexp
        metropoliAlgorithm(sys,nexp)
    end
end

# Create the domain
domExp = 1:Nexp

# Create the partitions
chunks = Iterators.partitions(domExp,Nexp÷Nth);

# Task
task = map(chunks) do s
    Threads.@spawn metropoliAlgorithm(sys,s,Nth)
end

# Fetch
# (states,energ,mag)
infoSim = fetch.(task)

hamiltonian = last.(infoSim);

# Limits fot the average of the quantities.
indc = map(s-> (length(first(hamiltonian[s]))÷100)*10 ,1:length(hamiltonian))

