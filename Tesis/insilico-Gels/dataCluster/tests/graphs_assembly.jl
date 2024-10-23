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
             "swapPair_assembly.fixf"
            );

"""
# Get parameters from the directories
parameters=getParameters(dirs,file_name);

# Get the data from the fix files
data=getData(dirs,file_name);

# Re-organize information
energy_assembly=map(s->data[s][1],eachindex(data));
wcaPair_assembly=map(s->data[s][2],eachindex(data));
patchPair_assembly=map(s->data[s][3],eachindex(data));
swapPair_assembly=map(s->data[s][4],eachindex(data));

# Time

time_assembly=parameters[1][7].*energy_assembly[1][1,:];

# Labels
aux_CL=map(s->Int64.(round(parameters[s][3]*100)),eachindex(parameters));
auxsdir=map(s->s[2],split.(dirs,"/"));
#labels_CL=string.(first.(split.(dirs,"/"))," CL=",aux_CL,"%");
labels_CL=string.(auxsdir," CL=",aux_CL,"%");

# Temperature Information
T_assembly=reduce(hcat,map(s->energy_assembly[s][5,:],eachindex(energy_assembly)));
Tcp_assembly=reduce(hcat,map(s->energy_assembly[s][2,:],eachindex(energy_assembly)));

# Energy information
U_assembly=reduce(hcat,map(s->energy_assembly[s][3,:],eachindex(energy_assembly)));
K_assembly=reduce(hcat,map(s->energy_assembly[s][4,:],eachindex(energy_assembly)));
Eng_assembly=U_assembly.+K_assembly;

wca_assembly=reduce(hcat,map(s->wcaPair_assembly[s][2,:],eachindex(wcaPair_assembly)));
patch_assembly=reduce(hcat,map(s->patchPair_assembly[s][2,:],eachindex(patchPair_assembly)));
swap_assembly=reduce(hcat,map(s->swapPair_assembly[s][2,:],eachindex(swapPair_assembly)));

"""

# Figures

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
ax_tcp = Axis(fig_Temp[2,1],
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

series!(ax_tcp,time_assembly,Tcp_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
fig_Temp[1:2,2]=Legend(fig_Temp,ax_t,L"\mathrm{Legends}",framevisible=true)


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
series!(ax_eaU,U_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
series!(ax_eaK,K_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())

fig_EngAss[1:3,3]=Legend(fig_EngAss,ax_eaT,L"\mathrm{Legends}",framevisible=true)

# Energy plots
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
fig_Energy[1,2]=Legend(fig_Energy,ax_e,L"\mathrm{Legends}",framevisible=true)

# Energy of Pair-Potentials
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

series!(ax_patch,time_assembly,patch_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())

series!(ax_swap,time_assembly,swap_assembly',labels=labels_CL,color=:tab10)#Makie.wong_colors())
fig_Pair[1:3,3]=Legend(fig_Pair,ax_WCA,L"\mathrm{Legends}",framevisible=true)



