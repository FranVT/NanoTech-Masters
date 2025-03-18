"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
using Plots, LaTeXStrings

include("functions.jl")




# Get a data frame with all the data.dat files information
df = getDF();

# Desire parameters 
gamma_dot=0.1;
cl_con=0.01;
Npart=1500;

# New data frame
df_new = filter([:"Shear-rate",:"CL-Con",:"Npart"] => (f1,f2,f3) -> f1==gamma_dot && f2==cl_con && f3==Npart,df);# Get the information in data frames

(df_assembly, df_shear, df_stressA, df_stressS) = extractInfo(df_new);

"""
    Plots
"""

plot(title=L"\mathrm{Temperature}",xlabel=L"\mathrm{LJ}~\tau",ylabel=L"T");
plot!(df_new."time-step".*df_assembly."TimeStep",df_assembly."Temp",label=L"\mathrm{Assembly}");
plot!(df_new."time-step".*(last(df_assembly."TimeStep") .+ df_shear."TimeStep"),df_shear."Temp",label=L"\mathrm{Shear}");



