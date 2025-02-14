"""
    Individual visual analysis
"""

using FileIO
using GLMakie
using Statistics

include("functions.jl")

# Create the file with the dirs names
run(`bash getDir.sh`)
# Store the dirs names
dirs_aux = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
    end

#dirs=dirs_aux;

#aux_indx=map(s->split(dirs_aux[1],"Nexp")[1] == split(dirs_aux[s],"Nexp")[1],eachindex(dirs_aux));
"""
   Start of the classification process.
   Parameters to select the system:
   phi -> Packing fraction
   NPart -> Number of central particles
   damp -> damp langevin parameter
   T -> Temperature of the system
   cCL -> CrossLink concentration
   ShearRate -> Self explanatory
   Nexp -> Number of simulation
"""

selc_phi="5500";
selc_Npart="500";
selc_damp="5000";
selc_T="500";
selc_cCL="300";
selc_ShearRate="1000";
selc_Nexp="251";

aux_dirs_ind=split.(last.(split.(dirs_aux,"Phi")),"NPart");
auxs_indPhi=findall(r->r==selc_phi, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"damp");
auxs_indNPart=findall(r->r==selc_Npart, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"T");
auxs_indDamp=findall(r->r==selc_damp, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"cCL");
auxs_indT=findall(r->r==selc_T, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"ShearRate");
auxs_indcCL=findall(r->r==selc_cCL, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"-");
auxs_indShearRate=findall(r->r==selc_ShearRate, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"Nexp");
auxs_indNexp=findall(r->r==selc_Nexp, last.(aux_dirs_ind) );

# Get the idixes that meet the criteria
auxs_ind=intersect(auxs_indPhi,auxs_indNPart,auxs_indDamp,auxs_indT,auxs_indcCL,auxs_indShearRate,auxs_indNexp);

# Select the number of experiments
auxs_ind=auxs_ind;

# Selcet the directories woth the criteria
dirs=dirs_aux[auxs_ind];


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
    1 -> Packing fraction
    2 -> Number of particles
    3 -> Number of Cross-Linkers
    4 -> Number of Monomers
    5 -> Cross-Linker Concentration
    6 -> Box Volume
    7 -> L in lammps (Half length of box) 
    8 -> Temperature
    9 -> Damp
   10 -> Time step in assembly
   11 -> Number of time steps in heating process in assembly
   12 -> Number of time steps in isothermal process in assembly 
   13 -> Save every N time steps in dumps files
   14 -> Save every N time steps in fix files
   15 -> Time step in shear
   16 -> Shear rate
   17 -> Max deformation per cycle
   18 -> Number of time steps per deformation
   19 -> Relax time 1 [Time steps]
   20 -> Relax time 2 [Time steps]
   21 -> Relax time 3 [Time steps]
   22 -> Relax time 4 [Time steps]
   23 -> Save every N time steps in dumps files
   24 -> Save every N time steps in fix files
   25 -> Save every N time steps for Stress fix files
