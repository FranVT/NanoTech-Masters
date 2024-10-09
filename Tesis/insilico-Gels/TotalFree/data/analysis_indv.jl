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
             "cmdisplacement_assebmly.fixf",
             "stressVirial_assembly.fixf",
             "energy_shear.fixf",
             "wcaPair_shear.fixf",
             "patchPair_shear.fixf",
             "swapPair_shear.fixf",
             "cmdisplacement_assebmly.fixf",
             "stressVirial_shear.fixf"
            );

#"""
# Get parameters from the directories
"""
    Relation of index with parameter
    1 -> Central particle radius
    1 -> Patch particle radius
    1 -> Cross-Linker Concentration
    1 -> Number of particles
    1 -> Temperature
    1 -> Damp
    1 -> Box Volume
    1 -> Packing fraction
    1 -> Time step in assembly
    1 -> Number of time steps in assembly
    1 -> Save every N time steps in assembly
    1 -> Number of Cross-Linkers 
    1 -> Number of Monomers
    1 -> Box Volume
    1 -> Time step in shear
    1 -> Number of time steps in shear
    1 -> Number of time steps per deformation
    1 -> Save every N time steps
    1 -> Shear rate
    1 -> Max deformation per cycle
    1 -> Relax time 1
    1 -> Relax time 2 
    1 -> Relax time 3
    1 -> Relax time 4
"""
parameters=getParameters(dirs,file_name);

# Get the data from the fix files
data=getData(dirs,file_name);

# Re-organize the information
energy_assembly=map(s->data[s][1],eachindex(data));
wcaPair_assembly=reduce(hcat,map(s->data[s][2][2,:],eachindex(data)));
patchPair_assembly=reduce(hcat,map(s->data[s][3][2,:],eachindex(data)));
swapPair_assembly=reduce(hcat,map(s->data[s][4][2,:],eachindex(data)));
energy_shear=map(s->data[s][5],eachindex(data));
wcaPair_shear=reduce(hcat,map(s->data[s][6][2,:],eachindex(data)));
patchPair_shear=reduce(hcat,map(s->data[s][7][2,:],eachindex(data)));
swapPair_shear=reduce(hcat,map(s->data[s][8][2,:],eachindex(data)));
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

#"""
## Energy and Temperature figure

# Time
time_assembly=parameters[1][7].*energy_assembly[1][1,:];
time_shear=parameters[1][7].*energy_shear[1][1,:];
time_deform=time_shear.+last(time_assembly);
time_stress=parameters[1][13].*stress_shear[1][1,:];

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
Eng_shear=U_shear.+K_shear;



println("Data readed.")

# Labels
#aux_CL=map(s->Int64.(round(parameters[s][10]/(parameters[s][10]+parameters[s][11]).*100)),eachindex(parameters));
#lblsAss_CL=string.("Assembly: ",aux_CL,"%");
#lblsShr_CL=string.("Shear: ",aux_CL,"%");

aux_CL=map(s->Int64.(round(parameters[s][3]*100)),eachindex(parameters));
auxsdir=map(s->s[3],split.(dirs,"/"));
#labels_CL=string.(first.(split.(dirs,"/"))," CL=",aux_CL,"%");
labels_CL=string.(auxsdir," CL=",aux_CL,"%");

# Temperature

tf=last(time_deform);

fig_Temp=Figure(size=(1920,1080));
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

# Total energy and Log

