module IsingMultipleTemperatures
"""
    Module to compute multiple expriments of the Ising Model with the different temeprature:
        Constante parameters:
            Ng
            Nsteps
            part
            J
            B
"""

export multTemp

using Base.Threads
using Distributions
using Random

# Includes parameters and auxiliary functions
include("parameters.jl")
include("Functions.jl")

multTemp = map(eachindex(T)) do l
    # Initial state
    σ = [wsample(σs,[1-η,η],(Ng,Ng)) for s∈1:Nexp];
    part = Functions.idNeighbors(Ng);

    # Initial energies
    chunkThreads = Iterators.partition(1:Nexp,div(Nexp,3,RoundUp))
    taskE = map(chunkThreads) do s
        Threads.@spawn map(l->first(Functions.computeHamiltonianThreads(J,B,σ[l],part,3)),s)
    end

    Eot = reduce(append!,fetch.(taskE));

    # Use Threads 
    task = map(chunkThreads) do s
        Threads.@spawn map(l->Functions.metropoliAlgorithm(σ[l],Ng,Nsteps,part,J,B,kb,T[l],Eot[l]),s)
    end

    results = reduce(append!,fetch.(task));
end

end