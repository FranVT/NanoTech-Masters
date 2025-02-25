"""
    Script to compute the rate of a Poisson Process
"""

using CSV
using DataFrames

path = "F://GitHub//NanoTech-Masters//1_SisCom//code//quiz2//calls.csv"

# Get the info
info = CSV.read(path,DataFrame)
dims = size(info);

calls = info[:,2:end]

# Mean of the calls thru time
s = combine(calls,names((calls),Real).=>sum)./dims[1];

# Mean of the calls during simulations
λ = sum(eachcol(s./(dims[2]-1)))
