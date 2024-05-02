
# Include the parameters

include("Functions.jl")
rMA = include("IsingMultipleExperiments.jl");

states = first.(rMA.results);
ham = last.(rMA.results);
energ = first.(ham.results);
