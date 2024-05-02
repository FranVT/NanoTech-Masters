module MetropolisAlgorithm

export results

using Base.Threads
using Distributions
using Random

# Includes parameters and auxiliary functions
include("parameters.jl")
include("Functions.jl")

# Initial state
σ = wsample(σs,[1-η,η],(Ng,Ng));
part = Functions.idNeighbors(Ng);

results = Functions.metropoliAlgorithm(σ,Nsteps,part,J,B,kb,T,Ng)

# Clean the data
#states = filter(!iszero,states);
#energ = filter(!iszero,energ);
#mag = filter(!iszero,mag);

end