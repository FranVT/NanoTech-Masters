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

"""
# Get parameters from the directories
parameters=getParameters(dirs,file_name);

# Get the data from the fix files
data=getData(dirs,file_name);

# Re-organize the information
energy_assembly=map(s->data[s][1],eachindex(data));
bondlenCL_assembly=map(s->data[s][2],eachindex(data));
bondlenPt_assembly=map(s->data[s][3],eachindex(data));
energy_shear=map(s->data[s][4],eachindex(data));
bondlenCL_shear=map(s->data[s][5],eachindex(data));
bondlenPt_shear=map(s->data[s][6],eachindex(data));
stress_shear=map(s->data[s][7],eachindex(data));
"""

## Energy and Temperature figure

# Time
time_assembly=parameters[1][7].*energy_assembly[1][1,:];
time_shear=parameters[1][7].*energy_shear[1][1,:].+last(time_assembly);

# Energy
T_assembly=reduce(hcat,map(s->energy_assembly[s][2,:],eachindex(energy_assembly)));
U_assembly=reduce(hcat,map(s->energy_assembly[s][3,:],eachindex(energy_assembly)));
K_assembly=reduce(hcat,map(s->energy_assembly[s][4,:],eachindex(energy_assembly)));
Eng_assembly=U_assembly.+K_assembly;

T_shear=reduce(hcat,map(s->energy_shear[s][2,:],eachindex(energy_assembly)));
U_shear=reduce(hcat,map(s->energy_shear[s][3,:],eachindex(energy_assembly)));
K_shear=reduce(hcat,map(s->energy_shear[s][4,:],eachindex(energy_assembly)));
Eng_shear=U_shear.+K_shear;

# Labels
aux_CL=map(s->Int64.(parameters[s][10]/(parameters[s][10]+parameters[s][11]).*100),eachindex(parameters));
labels_CL=string.(aux_CL,"%");

tf=last(time_shear);
fig_Energy = Figure(size=(1200,980));
ax_e = Axis(fig_Energy[1,1],
        title = L"\mathrm{Total~Energy}",
        xlabel = L"\mathrm{Time~unit}~[\tau~Log_{10}]",
        ylabel = L"\mathrm{Energy}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        xscale = log10,
        limits = (10e0,exp10(round(log10(tf))),nothing,nothing)
    )
ax_t = Axis(fig_Energy[1,2],
        title = L"\mathrm{Temperature}",
        xlabel = L"\mathrm{Time~unit}~[\tau~Log_{10}]",
        ylabel = L"\mathrm{Temperature}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        xscale = log10,
        limits = (10e0,exp10(round(log10(tf))),nothing,nothing)
    )

series!(ax_e,time_assembly,Eng_assembly',labels=labels_CL)
series!(ax_e,time_shear,Eng_shear',labels=labels_CL)
vlines!(ax_e,last(time_assembly),linestyle=:dash)
axislegend(ax_e,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_t,time_assembly,T_assembly',labels=labels_CL)
series!(ax_t,time_shear,T_shear',labels=labels_CL)
vlines!(ax_t,last(time_assembly),linestyle=:dash)
axislegend(ax_t,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

## Stress figure
time_stress=parameters[1][13].*stress_shear[1][1,:];
stressXX=reduce(hcat,map(s->-stress_shear[s][3,:],eachindex(stress_shear)));
stressXY=reduce(hcat,map(s->-stress_shear[s][6,:],eachindex(stress_shear)));

fig_Stress = Figure(size=(1080,980));
ax_stressXX = Axis(fig_Stress[1,1:2],
                   title = L"\mathrm{Stress}~xx",
                   xlabel = L"\mathrm{Time [tau]}",
                   ylabel = L"\sigma",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                   #xscale = log10,
                   #limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
                  )
ax_stressXY = Axis(fig_Stress[2,1:2],
                   title = L"\mathrm{Stress}~xy",
                   xlabel = L"\mathrm{Time [tau]}",
                   ylabel = L"\sigma",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                   #xscale = log10,
                   #limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
                  )

series!(ax_stressXX,time_stress,stressXX',labels=labels_CL)
axislegend(ax_stressXX,L"\mathrm{Cross-Linker~Concentration}",position=:rt)

series!(ax_stressXY,time_stress,stressXY',labels=labels_CL)
axislegend(ax_stressXY,L"\mathrm{Cross-Linker~Concentration}",position=:rt)

#energy_assemblly
#bondlenCL_assembly
#bondlenPt_assembly
#energy_shear
#bondlenCL_shear
#bondlenPt_shea
#stress_shear



#getInfo(file_dir[s][r])
