"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV

include("functions.jl")

# Get a data frame with all the data.dat files information
df = getDF();

# Desire parameters 
gamma_dot=0.01;
damp=0.5;

# New data frame
df_new = filter([:"Shear-rate",:"damp"] => (f1,f2) -> f1==gamma_dot && f2==damp,df);

# Create the directories
data_path=joinpath.(df_new."main-directory",df_new."file0");



