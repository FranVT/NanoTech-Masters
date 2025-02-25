module IsingMultipleExperiments
"""
    Module to compute multiple expriments of the Ising Model with the same parameters:
        Parameters:
            Ng
            Nsteps
            part
            J
            B
            T
"""
export results, chunkThreads,Eot

using Base.Threads
using Distributions
using Random

# Includes parameters and auxiliary functions
include("parametersExp.jl")
include("Functions.jl")

# Initial state
σ = [wsample(σs,[1-η,η],(Ng,Ng)) for s∈1:Nexp];
part = Functions.idNeighbors(Ng);

# Stuff for Paralelization

# Initial energies
chunkThreads = Iterators.partition(1:Nexp,div(Nexp,2,RoundUp))
taskE = map(chunkThreads) do s
    Threads.@spawn map(l->first(Functions.computeHamiltonianThreads(J,B,σ[l],part,2)),s)
end

Eot = reduce(append!,fetch.(taskE));

# Use Threads 
task = map(chunkThreads) do s
    Threads.@spawn map(l->Functions.metropoliAlgorithm(σ[l],Ng,Nsteps,part,J,B,kb,T,Eot[l]),s)
end

results = reduce(append!,fetch.(task))

end