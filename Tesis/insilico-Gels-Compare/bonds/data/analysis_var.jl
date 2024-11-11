"""
    Script to create plots that compares
    It assumes that all data has the same temporal domain.
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
selc_ShearRate=string.((1000,100,10));
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
auxs_indShearRate=Iterators.flatten(map(s->findall(r->r==s, first.(aux_dirs_ind) ),selc_ShearRate))|>collect;

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
#data=map(s->getData2(dirs[s],file_name,parameters[s]),eachindex(dirs));

# Separate the data from assembly and shear experiment
#data_assembly=first.(data);
#data_shear=last.(data);

# Create temporal domains for the graphs

## Time instante fro assembly
tm_heat=round(Int64,parameters[1][11]);
tm_iso=round(Int64,parameters[1][12]);
tm_ass=tm_heat+tm_iso;

## Auxiliar time instants for shear deformation
# Time steps for each deformation
tm_def=Iterators.flatten(map(s->round(Int64,s[17]*s[18]),parameters))|>collect;

# Time step for all cycles
tm_Totdef=(4).*tm_def;

# Add relaxtimes
tm_Totshear=tm_Totdef.+Iterators.flatten(map(s->round(Int64,sum(s[19:22])),parameters))|>collect;

## Time domains
time_assembly=parameters[1][10].*range(1,tm_ass,length=round(Int64,div(tm_ass,parameters[1][14]))); 
time_assemblyStress=parameters[1][10].*range(1,tm_ass,length=round(Int64,div(tm_ass,parameters[1][25])));

time_shear=map(s->last(time_assembly).+parameters[s][15].*range(1,tm_Totshear[s],length=round(Int64,div(tm_Totshear[s],parameters[s][24]))), eachindex(dirs));
time_shearStress=map(s->last(time_assembly).+parameters[s][15].*range(1,tm_Totshear[s],length=round(Int64,div(tm_Totshear[s],parameters[s][25]))), eachindex(dirs));

time_deform=map(s->parameters[s][15].*range(1,tm_Totshear[s],length=round(Int64,div(tm_Totshear[s],parameters[s][25]))), eachindex(dirs));

# Get time instants
tm_rlx1o=tm_ass.+tm_Totshear;
tm_rlx1f=tm_rlx1o.+Iterators.flatten(map(s->s[15]*s[19],parameters))|>collect;

tm_rlx2o=tm_rlx1f.+tm_Totshear;
tm_rlx2f=tm_rlx2o.+Iterators.flatten(map(s->s[15]*s[20],parameters))|>collect;

tm_rlx3o=tm_rlx2f.+tm_Totshear;
tm_rlx3f=tm_rlx3o.+Iterators.flatten(map(s->s[15]*s[21],parameters))|>collect;

tm_rlx4o=tm_rlx3f.+tm_Totshear;
tm_rlx4f=tm_rlx4o.+Iterators.flatten(map(s->s[15]*s[22],parameters))|>collect;

# Stuff for stress domain
## Indixes to get the stress for each part of the experiment.
ind_tm_def=eachindex.(aux_tm_def);
ind_rltmStress=map(s->range.(1,Int64.(div.(s[19:22],s[25]))),parameters);

ind_rltmStress1=map(s->last(ind_tm_def[s]).+ind_rltmStress[s][1],eachindex(dirs));
ind_tm_defStress2=map(s->last(ind_rltmStress1[s]).+ind_tm_def[s],eachindex(dirs));

ind_rltmStress2=map(s->last(ind_tm_defStress2[s]).+ind_rltmStress[s][2],eachindex(dirs));
ind_tm_defStress3=map(s->last(ind_rltmStress2[s]).+ind_tm_def[s],eachindex(dirs));

ind_rltmStress3=map(s->last(ind_tm_defStress3[s]).+ind_rltmStress[s][3],eachindex(dirs));
ind_tm_defStress4=map(s->last(ind_rltmStress3[s]).+ind_tm_def[s],eachindex(dirs));

ind_rltmStress4=map(s->last(ind_tm_defStress4[s]).+ind_rltmStress[s][4],eachindex(dirs));

# Gamma domain
dgamma=map(s->parameters[s][16]*parameters[s][15],eachindex(dirs));#*2*parameters[1][7]; # shear_rate*dt*h

aux_tm_defStress=map(s->range(1,tm_def[s],length=round(Int64,div(tm_def[s],parameters[s][25]))),eachindex(dirs));
gammaStress_deform=map(s->dgamma[s].*aux_tm_defStress[s],eachindex(dirs));

gammaStress_deform2=map(s->last(gammaStress_deform[s]).+gammaStress_deform[s],eachindex(gammaStress_deform));
gammaStress_deform3=map(s->last(gammaStress_deform2[s]).+gammaStress_deform[s],eachindex(gammaStress_deform));
gammaStress_deform4=map(s->last(gammaStress_deform3[s]).+gammaStress_deform[s],eachindex(gammaStress_deform));

# Stuff for not stress domains, but use gamma
aux_tm_def=map(s->range(1,tm_def[s],length=round(Int64,div(tm_def[s],parameters[s][24]))),eachindex(dirs));
gamma_deform=map(s->dgamma[s].*aux_tm_def[s],eachindex(dirs));

gamma_deform2=map(s->last(gamma_deform[s]).+gamma_deform[s],eachindex(gamma_deform));
gamma_deform3=map(s->last(gamma_deform2[s]).+gamma_deform[s],eachindex(gamma_deform));
gamma_deform4=map(s->last(gamma_deform3[s]).+gamma_deform[s],eachindex(gamma_deform));

## Indixes to get the stress for each part of the experiment.
ind_tm_def=eachindex.(aux_tm_def);
ind_rltm=map(s->range.(1,Int64.(div.(s[19:22],s[24]))),parameters);

ind_rltm1=map(s->last(ind_tm_def[s]).+ind_rltm[s][1],eachindex(dirs));
ind_tm_def2=map(s->last(ind_rltm1[s]).+ind_tm_def[s],eachindex(dirs));

ind_rltm2=map(s->last(ind_tm_def2[s]).+ind_rltm[s][2],eachindex(dirs));
ind_tm_def3=map(s->last(ind_rltm2[s]).+ind_tm_def[s],eachindex(dirs));

ind_rltm3=map(s->last(ind_tm_def3[s]).+ind_rltm[s][3],eachindex(dirs));
ind_tm_def4=map(s->last(ind_rltm3[s]).+ind_tm_def[s],eachindex(dirs));

ind_rltm4=map(s->last(ind_tm_def4[s]).+ind_rltm[s][4],eachindex(dirs));




#csh=:tab20;
#scatter!(ax, 2, 0, color = 1, colormap = :tab10, colorrange = (1, 10))

# Create the labels
lbls=map(s->string(L"\mathrm{CL:}",s[5],L"~\gamma:",s[16]),parameters);

# Prepare the color map and color range
cmap=:tab10;
crng=(1,length(dirs));
alph=0.5;

# Temperature Figure


fig_Temp=Figure(size=(1920,1080));
ax_leg=Axis(fig_Temp[1:2,3],limits=(0.01,0.1,0.01,0.1))
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_t = Axis(fig_Temp[1,1:2],
        title = L"\mathrm{Temperature~Assembly~Simulation}",
        xlabel = L"\mathrm{Time~}[\tau]",
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
        #limits = (nothing,nothing,0,mean_T_ass+4*std_T_ass)
    )
ax_tsd = Axis(fig_Temp[2,1:2],
        title = L"\mathrm{Temperature~Shear~Deformation}",
        xlabel = L"\mathrm{Deformation~}[\sigma]",
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
        #limits = (nothing,nothing,0,mean_T_ass+4std_T_ass)
    )
ax_trx = Axis(fig_Temp[3,1:2],
        title = L"\mathrm{Temperature~Relax~Periods}",
        xlabel = L"\mathrm{Deformation~}[\sigma]",
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
        #limits = (nothing,nothing,0,mean_T_ass+4std_T_ass)
    )
map(s->lines!(ax_t,time_assembly,data_assembly[s][3],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))
#hlines!(ax_t,mean_T_ass,linestyle=:dash,color=:black)
#hlines!(ax_t,[mean_T_ass+std_T_ass,mean_T_ass+2*std_T_ass,mean_T_ass+3*std_T_ass],linestyle=:dash,color=:red)
#vlines!(ax_t,parameters[1][10]*parameters[1][11],linestyle=:dash,color=:black)

#map(s->lines!(ax_tcp,time_shear[s],data_shear[s][3],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))

map(s->lines!(ax_tsd,gamma_deform[s],data_shear[s][3][ind_tm_def[s]],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))
map(s->lines!(ax_tsd,gamma_deform2[s],data_shear[s][3][ind_tm_def2[s]],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))
map(s->lines!(ax_tsd,gamma_deform3[s],data_shear[s][3][ind_tm_def3[s]],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))
map(s->lines!(ax_tsd,gamma_deform4[s],data_shear[s][3][ind_tm_def4[s]],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))

#lines!(ax_tcp,time_shear,data_shear[3])
#hlines!(ax_tcp,mean_T_shear,linestyle=:dash,color=:black)
#hlines!(ax_tcp,[mean_T_shear+std_T_shear,mean_T_shear+2*std_T_shear,mean_T_shear+3*std_T_shear],linestyle=:dash,color=:red)

#vlines!(ax_tcp,[tm_rlx1o,tm_rlx1f,tm_rlx2o,tm_rlx2f,tm_rlx3o,tm_rlx3f,tm_rlx4o,tm_rlx4f],linestyle=:dash,color=:black)
aux_Norm=Iterators.flatten(map(s->round(Int64,s[15]*4*s[17]*s[18]/s[24]),parameters))|>collect;
map(s->lines!(ax_trx,time_shear[s][ind_rltm1[s]],data_shear[s][3][ind_rltm1[s]],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))
map(s->lines!(ax_trx,time_shear[s][ind_rltm2[s]],data_shear[s][3][ind_rltm2[s]],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))
map(s->lines!(ax_trx,time_shear[s][ind_rltm3[s]],data_shear[s][3][ind_rltm3[s]],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))
map(s->lines!(ax_trx,time_shear[s][ind_rltm4[s]],data_shear[s][3][ind_rltm4[s]],color=s,colormap=cmap,colorrange=crng),eachindex(dirs))

#series!(ax_leg,zeros(length(dirs),length(dirs)),linestyle=:solid,color=cmap,labels=lbls)
map(s->scatter!(ax_leg,0,0,color=s,colormap=cmap,colorrange=crng,label=lbls[s]),eachindex(dirs))


Legend(fig_Temp[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       L"\mathrm{Concentration~and~Shear~Rate}",
       patchsize=(35,35)
      )
