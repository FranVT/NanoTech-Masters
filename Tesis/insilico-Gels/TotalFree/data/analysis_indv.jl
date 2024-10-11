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

    # [1:4]
    # [5:8]
    # [9:12]

dirs=dirs_aux;
    #    dirs=dirs_aux[11:15]; #[2:end];
#dirs=dirs_aux[5:8];
#dirs=dirs_aux[9:12];
#dirs=dirs_aux[1:4];

# File names 

file_name = (
             "parameters",
             "energy_assembly.fixf",
             "wcaPair_assembly.fixf",
             "patchPair_assembly.fixf",
             "swapPair_assembly.fixf",
             "cmdisplacement_assembly.fixf",
             "stressVirial_assembly.fixf",
             "energy_shear.fixf",
             "wcaPair_shear.fixf",
             "patchPair_shear.fixf",
             "swapPair_shear.fixf",
             "cmdisplacement_shear.fixf",
             "stressVirial_shear.fixf"
            );

#"""
# Get parameters from the directories
"""
    Relation of index with parameter
    1 -> Central particle radius
    2 -> Patch particle radius
    3 -> Cross-Linker Concentration
    4 -> Number of particles
    5 -> Temperature
    6 -> Damp
    7 -> Box Volume
    8 -> Packing fraction
    9 -> Time step in assembly
   10 -> Number of time steps in assembly
   11 -> Save every N time steps in assembly
   12 -> Number of Cross-Linkers 
   13 -> Number of Monomers
   14 -> Box Volume
   15 -> Time step in shear
   16 -> Number of time steps in shear
   17 -> Number of time steps per deformation
   18 -> Save every N time steps
   19 -> Shear rate
   20 -> Max deformation per cycle
   21 -> Relax time 1
   22 -> Relax time 2 
   23 -> Relax time 3
   24 -> Relax time 4
"""



parameters=getParameters(dirs,file_name);

# Retrieve all the data from every experiment
data=map(s->getData2(dirs[s],file_name[1:7],parameters[s]),eachindex(dirs));

# Separate the data from assembly and shear experiment
data_assembly=first.(data);
data_shear=last.(data);

# Create time and deformation arrays.
time_assembly=range(0,parameters[1][9].*parameters[1][10],length=Int64(parameters[1][10]/10));
tshear_aux=Int64(4*parameters[1][20]*parameters[1][17]+sum(parameters[1][21:24]));
time_shear=range(0,parameters[1][15]*tshear_aux,length=Int64(tshear_aux/1000));
time_deform=range(last(time_assembly),last(time_assembly)+parameters[1][15]tshear_aux,length=Int64(tshear_aux/10));

time_rlxaux=Int64(parameters[1][15]*parameters[1][20]*parameters[1][17]);
time_rlxo1=time_rlxaux;
time_rlxf1=time_rlxo1+parameters[1][15]*parameters[1][21];
time_rlxo2=time_rlxf1+time_rlxaux;
time_rlxf2=time_rlxo2+parameters[1][15]*parameters[1][22];
time_rlxo3=time_rlxf2+time_rlxaux;
time_rlxf3=time_rlxo3+parameters[1][15]*parameters[1][23];
time_rlxo4=time_rlxf3+time_rlxaux;
time_rlxf4=time_rlxo4+parameters[1][15]*parameters[1][24];

deform1=range(0,parameters[1][20],length=Int64(parameters[1][20]*parameters[1][17]/1000))|>collect;
rlx1=last(deform1).*ones(Int64(parameters[1][21]/1000));
deform2=range(last(deform1),last(deform1)+parameters[1][20],length=Int64(parameters[1][20]*parameters[1][17]/1000))|>collect;
rlx2=last(deform2).*ones(Int64(parameters[1][22]/1000));
deform3=range(last(deform2),last(deform2)+parameters[1][20],length=Int64(parameters[1][20]*parameters[1][17]/1000))|>collect;
rlx3=last(deform3).*ones(Int64(parameters[1][23]/1000));
deform4=range(last(deform3),last(deform3)+parameters[1][20],length=Int64(parameters[1][20]*parameters[1][17]/1000))|>collect;
rlx4=last(deform4).*ones(Int64(parameters[1][24]/1000));

gamma=reduce(vcat,[deform1,rlx1,deform2,rlx2,deform3,rlx3,deform4,rlx4]);

# Labels
lblaux_CL=map(s->Int64.(round(s[3]*100)),parameters);
lblaux_T=map(s->s[5],parameters);
lblaux_damp=map(s->s[6],parameters);
#auxsdir=map(s->s[2],split.(dirs,"/"));
#labels_CL=string.(first.(split.(dirs,"/"))," CL=",aux_CL,"%");
labels_CL=string.("T=",lblaux_T,", CL=",lblaux_CL,"%, damp=",lblaux_damp);



