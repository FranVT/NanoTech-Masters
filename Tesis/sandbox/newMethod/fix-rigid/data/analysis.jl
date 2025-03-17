"""
    Script to analyse the information of the simulations
"""

using DataFrames, CSV

include("functions.jl")

# Get a data frame with all the data.dat files information
df = getDF();

# Filter the desire directories
gamma_dot=0.01;
df_new = filter(row -> row."Shear-rate"==gamma_dot,df);