"""

parameters=getParameters(dirs,file_name,auxs_ind);

# Retrieve all the data from every experiment
data=getData2(dirs[1],file_name,parameters[1]);

# Separate the data from assembly and shear experiment
data_assembly=first(data);
data_shear=last(data);

# From time steps to time units

time_assembly=parameters[1][10].*range(0,sum(parameters[1][11:12]),length=round(Int64,sum(parameters[1][11:12])/parameters[1][14])); #data_assembly[1];
time_assemblyStress=parameters[1][10].*data_assembly[2];

time_shear=last(time_assembly).+parameters[1][15].*data_shear[1];
time_shearStress=parameters[1][15].*data_shear[2];

# Get time instants
tm_endAssembly=parameters[1][10]*(parameters[1][11]+parameters[1][12]);

tm_shear=parameters[1][15]*parameters[1][17]*parameters[1][18];

tm_rlx1o=tm_endAssembly+tm_shear;
tm_rlx1f=tm_rlx1o+parameters[1][15]*parameters[1][19];

tm_rlx2o=tm_rlx1f+tm_shear;
tm_rlx2f=tm_rlx2o+parameters[1][15]*parameters[1][20];

tm_rlx3o=tm_rlx2f+tm_shear;
tm_rlx3f=tm_rlx3o+parameters[1][15]*parameters[1][21];

tm_rlx4o=tm_rlx3f+tm_shear;
tm_rlx4f=tm_rlx4o+parameters[1][15]*parameters[1][22];

csh=:tab20;

## Temperature

tf=last(time_assembly);

# Mean and standard values of Temperature
mean_T_ass=mean(data_assembly[3][Int64(parameters[1][12]/parameters[1][14]):end]);
std_T_ass=std(data_assembly[3][Int64(parameters[1][12]/parameters[1][14]):end],mean=mean_T_ass);

mean_T_shear=mean(data_shear[3]);
std_T_shear=std(data_shear[3],mean=mean_T_shear);

fig_Temp=Figure(size=(1920,1080));
ax_leg=Axis(fig_Temp[1:2,3],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_t = Axis(fig_Temp[1,1:2],
        title = L"\mathrm{Temperature~Assembly~Simulation}",
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
        limits = (nothing,nothing,0,mean_T_ass+4*std_T_ass)
    )
ax_tcp = Axis(fig_Temp[2,1:2],
        title = L"\mathrm{Temperature~Shear~Simulation}",
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
        limits = (nothing,nothing,0,mean_T_ass+4std_T_ass)
    )

lines!(ax_t,time_assembly,data_assembly[3])
hlines!(ax_t,mean_T_ass,linestyle=:dash,color=:black)
hlines!(ax_t,[mean_T_ass+std_T_ass,mean_T_ass+2*std_T_ass,mean_T_ass+3*std_T_ass],linestyle=:dash,color=:red)
vlines!(ax_t,parameters[1][10]*parameters[1][11],linestyle=:dash,color=:black)


lines!(ax_tcp,time_shear,data_shear[3])
hlines!(ax_tcp,mean_T_shear,linestyle=:dash,color=:black)
hlines!(ax_tcp,[mean_T_shear+std_T_shear,mean_T_shear+2*std_T_shear,mean_T_shear+3*std_T_shear],linestyle=:dash,color=:red)

vlines!(ax_tcp,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)


#hlines!(ax_tcp,[mean(data_shear[1][3]),mean(data_shear[1][3])+std(data_shear[1][3],mean=mean(data_shear[1][3])),mean(data_shear[1][3])-std(data_shear[1][3],mean=mean(data_shear[1][3]))],linestyle=:dash,color=:blue)

#vlines!(ax_t,time_endAssembly,linestyle=:dash,color=:black)


#map(s->lines!(ax_tcp,time_assembly[s],data_assembly[s][4]),eachindex(dirs))
#map(s->lines!(ax_tcp,time_shear[s],data_shear[s][4]),eachindex(dirs))
#hlines!(ax_tcp,mean_T_shear,linestyle=:dash,color=:black)
#hlines!(ax_tcp,[mean_T_shear+std_T_shear,mean_T_shear+2*std_T_shear,mean_T_shear+3*std_T_shear],linestyle=:dash,color=:red)



#vlines!(ax_tcp,last(time_assembly),linestyle=:dash,color=:black)
#vlines!(ax_tcp,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

#series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=csh,labels=labels_CL)

#=
Legend(fig_Temp[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )
=#

## Energy Plot

# Mean and standard values of Temperature
mean_Eng_ass=mean(data_assembly[8][Int64(parameters[1][12]/parameters[1][14]):end]);
std_Eng_ass=std(data_assembly[8][Int64(parameters[1][12]/parameters[1][14]):end],mean=mean_T_ass);

#mean_Eng_shear=mean(data_shear[2][8]);
#std_Eng_shear=std(data_shear[2][8],mean=mean_T_shear);



fig_Energy=Figure(size=(1920,1080));
ax_leg=Axis(fig_Energy[1:2,3],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_E = Axis(fig_Energy[1,1:2],
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
        #xscale = log10,
#        limits = (nothing,nothing,-4*std_Eng_ass,mean_Eng_ass+4*std_Eng_ass)
    )
ax_Elo = Axis(fig_Energy[2,1:2],
        title = L"\mathrm{Kinetic~Energy}",
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
        #xscale = log10,
#        limits = (nothing,nothing,-4*std_Eng_ass,mean_Eng_ass+4*std_Eng_ass)
    )

println("Plotting lines")

lines!(ax_E,time_assembly,data_assembly[6])
lines!(ax_E,time_shear,data_shear[6])

vlines!(ax_E,tm_endAssembly,linestyle=:dash,color=:black)
vlines!(ax_E,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)

lines!(ax_Elo,time_assembly,data_assembly[7])
lines!(ax_Elo,time_shear,data_shear[7])

vlines!(ax_Elo,tm_endAssembly,linestyle=:dash,color=:black)
vlines!(ax_Elo,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)



println("Legends")
#=
Legend(fig_Energy[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )
=#


fig_EnergyLog=Figure(size=(1920,1080));
ax_leg=Axis(fig_Energy[1:2,3],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_E = Axis(fig_EnergyLog[1,1:2],
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
#        limits = (nothing,nothing,-4*std_Eng_ass,mean_Eng_ass+4*std_Eng_ass)
    )
ax_Elo = Axis(fig_EnergyLog[2,1:2],
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
#        limits = (nothing,nothing,-4*std_Eng_ass,mean_Eng_ass+4*std_Eng_ass)
    )

println("Plotting lines")

lines!(ax_E,time_assembly,data_assembly[8])
lines!(ax_E,time_shear,data_shear[8])

vlines!(ax_E,tm_endAssembly,linestyle=:dash,color=:black)
vlines!(ax_E,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)

lines!(ax_Elo,time_assembly,data_assembly[8])
lines!(ax_Elo,time_shear,data_shear[8])

vlines!(ax_Elo,tm_endAssembly,linestyle=:dash,color=:black)


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

lines!(ax_Ut,time_assembly,data_assembly[6])
lines!(ax_Ut,time_shear,data_shear[6])

vlines!(ax_Ut,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)
vlines!(ax_Ut,tm_endAssembly,linestyle=:dash,color=:black)

lines!(ax_wca,time_assembly,data_assembly[9])
lines!(ax_wca,time_shear,data_shear[9])

vlines!(ax_wca,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)
vlines!(ax_wca,tm_endAssembly,linestyle=:dash,color=:black)

lines!(ax_patch,time_assembly,data_assembly[10])
lines!(ax_patch,time_shear,data_shear[10])

vlines!(ax_patch,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)
vlines!(ax_patch,tm_endAssembly,linestyle=:dash,color=:black)

lines!(ax_swap,time_assembly,data_assembly[11])
lines!(ax_swap,time_shear,data_shear[11])

vlines!(ax_swap,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)
vlines!(ax_swap,tm_endAssembly,linestyle=:dash,color=:black)
#=

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

=#



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

lines!(ax_stressXX,time_shearStress,data_shear[15])
#vlines!(ax_stressXX,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)

lines!(ax_stressXY,time_shearStress,data_shear[16])
#vlines!(ax_stressXY,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)

#series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=csh,labels=labels_CL)

println("Legends")

#=
Legend(fig_Stress[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~damp}",
       patchsize=(35,35)
      )

vlines!(ax_swap,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)
vlines!(ax_swap,tm_endAssembly,linestyle=:dash,color=:black)
=#

















#=
# Create time and deformation arrays.
time_assembly=range(0,parameters[1][9].*parameters[1][10],length=length(data_assembly[1][1]));  #Int64(parameters[1][10]/10));

# Auxiliar
tshear_aux=Int64(parameters[1][20]*parameters[1][17]+sum(parameters[1][21:24]));
time_shear=range(0,parameters[1][15]*tshear_aux,length=length(data_shear[1][1])); # Just the deformation process

# Add the last time step of assembly process
time_deform=last(time_assembly).+time_shear;

# Auxiliar times for vertical lines to distinct shear deformation and relax times
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

=#

# Plot the stress with respect the spatial deformation
"""
    shear_rate = velocity/shear_gap; shear_gap is the height of the simulation box.
    shear_rate = (gamma/dt)/shear_gap;
    gamma = shear_rate*shear_gap*dt
