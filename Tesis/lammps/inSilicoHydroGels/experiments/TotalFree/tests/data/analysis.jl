"""
    Script to run analysis from lammps simulation data
"""

using FileIO
using GLMakie

include("functions.jl")

# Create the file with the dirs names
run(`bash getDir.sh`)
# Store the dirs names
dirs = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
    end

# File names 

file_name = (
             "parameters",
             "energy_assembly.fixf",
             "bondlenCL_assembly.fixf",
             "bondlenPatch_assembly.fixf",
             "energy_shear.fixf",
             "bondlenCL_shear.fixf",
             "bondlenPatch_shear.fixf",
             "stressVirial_shear.fixf"
            );

# Get parameters from the directories
#parameters=getParameters(dirs,file_name);

# Get the data from the fix files
#data=getData(dirs,file_dir);

# Re-organize the information
#energy_assembly=map(s->data[s][1],eachindex(info));
#bondlenCL_assembly=map(s->data[s][2],eachindex(info));
#bondlenPt_assembly=map(s->data[s][3],eachindex(info));
#energy_shear=map(s->data[s][4],eachindex(info));
#bondlenCL_shear=map(s->data[s][5],eachindex(info));
#bondlenPt_shear=map(s->data[s][6],eachindex(info));
#stress_shear=map(s->data[s][7],eachindex(info));

# Energy and Temperature figure

# Time
time_assembly=parameters[1][7].*energy_assembly[1][1,:];
time_shear=parameters[1][7].*energy_shear[1][1,:].+last(time_assembly);

# Energy
T_assembly=reduce(hcat,map(s->energy_assembly[s][2,:],eachindex(energy_assembly)));
U_assembly=reduce(hcat,map(s->energy_assembly[s][3,:],eachindex(energy_assembly)));
K_assembly=reduce(hcat,map(s->energy_assembly[s][4,:],eachindex(energy_assembly)));

T_shear=reduce(hcat,map(s->energy_shear[s][2,:],eachindex(energy_assembly)));
U_shear=reduce(hcat,map(s->energy_shear[s][3,:],eachindex(energy_assembly)));
K_shear=reduce(hcat,map(s->energy_shear[s][4,:],eachindex(energy_assembly)));

# Labels
aux_CL=map(s->Int64.(parameters[s][10]/(parameters[s][10]+parameters[s][11]).*100),eachindex(parameters));

string.(aux_CL,"%")

"""
labels_energy = ("U","K","U+K");
labels_T=(L"")
fig_Energy = Figure(size=(1200,980));
ax_e = Axis(fig_Energy[1,1],
        title = "Energy",
        xlabel = "Time steps [Log10]",
        ylabel = "Energy",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        xscale = log10,
        limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
    )
ax_t = Axis(fig_Energy[1,2],
        title = "Temperature",
        xlabel = "Time steps [Log10]",
        ylabel = "Energy",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        xscale = log10,
        limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
    )


series!(ax_t,time_assembly,T_assembly)
"""

#energy_assemblly
#bondlenCL_assembly
#bondlenPt_assembly
#energy_shear
#bondlenCL_shear
#bondlenPt_shea
#stress_shear



#getInfo(file_dir[s][r])
