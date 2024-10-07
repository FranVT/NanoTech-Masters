"""
    Individual analysis
"""

using FileIO
using GLMakie

include("functions.jl")

# Create the file with the dirs names
run(`bash getDir.sh`)
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

# Re-organize the information
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

## Energy and Temperature figure

# Time
time_assembly=parameters[1][7].*energy_assembly[1][1,:];
#time_deform=parameters[1][7].*energy_shear[1][1,:].+last(time_assembly);
time_deform=map(s->(parameters[1][7].*s[1,:]).+last(time_assembly),energy_shear);

# Energy
T_assembly=reduce(hcat,map(s->energy_assembly[s][5,:],eachindex(energy_assembly)));
Tcp_assembly=reduce(hcat,map(s->energy_assembly[s][2,:],eachindex(energy_assembly)));
U_assembly=reduce(hcat,map(s->energy_assembly[s][3,:],eachindex(energy_assembly)));
K_assembly=reduce(hcat,map(s->energy_assembly[s][4,:],eachindex(energy_assembly)));
Eng_assembly=U_assembly.+K_assembly;

T_shear=map(s->energy_shear[s][5,:],eachindex(energy_assembly));
Tcp_shear=map(s->energy_shear[s][2,:],eachindex(energy_assembly));
U_shear=map(s->energy_shear[s][3,:],eachindex(energy_assembly));
K_shear=map(s->energy_shear[s][4,:],eachindex(energy_assembly));
Eng_shear=map(s->U_shear[s].+K_shear[s],eachindex(T_shear));

# Labels
aux_CL=map(s->Int64.(round(parameters[s][10]/(parameters[s][10]+parameters[s][11]).*100)),eachindex(parameters));
labels_CL=string.(aux_CL,"%");

tf=last(time_deform);
fig_Energy = Figure(size=(1200,980));
ax_e = Axis(fig_Energy[1,1],
        title = L"\mathrm{Total~Energy}",
        xlabel = L"\mathrm{Time~unit}",
        ylabel = L"\mathrm{Energy}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        #xscale = log10,
        #limits = (10e0,exp10(round(log10(tf))),nothing,nothing)
    )
series!(ax_e,time_assembly,Eng_assembly',labels=labels_CL,color=:tab10)
map(s->lines!(ax_e,time_deform[s],Eng_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_e,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_e,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
axislegend(ax_e,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)
#fig_Energy[]=Legend(fig_Energy,ax_e)

fig_Temp=Figure(size=(1200,980));
ax_t = Axis(fig_Temp[1,1],
        title = L"\mathrm{Temperature}",
        xlabel = L"\mathrm{Time~unit}",
        ylabel = L"\mathrm{Temperature}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        #xscale = log10,
        #limits = (10e0,exp10(round(log10(tf))),nothing,nothing)
    )
ax_tcp = Axis(fig_Temp[1,2],
        title = L"\mathrm{Temperature~Central~particles}",
        xlabel = L"\mathrm{Time~unit}",
        ylabel = L"\mathrm{Temperature}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        #xscale = log10,
        #limits = (10e0,exp10(round(log10(tf))),nothing,nothing)
    )

series!(ax_t,time_assembly,T_assembly',labels=labels_CL,color=Makie.wong_colors())
map(s->lines!(ax_t,time_deform[s],T_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_t,last(time_assembly),linestyle=:dash,color=:black)
axislegend(ax_t,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_tcp,time_assembly,Tcp_assembly',labels=labels_CL,color=Makie.wong_colors())
map(s->lines!(ax_tcp,time_deform[s],Tcp_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_tcp,last(time_assembly),linestyle=:dash,color=:black)
axislegend(ax_tcp,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

# Energy log assembly
fig_EngAss = Figure(size=(1200,980));
ax_eaT = Axis(fig_EngAss[1,1:2],
        title = L"\mathrm{Total~Energy}",
        xlabel = L"\mathrm{Time~steps}",
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
        limits = (10e0,exp10(round(log10(parameters[1][8]))),nothing,nothing)
    )
ax_eaU = Axis(fig_EngAss[2,1:2],
        title = L"\mathrm{Potential~Energy}",
        xlabel = L"\mathrm{Time~steps}",
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
        limits = (10e0,exp10(round(log10(parameters[1][8]))),nothing,nothing)
    )
ax_eaK = Axis(fig_EngAss[3,1:2],
        title = L"\mathrm{Kinetic~Energy}",
        xlabel = L"\mathrm{Time~steps}",
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
        limits = (10e0,exp10(round(log10(parameters[1][8]))),nothing,nothing)
    )
series!(ax_eaT,Eng_assembly',labels=labels_CL,color=Makie.wong_colors())
axislegend(ax_eaT,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_eaU,U_assembly',labels=labels_CL,color=Makie.wong_colors())
axislegend(ax_eaU,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_eaK,K_assembly',labels=labels_CL,color=Makie.wong_colors())
axislegend(ax_eaK,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)



#map(s->lines!(ax_e,time_deform[s],Eng_shear[s],label=labels_CL[s]),eachindex(time_deform))
#vlines!(ax_e,last(time_assembly),linestyle=:dash,color=:black)
#vlines!(ax_e,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)


## Stress figure
time_stress=map(s->parameters[1][13].*s[1,:],stress_shear);
stressXX=map(s->-stress_shear[s][3,:],eachindex(stress_shear));
stressXY=map(s->-stress_shear[s][6,:],eachindex(stress_shear));


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

#series!(ax_stressXX,time_stress,stressXX',labels=labels_CL)
map(s->lines!(ax_stressXX,time_stress[s],stressXX[s],label=labels_CL[s]),eachindex(time_stress))
vlines!(ax_stressXX,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
axislegend(ax_stressXX,L"\mathrm{Cross-Linker~Concentration}",position=:rt)

#series!(ax_stressXY,time_stress,stressXY',labels=labels_CL)
map(s->lines!(ax_stressXY,time_stress[s],stressXY[s],label=labels_CL[s]),eachindex(time_stress))
vlines!(ax_stressXY,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
axislegend(ax_stressXY,L"\mathrm{Cross-Linker~Concentration}",position=:rt)


