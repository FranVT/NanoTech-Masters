
# Include the parameters

include("Functions.jl")
rMA = include("MetropolisAlgorithm.jl");

states = first(rMA.results);
ham = last(rMA.results);

allHam = Functions.computeAllHam(states);

e1 = first(ham)
e2 = first.(allHam)

# Compariason plot
p = plot()
plot!(p,e1,label="ΔE")
plot!(p,e2,label="Compute")
plot!(p,first.(Functions.computeAllHam(unique(states))),label="ΔE")
