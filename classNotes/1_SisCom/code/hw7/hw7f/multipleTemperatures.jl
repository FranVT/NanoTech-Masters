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
using ProgressMeter

# Includes parameters and auxiliary functions
include("parameters.jl")
include("Functions.jl")

# Set the seed
Random.seed!(seed)

multTemp = @showprogress(map(eachindex(T)) do l

    # Initial state
    σ = [wsample(σs,[1-η,η],(Ng,Ng)) for s∈1:Nexp];
    part = Functions.idNeighbors(Ng);

    # Initial energies
    chunkThreads = Iterators.partition(1:Nexp,div(Nexp,Threads.nthreads(),RoundUp))
    taskE = map(chunkThreads) do s
        Threads.@spawn map(l->first(Functions.computeHamiltonian(J,B,σ[l],part)),s)
    end

    Eot = reduce(append!,fetch.(taskE));

    # Use Threads 
    task = map(chunkThreads) do s
        Threads.@spawn map(r->Functions.metropoliAlgorithm(σ[r],Ng,Nsteps,part,J,kb,T[l],Eot[r]),s)
    end

    results = reduce(append!,fetch.(task));
end)

end