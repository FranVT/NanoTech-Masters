"""
    Script to compute the mean and standard deviation of a sample
"""

using CSV
using DataFrames

path = "F://GitHub//NanoTech-Masters//1_SisCom//code//quiz2//Histogram1-1.csv"

# Get the info
info = CSV.read(path,DataFrame)

# Compute the mean
N = sum(info.H);    # Sample size
sumN = sum(info.x .* info.H);   # Get the sum of the 
μ = sumN/N;     # Get the mean

# Compute the Standard deviation
μ2 = sum((info.x.^2) .* info.H)/N;  # Compute the mean od the square values
μ22 = μ^2;  # Compute the quared of the mean
σ2 = μ2 - μ22   # Compute the variance
σ = sqrt(σ2)    # Compute the standard deviation