"""
    Central Limit Theorem
"""

using Distributions
using Random
using Plots

Random.seed!(1234)

Nexp = 10000;

# Set the seed for the N experiments
seeds = abs.(rand(Int64,Nexp));

Nsample = 1000;

# Posibility and probability
σ = [-1,1];
η = [0.5,0.5]

function samples(s,σ,η,N)
    Random.seed!(s);
    return wsample(σ,η,N)
end

# Create the data set
info = reshape(Iterators.flatmap(s->samples(seeds[s],σ,η,Nsample),1:Nexp)|>collect,Nexp,Nsample)

# Manipulation for the histogram
infoH = sum(info,dims=2)

# Histogram
histogram(infoH)



