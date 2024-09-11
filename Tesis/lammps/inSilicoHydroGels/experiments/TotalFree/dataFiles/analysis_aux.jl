"""
   Script for graphs and other stuff
"""

using GLMakie
using Distributions

# Directories
main_Dir = pwd();
pwdDir = string(main_Dir,"/dataFiles/");

#include(string(main_Dir,"/sysFiles/auxs/parameters.jl"))
include("functions.jl")

dirs = (
        "systemCL100MO1900ShearRate2000Cycles4",
        "systemCL200MO1800ShearRate2000Cycles4",
        "systemCL300MO1700ShearRate2000Cycles4",
        "systemCL400MO1600ShearRate2000Cycles4"
      )

joinpath(pwdDir,dirs[1]);

function getData(pwdDir,dir)
    include(joinpath(pwdDir,dir))
    data_energy = map(s->getInfoEnergy(pwdDir*s[1]),files);
    data_stress = getInfoStress(pwdDir*shearFiles_names[2]);
    return (data_energy,data_stress)
end


## Gather information

workdir = cd(pwdDir);

# Get information
data_energy = map(s->getInfoEnergy(pwdDir*s[1]),files);
data_stress = getInfoStress(pwdDir*shearFiles_names[2]);

### Figures

## Energy
ta_step = data_energy[1][1,:];
T_assembly = data_energy[1][2,:];
U_assembly = data_energy[1][3,:];
K_assembly = data_energy[1][4,:];
E_assembly = U_assembly .+ K_assembly;

ts_step = last(data_energy[1][1,:]) .+ data_energy[2][1,:];
T_shear = data_energy[2][2,:];
U_shear = data_energy[2][3,:];
K_shear = data_energy[2][4,:];
E_shear = U_shear .+ K_shear;

tf = last(data_energy[1][1,:]) + last(data_energy[2][1,:]);

labels_energy = ("U","K","U+K");
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
series!(ax_e,ta_step,[U_assembly'; K_assembly'; E_assembly'],labels=labels_energy,color=:lighttest)
series!(ax_e,ts_step,[U_shear'; K_shear'; E_shear'],labels=labels_energy,color=:roma10)
axislegend(ax_e,"Legends",position=:lb)

lines!(ax_t,ta_step,T_assembly,label="T_a",color = Makie.wong_colors()[1])
lines!(ax_t,ts_step,T_shear,label="T_s",color = Makie.wong_colors()[2])
axislegend("Legends",position=:lb)


