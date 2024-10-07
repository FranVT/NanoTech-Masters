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

"""
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
time_deform=parameters[1][7].*energy_shear[1][1,:].+last(time_assembly);

# Energy
T_assembly=reduce(hcat,map(s->energy_assembly[s][5,:],eachindex(energy_assembly)));
Tcp_assembly=reduce(hcat,map(s->energy_assembly[s][2,:],eachindex(energy_assembly)));
U_assembly=reduce(hcat,map(s->energy_assembly[s][3,:],eachindex(energy_assembly)));
K_assembly=reduce(hcat,map(s->energy_assembly[s][4,:],eachindex(energy_assembly)));
Eng_assembly=U_assembly.+K_assembly;

T_shear=reduce(hcat,map(s->energy_shear[s][5,:],eachindex(energy_assembly)));
Tcp_shear=reduce(hcat,map(s->energy_shear[s][2,:],eachindex(energy_assembly)));
U_shear=reduce(hcat,map(s->energy_shear[s][3,:],eachindex(energy_assembly)));
K_shear=reduce(hcat,map(s->energy_shear[s][4,:],eachindex(energy_assembly)));
Eng_shear=reduce(hcat,map(s->U_shear[s].+K_shear[s],eachindex(T_shear)));

"""

println("Data readed.")

# Labels
#aux_CL=map(s->Int64.(round(parameters[s][10]/(parameters[s][10]+parameters[s][11]).*100)),eachindex(parameters));
#lblsAss_CL=string.("Assembly: ",aux_CL,"%");
#lblsShr_CL=string.("Shear: ",aux_CL,"%");

aux_CL=map(s->Int64.(round(parameters[s][3]*100)),eachindex(parameters));
auxsdir=map(s->s[3],split.(dirs,"/"));
#labels_CL=string.(first.(split.(dirs,"/"))," CL=",aux_CL,"%");
labels_CL=string.(auxsdir," CL=",aux_CL,"%");



tf=last(time_deform);

fig_Temp=Figure(size=(1200,980));
ax_leg=Axis(fig_Temp[1:2,3],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_t = Axis(fig_Temp[1,1:2],
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
ax_tcp = Axis(fig_Temp[2,1:2],
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

series!(ax_t,time_assembly,T_assembly',color=:tab10)
series!(ax_t,time_deform,T_shear',color=:tab10)
vlines!(ax_t,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_tcp,time_assembly,Tcp_assembly',color=:tab10)
series!(ax_tcp,time_deform,Tcp_shear',color=:tab10)
vlines!(ax_tcp,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=:tab10,labels=labels_CL)


Legend(fig_Temp[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )
#                       L"\mathrm{Damps~and~Concentration}",
#                       framevisible=true,
#                       orientation=:vertical,
#                       [elm1],
#                       ["ede"],
#                       patchsize=(35,35)#lblsAss_CL
#                      )




