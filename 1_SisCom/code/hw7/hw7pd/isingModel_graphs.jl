"""
    Script for load the information and create the graphs
"""

using FileIO, JLD
using Distributions
using Plots

# Include the parameters
include("isingModel_parameters.jl")

function getInfo(T,nExp)
    return load(string(path,"/T_",T,Ng,nExp,"info.jld"),"info");
end

function getInfoEc(T,nExp)
    return load(string(path,"/T_",T,Ng,nExp,"info_Ec.jld"),"info");
end

function getInfoEm(T,nExp)
    return load(string(path,"/T_",T,Ng,nExp,"info_Em.jld"),"info");
end

(T,energC,magC) = getInfoEc(T,Nexp)

(T,energM,magM) = getInfoEm(T,Nexp)

"""
# Get the info
(T,energ,mag) = getInfo(T,Nexp)

# Compute the mean and the variance
μE = mean.(energ);
σE = var.(energ);
μM = mean.(mag);
σM = var.(mag);

# Plots
pe = plot(energ,label=false)
pm = plot(mag,label=false)

pee = plot(μE,label=false)
plot!(pee,μE.+σE,linestyle=:dash)
plot!(pee,μE.-σE,linestyle=:dash)
"""