csh=:tab20;

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

series!(ax_t,time_assembly,reduce(hcat,map(s->s[1],data_assembly))',color=csh)
series!(ax_t,time_deform,reduce(hcat,map(s->s[1],data_shear))',color=csh)
vlines!(ax_t,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_tcp,time_assembly,reduce(hcat,map(s->s[2],data_assembly))',color=csh)
series!(ax_tcp,time_deform,reduce(hcat,map(s->s[2],data_shear))',color=csh)
vlines!(ax_tcp,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=csh,labels=labels_CL)

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

series!(ax_E,time_assembly,reduce(hcat,map(s->s[5],data_assembly))',color=csh)
series!(ax_E,time_deform,reduce(hcat,map(s->s[5],data_shear))',color=csh)
vlines!(ax_E,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_Elo,eachindex(time_assembly),reduce(hcat,map(s->s[5],data_assembly))',color=csh)
series!(ax_Elo,eachindex(time_deform).+length(time_assembly),reduce(hcat,map(s->s[5],data_shear))',color=csh)
vlines!(ax_Elo,length(time_assembly),linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=csh,labels=labels_CL)

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

series!(ax_Ut,time_assembly,reduce(hcat,map(s->s[3],data_assembly))',color=csh)
series!(ax_Ut,time_deform,reduce(hcat,map(s->s[3],data_shear))',color=csh)
vlines!(ax_Ut,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_wca,time_assembly,reduce(hcat,map(s->s[6],data_assembly))',color=csh)
series!(ax_wca,time_deform,reduce(hcat,map(s->s[6],data_shear))',color=csh)
vlines!(ax_wca,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_patch,time_assembly,reduce(hcat,map(s->s[7],data_assembly))',color=csh)
series!(ax_patch,time_deform,reduce(hcat,map(s->s[7],data_shear))',color=csh)
vlines!(ax_patch,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_swap,time_assembly,reduce(hcat,map(s->s[8],data_assembly))',color=csh)
series!(ax_swap,time_deform,reduce(hcat,map(s->s[8],data_shear))',color=csh)
vlines!(ax_swap,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=csh,labels=labels_CL)

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

series!(ax_Ut,time_deform.-last(time_assembly),reduce(hcat,map(s->s[3],data_shear))',color=csh)
vlines!(ax_Ut,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_wca,time_deform.-last(time_assembly),reduce(hcat,map(s->s[6],data_shear))',color=csh)
vlines!(ax_wca,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_patch,time_deform.-last(time_assembly),reduce(hcat,map(s->s[7],data_shear))',color=csh)
vlines!(ax_patch,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_swap,time_deform.-last(time_assembly),reduce(hcat,map(s->s[8],data_shear))',color=csh)
vlines!(ax_swap,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=csh,labels=labels_CL)

Legend(fig_PotDef[1:2,5],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )



# Stress
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

series!(ax_stressXX,time_shear,reduce(hcat,map(s->s[12],data_shear))',color=csh)
vlines!(ax_stressXX,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_stressXY,time_shear,reduce(hcat,map(s->s[13],data_shear))',color=csh)
vlines!(ax_stressXY,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=csh,labels=labels_CL)

println("Legends")

Legend(fig_Stress[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )


# Holap
fig_Displ = Figure(size=(1080,980));
ax_leg=Axis(fig_Displ[1:2,3],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_DisplCl = Axis(fig_Displ[1,1:2],
                   title = L"\mathrm{Mean~displacement~of~Cross~Linkers~during~shear}",
                   xlabel = L"\mathrm{Time [tau]}",
                   ylabel = L"\langle d \rangle",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                  )
ax_DisplMo = Axis(fig_Displ[2,1:2],
                   title = L"\mathrm{Mean~displacement~of~Monomers~during~shear}",
                   xlabel = L"\mathrm{Time [tau]}",
                   ylabel = L"\langle d \rangle",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                  )
ax_DisplCM = Axis(fig_Displ[3,1:2],
                   title = L"\mathrm{Mean~displacement~of~Central~Particles~during~shear}",
                   xlabel = L"\mathrm{Time [tau]}",
                   ylabel = L"\langle d \rangle",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                  )

series!(ax_DisplCl,time_shear,reduce(hcat,map(s->s[9],data_shear))',color=csh)
vlines!(ax_DisplCl,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_DisplMo,time_shear,reduce(hcat,map(s->s[10],data_shear))',color=csh)
vlines!(ax_DisplMo,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_DisplCM,time_shear,reduce(hcat,map(s->s[11],data_shear))',color=csh)
vlines!(ax_DisplCM,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=csh,labels=labels_CL)

println("Legends")

Legend(fig_Displ[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )


