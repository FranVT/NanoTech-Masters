"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV

include("functions.jl")

# Get a data frame with all the data.dat files information
df = getDF();

# Desire parameters 
gamma_dot=0.1;
cl_con=0.05;

# New data frame
df_new = filter([:"Shear-rate",:"CL-Con"] => (f1,f2) -> f1==gamma_dot && f2==cl_con,df);

# Create the directories
data_path=joinpath.(df_new."main-directory",df_new."file0");


aux= open(data_path[1]) do f
        map(s->split(s," "),readlines(f))
    end



#map(s->split(s," "),readlines(data_path...))[2:end]; 
#collect.(map(s->parse.(Float64,s),split.(readlines(data_path...)," ")[3:end]))



function extractInfo(file_dir)
"""
   Function that reads the files and extract all the information
"""
    return reduce(hcat,map(s->parse.(Float64,s),split.(readlines(file_dir)," ")[3:end]))
end



