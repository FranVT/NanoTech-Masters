"""
    Script for plots
"""

#using GLMakie

include("functions.jl")

# Create the file with the dirs names
run(`bash getDirs.sh`)
# Store the dirs names
dirs_aux = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
    end

dirs=dirs_aux; #[2:end];

# File names 

file_name = (
             "parameters",
             "energy_assembly.fixf",
             "wcaPair_assembly.fixf",
             "patchPair_assembly.fixf",
             "swapPair_assembly.fixf",
             "energy_shear.fixf",
             "wcaPair_shear.fixf",
             "patchPair_shear.fixf",
             "swapPair_shear.fixf",
             "stressVirial_shear.fixf"
            );

# Get parameters from the directories
parameters=getParameters(dirs,file_name);

# Get the data from the fix files
data=getData(dirs,file_name);

# Re-organize information
energy_assembly=map(s->data[s][1],eachindex(data));
wcaPair_assembly=map(s->data[s][2],eachindex(data));
patchPair_assembly=map(s->data[s][3],eachindex(data));
swapPair_assembly=map(s->data[s][4],eachindex(data));
energy_shear=map(s->data[s][5],eachindex(data));
wcaPair_shear=map(s->data[s][6],eachindex(data));
patchPair_shear=map(s->data[s][7],eachindex(data));
swapPair_shear=map(s->data[s][8],eachindex(data));
stress_shear=map(s->data[s][9],eachindex(data));

time_shear=parameters[1][13]*parameters[1][18]*parameters[1][15];
time_rlxo1=time_shear;
time_rlxf1=time_rlxo1+parameters[1][13]*parameters[1][19];
time_rlxo2=time_rlxf1+time_shear;
time_rlxf2=time_rlxo2+parameters[1][13]*parameters[1][20];
time_rlxo3=time_rlxf2+time_shear;
time_rlxf3=time_rlxo3+parameters[1][13]*parameters[1][21];
time_rlxo4=time_rlxf3+time_shear;
time_rlxf4=time_rlxo4+parameters[1][13]*parameters[1][22];


