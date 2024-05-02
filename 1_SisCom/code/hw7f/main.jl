
using Distributions
using Plots

rmT = include("multipleTemperatures.jl")


#states = map(s->first.(rmT.multTemp[l]),eachindex(rmT.multTemp));
ham = map(l->last.(rmT.multTemp[l]),eachindex(rmT.multTemp));
energ = map(l->last.(ham[l]),eachindex(ham));

# Expected value and variance for each temperature.
expvalEnerg = map(l->mean(energ[l]),eachindex(energ));
varEnerg = map(l->var(energ[l]),eachindex(energ));


# Expected value of the bla bla
#PHD to DTU
plot(last.(expvalEnerg))
