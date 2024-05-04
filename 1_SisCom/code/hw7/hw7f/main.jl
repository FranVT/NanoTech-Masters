
using Distributions
using Plots
using ProgressMeter

include("parameters.jl")
include("Functions.jl")
rmT = include("multipleTemperatures.jl")

# Get the data
#states = map(l->first.(rmT.multTemp[l]),eachindex(rmT.multTemp));
energ = map(l->first.(last.(rmT.multTemp[l])),eachindex(rmT.multTemp));
magn = map(l->last.(last.(rmT.multTemp[l])),eachindex(rmT.multTemp));

# Compute the mean and the variance
meanT = map(nT->mean( mean.(map(nexp->energ[nT][nexp][div(Ng*Ng*Nsteps,5):end],1:Nexp))),eachindex(energ));
varT = map(nT->var( var.(map(nexp->energ[nT][nexp][div(Ng*Ng*Nsteps,5):end],1:Nexp))),eachindex(energ));

# Plots random
pm = scatter(T,meanT,label=false)
        plot!(pm,T,meanT,label=false)
vm = scatter(T,varT,label=false)
    plot!(vm,T,varT,label=false)


save(File(format"JLD",string(path,"/rangeT_",T[1],"_",T[end],"meanVar.jld")),"info",(meanT,varT))
save(File(format"JLD",string(path,"/rangeT_",T[1],"_",T[end],"hamiltonian.jld")),"hamiltonian",(energ,magn))
