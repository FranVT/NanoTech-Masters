
# Include the parameters

include("Functions.jl")
rMA = include("MetropolisAlgorithm.jl");

states = first(rMA.results);
ham = last(rMA.results);

allHam = Functions.computeAllHam(states);

e1 = first(ham)
e2 = first.(allHam)
