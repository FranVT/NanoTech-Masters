
# Include the parameters

include("Functions.jl")
rMA = include("MetropolisAlgorithmMultipleExp.jl");

states = first.(rMA.results);
ham = last.(rMA.results);
energ = first.(ham.results);