fig_Energy=Figure(size=(1920,1080));
ax_leg=Axis(fig_Energy[1:2,3],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_E = Axis(fig_Energy[1,1:2],
        title = L"\mathrm{Total~energy}",
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
ax_Elo = Axis(fig_Energy[2,1:2],
        title = L"\mathrm{Total~Energy}",
        xlabel = L"\mathrm{Time~steps}~\ln_{10}",
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
        limits = (10e0,exp10(round(log10( length(time_assembly)+length(time_deform)))),nothing,nothing)
    )

println("Plotting lines")

series!(ax_E,time_assembly,Eng_assembly',color=:tab10)
series!(ax_E,time_deform,Eng_shear',color=:tab10)
vlines!(ax_E,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_Elo,eachindex(time_assembly),Eng_assembly',color=:tab10)
series!(ax_Elo,eachindex(time_deform).+length(time_assembly),Eng_shear',color=:tab10)
vlines!(ax_Elo,length(time_assembly),linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=:tab10,labels=labels_CL)

println("Legends")

Legend(fig_Energy[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )

# Potential energy

fig_EngPot=Figure(size=(1920,1080));
ax_leg=Axis(fig_EngPot[1:2,5],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_Ut = Axis(fig_EngPot[1,1:2],
        title = L"\mathrm{Potential~energy}",
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
    )
ax_wca = Axis(fig_EngPot[2,1:2],
        title = L"\mathrm{WCA~potential}",
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
    )
ax_patch = Axis(fig_EngPot[1,3:4],
        title = L"\mathrm{Patch~interaction~potential}",
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
    )
ax_swap = Axis(fig_EngPot[2,3:4],
        title = L"\mathrm{Swap~potential}",
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
    )


println("Plotting lines")

series!(ax_Ut,time_assembly,U_assembly',color=:tab10)
series!(ax_Ut,time_deform,U_shear',color=:tab10)
vlines!(ax_Ut,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_wca,time_assembly,wcaPair_assembly',color=:tab10)
series!(ax_wca,time_deform,wcaPair_shear',color=:tab10)
vlines!(ax_wca,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_patch,time_assembly,patchPair_assembly',color=:tab10)
series!(ax_patch,time_deform,patchPair_shear',color=:tab10)
vlines!(ax_patch,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_swap,time_assembly,swapPair_assembly',color=:tab10)
series!(ax_swap,time_deform,swapPair_shear',color=:tab10)
vlines!(ax_swap,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=:tab10,labels=labels_CL)

println("Legends")

Legend(fig_EngPot[1:2,5],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )

# Potential energy of the deformation

fig_PotDef=Figure(size=(1920,1080));
ax_leg=Axis(fig_PotDef[1:2,5],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_Ut = Axis(fig_PotDef[1,1:2],
        title = L"\mathrm{Potential~energy}",
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
    )
ax_wca = Axis(fig_PotDef[2,1:2],
        title = L"\mathrm{WCA~potential}",
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
    )
ax_patch = Axis(fig_PotDef[1,3:4],
        title = L"\mathrm{Patch~interaction~potential}",
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
    )
ax_swap = Axis(fig_PotDef[2,3:4],
        title = L"\mathrm{Swap~potential}",
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
    )


println("Plotting lines")

series!(ax_Ut,time_shear,U_shear',color=:tab10)
vlines!(ax_Ut,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)
series!(ax_wca,time_shear,wcaPair_shear',color=:tab10)
vlines!(ax_wca,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)
series!(ax_patch,time_shear,patchPair_shear',color=:tab10)
vlines!(ax_patch,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)
series!(ax_swap,time_shear,swapPair_shear',color=:tab10)
vlines!(ax_swap,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)
series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=:tab10,labels=labels_CL)

Legend(fig_PotDef[1:2,5],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )



# Stress
time_stress=parameters[1][13].*stress_shear[1][1,:];
stressXX=reduce(hcat,map(s->-stress_shear[s][3,:],eachindex(stress_shear)));
stressXY=reduce(hcat,map(s->-stress_shear[s][6,:],eachindex(stress_shear)));

fig_Stress = Figure(size=(1080,980));
ax_leg=Axis(fig_Stress[1:2,3],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
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
                  )

series!(ax_stressXX,time_stress,stressXX',color=:tab10)
vlines!(ax_stressXX,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_stressXY,time_stress,stressXY',color=:tab10)
vlines!(ax_stressXY,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=:tab10,labels=labels_CL)

println("Legends")

Legend(fig_Stress[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )


