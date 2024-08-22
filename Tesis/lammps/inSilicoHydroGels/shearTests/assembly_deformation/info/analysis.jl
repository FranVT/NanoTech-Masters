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
                       "energy_assembly.fixf",
                       " "
                      );

shearFiles_names = (
                        "energy_shear.fixf",
                        "stress_shear.fixf",
                        "stressKe_shear.fixf",
                        "stressPair_shear.fixf",
                        "stressFix_shear.fixf",
                        "stressVirial_shear.fixf"
                    );

files = (assemblyFiles_names,shearFiles_names);

# Get information
data_energy = map(s->getInfoEnergy(pwdDir*s[1]),files);
data_stress = map(s->getInfoStress(pwdDir*shearFiles_names[s]),2:length(shearFiles_names));

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
series!(ax_e,ta_step,data_energy[1][2:4,:],labels=labels_energy,color=:lighttest)
series!(ax_e,ts_step,data_energy[2][2:4,:],labels=labels_energy,color=:roma10)
axislegend(ax_e,"Legends",position=:lb)

lines!(ax_t,ta_step,T_assembly,label="T_a",color = Makie.wong_colors()[1])
lines!(ax_t,ts_step,T_shear,label="T_s",color = Makie.wong_colors()[2])
axislegend("Legends",position=:lb)

## Stress Graphs
function StressGraph(title_aux,strain,stress_info)
normTensor = sum(abs.(stress_info[3:5,:]).^2,dims=1) .+ (2).*sum(abs.(stress_info[6:8,:]).^2,dims=1);
normTensor = Iterators.flatten(sqrt.(normTensor))|>collect;

labels_stress = ("Norm","xx","yy","zz","Norm","xy","xz","yz");
fig_Stress = Figure(size=(1200,920));
ax_s1 = Axis(fig_Stress[1,1],
        aspect = nothing,
        title = title_aux,
        xlabel = "Tilt deformation",
        ylabel = L"\sigma_{nn}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
    )
ax_s2 = Axis(fig_Stress[1,2],
        aspect = nothing,
        title = title_aux,
        xlabel = "Tilt deformation",
        ylabel = L"\sigma_{nn}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
    )
ax_s3 = Axis(fig_Stress[2,1:2],
        aspect = nothing,
        title = "Norm",
        xlabel = "Tilt deformation",
        ylabel = L"\sigma_{nn}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
    )

    series!(ax_s1,strain,stress_info[3:5,:],labels=labels_stress[2:4],color=:roma10)
    axislegend(ax_s1,"Legends",position=:lb)

    series!(ax_s2,strain,stress_info[6:end,:],labels=labels_stress[6:end],color=:roma10)
    axislegend(ax_s2,"Legends",position=:lb)

    lines!(ax_s3,strain,normTensor,label=labels_stress[1])
    axislegend(ax_s3,"Legends",position=:lb)

    return fig_Stress
end

strain = data_stress[2][2,:];

fig_Stresstotal = StressGraph("Total Stress Components",strain,-data_stress[1])
fig_StressKe = StressGraph("Ke Stress Components",strain,-data_stress[2])
fig_StressPair = StressGraph("Pair Stress Components",strain,-data_stress[3])
fig_StressFix = StressGraph("Fix Stress Components",strain,-data_stress[4])
fig_StressVirial = StressGraph("Virial Stress Components",strain,-data_stress[5])

fig_StressFixtotal = StressGraph("Total - Fix Stress Components",strain,-(data_stress[1].-data_stress[4]))
fig_StressKePair = StressGraph("Ke + Pair Stress Components",strain,-(data_stress[2].+data_stress[3]))
fig_StressVirialFix = StressGraph("Virial - Fix Stress Components",strain,-(data_stress[5].-data_stress[4]))

### Save the figures
if compu == 1
    # MiniForum
    pwdDir = "/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/shearTests/assembly_deformation/info/imgs/";
elseif compu == 2
    # LapTop
    pwdDir = "F:/GitHub/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/shearTests/assembly_deformation/info/imgs/";
else
    println("No valid directory")
end

workdir = cd(pwdDir);

save("energy.png",fig_Energy)
save("stress.png",fig_Stresstotal)
save("stressKe.png",fig_StressKe)
save("stressPair.png",fig_StressPair)
save("stressFix.png",fig_StressFix)
save("stressVirial.png",fig_StressVirial)
save("stressKePair.png",fig_StressKePair)
save("stressVirialNoFix.png",fig_StressVirialFix)
save("stressTotalNoFix.png",fig_StressFixtotal)

## Restore the working directory
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
