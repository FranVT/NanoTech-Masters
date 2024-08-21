"""
    Graphics for Stress
"""

using Distributions
using GLMakie

include("functions.jl")

## Gather information

# Directories

compu = 1;

if compu == 1
    # MiniForum
    pwdDir = "/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/shearTests/assembly_deformation/info/";
elseif compu == 2
    # LapTop
    pwdDir = "F:/GitHub/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/shearTests/assembly_deformation/info/";
else
    println("No valid directory")
end

workdir = cd(pwdDir);

# Files names
assemblyFiles_names = (
                       "patchyParticles_assembly.dumpf", 
                       "newdata_assembly.dumpf",
                       "energy_assembly.fixf"
                      );

shearFiles_names = (
                        "patchyParticles_shear.dumpf", 
                        "newdata_shear.dumpf",
                        "energy_shear.fixf",
                        "stress_shear.fixf",
                        "stressKe_shear.fixf",
                        "stressPair_shear.fixf",
                        "stressVirial_shear.fixf"
                    );

files = (assemblyFiles_names,shearFiles_names);

# Get information
data_energy = map(s->getInfoEnergy(pwdDir*s[3]),files);
data_stress = map(s->getInfoStress(pwdDir*shearFiles_names[s]),4:7);

## Figures

# Energy
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
ax_t = Axis(fig_Energy[1,3],
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
series!(ax_e,ta_step,data_energy[1][2:4,:])
series!(ax_e,ts_step,data_energy[2][2:4,:])

lines!(ax_t,ta_step,T_assembly,label="T_a",color = Makie.wong_colors()[1])
lines!(ax_t,ts_step,T_shear,label="T_s",color = Makie.wong_colors()[2])



