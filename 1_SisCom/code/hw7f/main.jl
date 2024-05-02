
using Distributions
using Plots
using ProgressMeter

rmT = include("multipleTemperatures.jl")

"""
# Exp
rmT.multTemp[1]
# State
rmT.multTemp[1][1]
# Ham
rmT.multTemp[1][2]

# Hamiltonian of N experiments with the same temperature
ham = last.(rmT.multTemp[1]);
energ = first.(ham);
"""

energ = map(l->first.(last.(rmT.multTemp[l])),eachindex(rmT.multTemp));

plot(energ,label=false)


mediaE = map(l->mean(last.(energ[l])),eachindex(rmT.multTemp))

"""
#states = map(s->first.(rmT.multTemp[l]),eachindex(rmT.multTemp));
ham = map(l->last.(rmT.multTemp[l]),eachindex(rmT.multTemp));
energ = map(l->last.(ham[l]),eachindex(ham));

# Expected value and variance for each temperature.
expvalEnerg = map(l->mean(energ[l]),eachindex(energ));
varEnerg = map(l->var(energ[l]),eachindex(energ));

# Expected value of the bla bla
#PHD to DTU
plot(last.(expvalEnerg))
"""