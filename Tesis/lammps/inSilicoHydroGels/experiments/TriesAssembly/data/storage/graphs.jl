"""
    Script for plots
"""

using GLMakie

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


# Time

time_assembly=parameters[1][7].*energy_assembly[1][1,:];
#time_deform=parameters[1][7].*energy_shear[1][1,:].+last(time_assembly);
time_deform=map(s->(parameters[1][7].*s[1,:]).+last(time_assembly),energy_shear);
time_shear=parameters[1][13]*parameters[1][18]*parameters[1][15];
time_rlxo1=time_shear;
time_rlxf1=time_rlxo1+parameters[1][13]*parameters[1][19];
time_rlxo2=time_rlxf1+time_shear;
time_rlxf2=time_rlxo2+parameters[1][13]*parameters[1][20];
time_rlxo3=time_rlxf2+time_shear;
time_rlxf3=time_rlxo3+parameters[1][13]*parameters[1][21];
time_rlxo4=time_rlxf3+time_shear;
time_rlxf4=time_rlxo4+parameters[1][13]*parameters[1][22];

# Labels
aux_CL=map(s->Int64.(round(parameters[s][3]*100)),eachindex(parameters));
auxsdir=map(s->s[2],split.(dirs,"/"));
#labels_CL=string.(first.(split.(dirs,"/"))," CL=",aux_CL,"%");
labels_CL=string.(auxsdir," CL=",aux_CL,"%");

# Temperature plots
T_assembly=reduce(hcat,map(s->energy_assembly[s][5,:],eachindex(energy_assembly)));
Tcp_assembly=reduce(hcat,map(s->energy_assembly[s][2,:],eachindex(energy_assembly)));

T_shear=map(s->energy_shear[s][5,:],eachindex(energy_assembly));
Tcp_shear=map(s->energy_shear[s][2,:],eachindex(energy_assembly));

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

series!(ax_t,time_assembly,T_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_t,time_deform[s],T_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_t,last(time_assembly),linestyle=:dash,color=:black)
axislegend(ax_t,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_tcp,time_assembly,Tcp_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_tcp,time_deform[s],Tcp_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_tcp,last(time_assembly),linestyle=:dash,color=:black)
axislegend(ax_tcp,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)


# Energy assembly logs
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
series!(ax_eaT,Eng_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
axislegend(ax_eaT,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_eaU,U_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
axislegend(ax_eaU,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_eaK,K_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
axislegend(ax_eaK,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)


# Energy plots
U_assembly=reduce(hcat,map(s->energy_assembly[s][3,:],eachindex(energy_assembly)));
K_assembly=reduce(hcat,map(s->energy_assembly[s][4,:],eachindex(energy_assembly)));
Eng_assembly=U_assembly.+K_assembly;

U_shear=map(s->energy_shear[s][3,:],eachindex(energy_assembly));
K_shear=map(s->energy_shear[s][4,:],eachindex(energy_assembly));
Eng_shear=map(s->U_shear[s].+K_shear[s],eachindex(T_shear));

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
series!(ax_e,time_assembly,Eng_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_e,time_deform[s],Eng_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_e,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_e,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
axislegend(ax_e,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)


# Energy of Pair-Potentials
wca_assembly=reduce(hcat,map(s->wcaPair_assembly[s][2,:],eachindex(wcaPair_assembly)));
patch_assembly=reduce(hcat,map(s->patchPair_assembly[s][2,:],eachindex(patchPair_assembly)));
swap_assembly=reduce(hcat,map(s->swapPair_assembly[s][2,:],eachindex(swapPair_assembly)));
#Eng_assembly=U_assembly.+K_assembly;

wca_shear=map(s->wcaPair_shear[s][2,:],eachindex(wcaPair_shear));
patch_shear=map(s->patchPair_shear[s][2,:],eachindex(patchPair_shear));
swap_shear=map(s->swapPair_shear[s][2,:],eachindex(swapPair_shear));


tf=last(time_deform);
fig_Pair = Figure(size=(1200,980));
ax_WCA = Axis(fig_Pair[1,1:2],
        title = L"\mathrm{WCA~Pair~Potential~Energy}",
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
ax_patch = Axis(fig_Pair[2,1:2],
        title = L"\mathrm{Patch~Pair~Potential~Energy}",
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
ax_swap = Axis(fig_Pair[3,1:2],
        title = L"\mathrm{Swap~Pair~Potential~Energy}",
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
series!(ax_WCA,time_assembly,wca_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_WCA,time_deform[s],wca_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_WCA,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_WCA,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
axislegend(ax_WCA,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_patch,time_assembly,patch_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_patch,time_deform[s],patch_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_patch,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_patch,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
axislegend(ax_patch,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_swap,time_assembly,swap_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_swap,time_deform[s],swap_shear[s],label=labels_CL[s]),eachindex(time_deform))
vlines!(ax_swap,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_swap,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
axislegend(ax_swap,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)


fig_PairZoom = Figure(size=(1200,980));
ax_WCAzas = Axis(fig_PairZoom[1,1:2],
        title = L"\mathrm{WCA~Pair~Potential~Energy~Assembly}",
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
ax_WCAzdf = Axis(fig_PairZoom[1,3:4],
        title = L"\mathrm{WCA~Pair~Potential~Energy~Shear}",
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
ax_patchzas = Axis(fig_PairZoom[2,1:2],
        title = L"\mathrm{Patch~Pair~Potential~Energy~Assembly}",
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
ax_patchzdf = Axis(fig_PairZoom[2,3:4],
        title = L"\mathrm{Patch~Pair~Potential~Energy~Shear}",
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
ax_swapzas = Axis(fig_PairZoom[3,1:2],
        title = L"\mathrm{Swap~Pair~Potential~Energy~Assembly}",
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
ax_swapzdf = Axis(fig_PairZoom[3,3:4],
        title = L"\mathrm{Swap~Pair~Potential~Energy~Deformation}",
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
series!(ax_WCAzas,time_assembly,wca_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_WCAzdf,time_deform[s],wca_shear[s],label=labels_CL[s]),eachindex(time_deform))
#vlines!(ax_WCAz,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_WCAzdf,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
#axislegend(ax_WCAzas,L"\mathrm{Cross-Linker~Concentration}",position=(1,1),merge=true)

series!(ax_patchzas,time_assembly,patch_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_patchzdf,time_deform[s],patch_shear[s],label=labels_CL[s]),eachindex(time_deform))
#vlines!(ax_patchz,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_patchzdf,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
#axislegend(ax_patchzas,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)

series!(ax_swapzas,time_assembly,swap_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
map(s->lines!(ax_swapzdf,time_deform[s],swap_shear[s],label=labels_CL[s]),eachindex(time_deform))
#vlines!(ax_swapz,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_swapzdf,last(time_assembly).+[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash)
#axislegend(ax_swapzas,L"\mathrm{Cross-Linker~Concentration}",position=:rb,merge=true)



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






