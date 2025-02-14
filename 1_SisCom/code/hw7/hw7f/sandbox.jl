using Distributions
using Random
using Distributions
using Plots

include("parameters.jl")
include("Functions.jl")

"""
# Se the random seed
Random.seed!(4321)

Ng = 2^6;
σs = [-1,1];
η = 0.5;
J = 1;
B = 1;
kb = 1;

σ = ones(Int64,Ng,Ng);
nL = idNeighbors(Ng);
γ = smallSysChange(σ,nL,5);

hσ = computeHamiltonian(J,B,σ,nL);
hγ = computeHamiltonian(J,B,γ,nL);

ΔE1 = first(hγ) - first(hσ);

ΔE2 = computeDeltaE(J,B,σ,nL,Ng,5)

aux = Functions.idNeighbors(4);
hamStates = map(l->Functions.computeHamiltonian(1,1,states[l],aux),eachindex(states))
"""

Random.seed!(4321)

σ = wsample(σs,[1-η,η],(Ng,Ng));
part = Functions.idNeighbors(Ng;);
Eo = first(Functions.computeHamiltonian(J,B,σ,part));

results = Functions.metropoliAlgorithm(σ,Ng,Nsteps,part,J,kb,T,Eo)

states = first(results);
ham = last(results);

energΔ = first(ham)[1,:];
energH = first.(map(s->Functions.computeHamiltonian(J,B,s,part),states))

ΔE1 = first(ham)[2,2:end];
ΔE2 = diff(energH)

p = plot()
plot!(p,energΔ,label = "Δ")
plot!(p,energH,label = "States")
scatter!(p,energΔ,label = "Δ")
scatter!(p,energH,label = "States")

d = plot()
plot!(d,ΔE1,label = "Δ")
plot!(d,ΔE2,label = "States")
scatter!(d,ΔE1,label = "Δ")
scatter!(d,ΔE2,label = "States")

hstates = map(s->s|>heatmap,states)