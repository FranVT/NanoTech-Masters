"""
    Graphics for Stress
"""

using Distributions
using GLMakie

# Directories
main_Dir = pwd();
pwdDir = main_Dir; #string(main_Dir,"/info/");

include("functions.jl")

println("Main directory of analysis.jl: ", main_Dir)

## Gather information

workdir = cd(pwdDir);

# Get information
shearFiles_names = ("stressVirial_shear_2000.fixf","stressVirial_shear_4000.fixf","stressVirial_shear_6000.fixf","stressVirial_shear_8000.fixf");

data_stress = map(s->getInfoStress(joinpath(pwdDir,s)),shearFiles_names);

## Prepare the data
function tensorNorm(stress_info)
"""
    Compute the stress norm of a symetrix tensor given 6 components.
"""
    normTensor = sum(abs.(stress_info[3:5,:]).^2,dims=1) .+ (2).*sum(abs.(stress_info[6:8,:]).^2,dims=1);
    return Iterators.flatten(sqrt.(normTensor))|>collect;
end

strain = data_stress[1][2,:];

data_norm = mapreduce(s->tensorNorm((-1).*s),hcat,data_stress)';

data_T_xx = (-1).*mapreduce(s->s[3,:],hcat,data_stress)';

data_T_xy = (-1).*mapreduce(s->s[6,:],hcat,data_stress)';


## Prepare labels and stuff
labels_stress = (L"2000 \mathrm{Particles}",L"4000 \mathrm{Particles}",L"6000 \mathrm{Particles}",L"8000 \mathrm{Particles}");

### Figures
fig_Stress = Figure(size=(1200,920));
ax_s1 = Axis(fig_Stress[1,1:2],
        aspect = nothing,
        title = L"xx~\mathrm{Component}",
        xlabel = L"\mathrm{Tilt~deformation}",
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
        title = L"xy~\mathrm{Component}",
        xlabel = L"\mathrm{Tilt~deformation}",
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
        title = L"\mathrm{Norm}",
        xlabel = L"\mathrm{Tilt~deformation}",
        ylabel = L"\sigma_{nn}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
    )

    series!(ax_s1,strain,data_T_xx,labels=labels_stress,color=:tab10)
    axislegend(ax_s1,"Legends",position=:rb)

    series!(ax_s2,strain,data_T_xy,labels=labels_stress,color=:tab10)
    axislegend(ax_s2,"Legends",position=:rb)

    series!(ax_s3,strain,data_norm,labels=labels_stress,color=:tab10)
    axislegend(ax_s3,"Legends",position=:rb)


fig_Stress

save("Comparisson.png",fig_Stress)

