"""
    Graphics for Stress
"""

using Distributions
using GLMakie

# Directories
main_Dir = pwd();
pwdDir = string(main_Dir,"/info/");

include(string(main_Dir,"/sysFiles/auxs/parameters.jl"))
include("functions.jl")

println("Main directory of analysis.jl: ", main_Dir)


println(ARGS)

## Move .fixf files if necessary
if ARGS[1] == "1" && ARGS[2] == "1"
    println("Moving assembly and shear files to directory")
    arg = filter(!=(" "),Iterators.flatten(files)|>Tuple);
    path1 = map(s->joinpath(pwdDir,s),arg);
    path2 = map(s->joinpath(pwdDir,dir_system,s),arg);

    map(s->mv(path1[s],path2[s],force=true),eachindex(path1))
elseif ARGS[1] == "0" && ARGS[2] == "1"
    println("Moving shear files to directory")
    arg = filter(!=(" "),files[2]);
    path1 = map(s->joinpath(pwdDir,s),arg);
    path2 = map(s->joinpath(pwdDir,dir_system,s),arg);

    map(s->mv(path1[s],path2[s],force=true),eachindex(path1))
else
    println("All files in directory, running analysis")
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

## Stress Graphs
function StressGraph(title_aux,strain,stress_info)
normTensor = sum(abs.(stress_info[3:5,:]).^2,dims=1) .+ (2).*sum(abs.(stress_info[6:8,:]).^2,dims=1);
normTensor = Iterators.flatten(sqrt.(normTensor))|>collect;

labels_stress = ("Norm","xx","yy","zz","Norm","xy","xz","yz");
#labels_stress = ("Norm","xx","Norm","xy");
fig_Stress = Figure(size=(1200,920));
ax_s1 = Axis(fig_Stress[1,1:2],
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
ax_s2 = Axis(fig_Stress[2,1:2],
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
ax_s3 = Axis(fig_Stress[3,1:2],
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

strain = data_stress[2,:];

fig_StressVirial = StressGraph("Ke + Pair Stress Components",strain,-data_stress)

### Save the figures
pwdDir = string(main_Dir,"/info/",dir_system);
workdir = cd(pwdDir);

save("energy.png",fig_Energy)
save("stressVirial.png",fig_StressVirial)

## Restore the working directory
workdir = cd(main_Dir);