"""
#gamma=reduce(vcat,parameters[1][19].*cbrt(parameters[1][7]).*[deform1,rlx1,deform2,rlx2,deform3,rlx3,deform4,rlx4]);


#=
# Labels
lblaux_CL=map(s->Int64.(round(s[3]*100)),parameters);
lblaux_damp=map(s->s[6],parameters);
lblaux_gammadot=map(s->s[19],parameters);
#auxsdir=map(s->s[2],split.(dirs,"/"));
#labels_CL=string.(first.(split.(dirs,"/"))," CL=",aux_CL,"%");
labels_CL=string.("CL=",lblaux_CL,"%, damp=",lblaux_damp,L"\dot{\gamma}=",lblaux_gammadot);



csh=:tab20;

# Temperature

tf=last(time_assembly);

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
#map(s->lines!(ax_t,tshear_aux[s],data_shear[s][1]),eachindex(dirs))
vlines!(ax_t,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)


vlines!(ax_t,last(time_assembly),linestyle=:dash,color=:black)

series!(ax_tcp,time_assembly,reduce(hcat,map(s->s[2],data_assembly))',color=csh)
series!(ax_tcp,time_deform,reduce(hcat,map(s->s[2],data_shear))',color=csh)
vlines!(ax_tcp,last(time_assembly),linestyle=:dash,color=:black)
vlines!(ax_tcp,[time_rlxo1,time_rlxf1,time_rlxo2,time_rlxf2,time_rlxo3,time_rlxf3,time_rlxo4,time_rlxf4],linestyle=:dash,color=:black)

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
=#

#=

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

=#
