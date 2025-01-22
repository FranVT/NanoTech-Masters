"""
    Comparisson with different systems
"""

using FileIO
#using GLMakie
using CairoMakie
using LaTeXStrings
using Statistics

# Add functions to acces infromation from files
include("functions.jl")

"""
    Select the desire systems to analyse
"""

selc_phi="5500";
selc_Npart="8000";
selc_damp="5000";
selc_T="500";
selc_cCL="300";
selc_ShearRate=string.((10,50,100));
selc_Nexp=string.(1:10);

dirs=Iterators.partition(getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp),length(selc_Nexp))|>collect;

files_names = (
               "parameters",
               "energy_assembly.fixf",
               "wcaPair_assembly.fixf",
               "patchPair_assembly.fixf",
               "swapPair_assembly.fixf",
               "stressVirial_assembly.fixf",
               "cmdisplacement_assembly.fixf",
               "energy_shear.fixf",
               "wcaPair_shear.fixf",
               "patchPair_shear.fixf",
               "swapPair_shear.fixf",
               "stressVirial_shear.fixf",
               "cmdisplacement_shear.fixf",
              );

# Get the parameters of the system

file_dir=map(s->joinpath(first(s),first(files_names)),dirs);

parameters=map(file_dir) do r 
open(r) do f
    map(s->parse(Float64,s),readlines(f))
end
end

# The system energy and stuff are means of N experiments of the same system.

  
# Files per fix files per experiment
file_dir=map(dirs) do f
    map(s->reduce(vcat,map(r->joinpath(r,"info",s),f)),files_names[2:end]);
end

# Retrieve the information of the system

data=map(eachindex(file_dir)) do f
    getDataSystem(parameters[f],file_dir[f]);
end

"""
   Some Statistics

aux_parm=(
          dt=parameters[15],
          shear_rate=parameters[16],
          h=2*parameters[7],
          Stress fix files = parameters[25]
        );
"""

strain_fct=map(s->parameters[s][25]*parameters[s][15]*parameters[s][16],eachindex(parameters));#*aux_parm.h;
aux_def=map(s-> reduce(vcat,[s[1].deform1_s,s[1].deform2_s,s[1].deform3_s,s[1].deform4_s]),data);
aux_rlx=map(s-> reduce(vcat,[s[1].rlx1_s,s[1].rlx2_s,s[1].rlx3_s,s[1].rlx4_s]),data);


lng_def_indx=map(s->Int64.((1*s[18]/s[25]+1:1:s[17]*s[18]/s[25])),parameters);

mean_cycle1=reduce(vcat,map(s->mean(data[s][2].XY[data[s][1].deform1_s[lng_def_indx[s]]]),(2,3,1)));
mean_cycle2=reduce(vcat,map(s->mean(data[s][2].XY[data[s][1].deform2_s[lng_def_indx[s]]]),(2,3,1)));
mean_cycle3=reduce(vcat,map(s->mean(data[s][2].XY[data[s][1].deform3_s[lng_def_indx[s]]]),(2,3,1)));
mean_cycle4=reduce(vcat,map(s->mean(data[s][2].XY[data[s][1].deform4_s[lng_def_indx[s]]]),(2,3,1)));



"""
    Plots
"""

fig_mean_stress=Figure(size=(1920,1080));
ax_leg=Axis(fig_mean_stress[1:1,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_mean_stress=Axis(fig_mean_stress[1:1,1:1],
                    title=L"\mathrm{Shear~rate~vs~Stress}~xy~\mathrm{component}",
                    xlabel=L"\mathrm{Shear~Rate}",
                    ylabel=L"\mathrm{Mean~Stress}~xy~\mathrm{component}",
                    titlesize=24.0f0,
                    xticklabelsize=18.0f0,
                    yticklabelsize=18.0f0,
                    xlabelsize=20.0f0,
                    ylabelsize=20.0f0,
                    xminorticksvisible=true,
                    xminorgridvisible=true
                   )
dom_shearRate=reduce(vcat,map(s->parameters[s][16],(2,3,1)));

lines!(ax_mean_stress,dom_shearRate,mean_cycle1)
scatter!(ax_mean_stress,dom_shearRate,mean_cycle1)
lines!(ax_mean_stress,dom_shearRate,mean_cycle2)
scatter!(ax_mean_stress,dom_shearRate,mean_cycle2)
lines!(ax_mean_stress,dom_shearRate,mean_cycle3)
scatter!(ax_mean_stress,dom_shearRate,mean_cycle3)
lines!(ax_mean_stress,dom_shearRate,mean_cycle4)
scatter!(ax_mean_stress,dom_shearRate,mean_cycle4)


# Legends
map(s->lines!(ax_leg,0,0,label=latexstring(s,"~\\mathrm{Cycle}")),1:4)

Legend(fig_mean_stress[1:1,2],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )


#"""
# Total Energy
fig_energy_log=Figure(size=(1920,1080));
ax_leg=Axis(fig_energy_log[1:2,3],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_assembly=Axis(fig_energy_log[1,1:2],
               title=L"\mathrm{Total~Energy~of~Assembly~simulation}",
               xlabel=L"\mathrm{Time~steps~}\log_{10}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               xscale=log10
              )
ax_shear=Axis(fig_energy_log[2,1:2],
               title=L"\mathrm{Total~Energy~of~Shear~simulation}",
               xlabel=L"\mathrm{Time~[unit~less]~}\log_{10}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               xscale=log10
              )

# Domains
strain_fct=map(s->parameters[s][25]*parameters[s][15]*parameters[s][16]*2*parameters[s][7],eachindex(parameters));#*aux_parm.h;
aux_def=map(s-> reduce(vcat,[s[1].deform1,s[1].deform2,s[1].deform3,s[1].deform4]),data) ;
aux_rlx=map(s-> reduce(vcat,[s[1].rlx1,s[1].rlx2,s[1].rlx3,s[1].rlx4]),data);

# Assembly
map(s->lines!(ax_assembly,s[2].energy[s[1].assembly]),data)

# Shear deformations
map(s->lines!(ax_shear,strain_fct[s].*(1:1:length( data[s][1].shear )),data[s][2].energy[data[s][1].shear]),eachindex(parameters))

# Legends
map(s->lines!(ax_leg,0,0,label=latexstring("\\dot{\\gamma}:~",s[3].shearRate,"~%\\mathrm{CL}:~",100*s[3].clCon)),data)

Legend(fig_energy_log[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )


# No log scale
fig_energy=Figure(size=(1920,1080));
ax_leg=Axis(fig_energy[1:2,3],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_assembly=Axis(fig_energy[1,1:2],
               title=L"\mathrm{Total~Energy~of~Assembly~simulation}",
               xlabel=L"\mathrm{Time~steps~}\log_{10}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_shear=Axis(fig_energy[2,1:2],
               title=L"\mathrm{Total~Energy~of~Shear~simulation}",
               xlabel=L"\mathrm{Time~[unit~less]~}\log_{10}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )

# Domains
strain_fct=map(s->parameters[s][25]*parameters[s][15]*parameters[s][16],eachindex(parameters));#*aux_parm.h;
aux_def=map(s-> reduce(vcat,[s[1].deform1,s[1].deform2,s[1].deform3,s[1].deform4]),data) ;
aux_rlx=map(s-> reduce(vcat,[s[1].rlx1,s[1].rlx2,s[1].rlx3,s[1].rlx4]),data);

# Assembly
map(s->lines!(ax_assembly,s[2].energy[s[1].assembly]),data)

# Shear
map(s->lines!(ax_shear,strain_fct[s].*(1:1:length( data[s][1].shear )),data[s][2].energy[data[s][1].shear]),eachindex(parameters))
#map(s->vlines!(ax_shear,strain_fct[s].*last(data[s][1].deform1) ),eachindex(parameters))


# Legends
map(s->lines!(ax_leg,0,0,label=latexstring("\\dot{\\gamma}:~",s[3].shearRate,"~%\\mathrm{CL}:~",100*s[3].clCon)),data)

Legend(fig_energy[1:2,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )





# Deformations and Relax intervals
fig_def_rlx=Figure(size=(1920,1080));
ax_leg=Axis(fig_def_rlx[1:2,5],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_def_norm=Axis(fig_def_rlx[1,1:2],
                 title=latexstring("\\dot{\\gamma}:~",data[2][3].shearRate,"~%\\mathrm{CL}:~",100*data[2][3].clCon,"~\\mathrm{NParticles:}~",Int64(data[2][3].Npart)), #L"\mathrm{Deformations~Norm~of~Virial~Stress}",
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_norm=Axis(fig_def_rlx[1,3:4],
                 title=latexstring("\\dot{\\gamma}:~",data[2][3].shearRate,"~%\\mathrm{CL}:~",100*data[2][3].clCon,"~\\mathrm{NParticles:}~",Int64(data[2][3].Npart)),
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_def_xy=Axis(fig_def_rlx[2,1:2],
               title=latexstring("\\dot{\\gamma}:~",data[3][3].shearRate,"~%\\mathrm{CL}:~",100*data[3][3].clCon,"~\\mathrm{NParticles:}~",Int64(data[3][3].Npart)),
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_xy=Axis(fig_def_rlx[2,3:4],
               title=latexstring("\\dot{\\gamma}:~",data[3][3].shearRate,"~%\\mathrm{CL}:~",100*data[3][3].clCon,"~\\mathrm{NParticles:}~",Int64(data[3][3].Npart)),
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_def_xx=Axis(fig_def_rlx[3,1:2],
               title=latexstring("\\dot{\\gamma}:~",data[1][3].shearRate,"~%\\mathrm{CL}:~",100*data[1][3].clCon,"~\\mathrm{NParticles:}~",Int64(data[1][3].Npart)),
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_xx=Axis(fig_def_rlx[3,3:4],
               title=latexstring("\\dot{\\gamma}:~",data[1][3].shearRate,"~%\\mathrm{CL}:~",100*data[1][3].clCon,"~\\mathrm{NParticles:}~",Int64(data[1][3].Npart)),
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )

"""
aux_parm=(
          dt=parameters[15],
          shear_rate=parameters[16],
          h=2*parameters[7]
        );
"""

strain_fct=map(s->parameters[s][25]*parameters[s][15]*parameters[s][16],eachindex(parameters));#*aux_parm.h;
aux_def=map(s-> reduce(vcat,[s[1].deform1_s,s[1].deform2_s,s[1].deform3_s,s[1].deform4_s]),data) ;
aux_rlx=map(s-> reduce(vcat,[s[1].rlx1_s,s[1].rlx2_s,s[1].rlx3_s,s[1].rlx4_s]),data);

# Norm
lines!(ax_def_norm, strain_fct[2]*(1:1:length(data[2][1].deform1_s)) ,data[2][2].XY[data[2][1].deform1_s])
lines!(ax_def_norm, strain_fct[2]*(1:1:length(data[2][1].deform2_s)) ,data[2][2].XY[data[2][1].deform2_s])
lines!(ax_def_norm, strain_fct[2]*(1:1:length(data[2][1].deform3_s)) ,data[2][2].XY[data[2][1].deform3_s])
lines!(ax_def_norm, strain_fct[2]*(1:1:length(data[2][1].deform4_s)) ,data[2][2].XY[data[2][1].deform4_s])

lines!(ax_rlx_norm, (1:1:length(data[2][1].rlx1_s)) ,data[2][2].XY[data[2][1].rlx1_s])
lines!(ax_rlx_norm, (1:1:length(data[2][1].rlx2_s)) ,data[2][2].XY[data[2][1].rlx2_s])
lines!(ax_rlx_norm, (1:1:length(data[2][1].rlx3_s)) ,data[2][2].XY[data[2][1].rlx3_s])
lines!(ax_rlx_norm, (1:1:length(data[2][1].rlx4_s)) ,data[2][2].XY[data[2][1].rlx4_s])


# Norm
lines!(ax_def_xy, strain_fct[3]*(1:1:length(data[3][1].deform1_s)) ,data[3][2].XY[data[3][1].deform1_s])
lines!(ax_def_xy, strain_fct[3]*(1:1:length(data[3][1].deform2_s)) ,data[3][2].XY[data[3][1].deform2_s])
lines!(ax_def_xy, strain_fct[3]*(1:1:length(data[3][1].deform3_s)) ,data[3][2].XY[data[3][1].deform3_s])
lines!(ax_def_xy, strain_fct[3]*(1:1:length(data[3][1].deform4_s)) ,data[3][2].XY[data[3][1].deform4_s])

lines!(ax_rlx_xy, (1:1:length(data[3][1].rlx1_s)) ,data[3][2].XY[data[3][1].rlx1_s])
lines!(ax_rlx_xy, (1:1:length(data[3][1].rlx2_s)) ,data[3][2].XY[data[3][1].rlx2_s])
lines!(ax_rlx_xy, (1:1:length(data[3][1].rlx3_s)) ,data[3][2].XY[data[3][1].rlx3_s])
lines!(ax_rlx_xy, (1:1:length(data[3][1].rlx4_s)) ,data[3][2].XY[data[3][1].rlx4_s])


# Norm
lines!(ax_def_xx, strain_fct[1]*(1:1:length(data[1][1].deform1_s)) ,data[1][2].XY[data[1][1].deform1_s])
lines!(ax_def_xx, strain_fct[1]*(1:1:length(data[1][1].deform2_s)) ,data[1][2].XY[data[1][1].deform2_s])
lines!(ax_def_xx, strain_fct[1]*(1:1:length(data[1][1].deform3_s)) ,data[1][2].XY[data[1][1].deform3_s])
lines!(ax_def_xx, strain_fct[1]*(1:1:length(data[1][1].deform4_s)) ,data[1][2].XY[data[1][1].deform4_s])

lines!(ax_rlx_xx, (1:1:length(data[1][1].rlx1_s)) ,data[1][2].XY[data[1][1].rlx1_s])
lines!(ax_rlx_xx, (1:1:length(data[1][1].rlx2_s)) ,data[1][2].XY[data[1][1].rlx2_s])
lines!(ax_rlx_xx, (1:1:length(data[1][1].rlx3_s)) ,data[1][2].XY[data[1][1].rlx3_s])
lines!(ax_rlx_xx, (1:1:length(data[1][1].rlx4_s)) ,data[1][2].XY[data[1][1].rlx4_s])

# Legends
map(s->lines!(ax_leg,0,0,label=latexstring(s,"~\\mathrm{Cycle}")),1:4)

Legend(fig_def_rlx[1:3,5],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )




# Compare each cycle with different shear rate
fig_def=Figure(size=(1920,1080));
ax_leg=Axis(fig_def[1:2,5],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_def_1=Axis(fig_def[1,1:2],
               title=latexstring("\\mathrm{Cycle}~1"),
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_def_2=Axis(fig_def[1,3:4],
               title=latexstring("\\mathrm{Cycle}~2"),
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_def_3=Axis(fig_def[2,1:2],
               title=latexstring("\\mathrm{Cycle}~3"),
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_def_4=Axis(fig_def[2,3:4],
               title=latexstring("\\mathrm{Cycle}~4"),
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )

strain_fct=map(s->parameters[s][25]*parameters[s][15]*parameters[s][16],eachindex(parameters));#*aux_parm.h;

# Cycle 1
map(s->lines!(ax_def_1, strain_fct[s]*(1:1:length(data[s][1].deform1_s)) ,data[s][2].XY[data[s][1].deform1_s]), (2,3,1) )

# Cycle 2
map(s->lines!(ax_def_2, strain_fct[s]*(1:1:length(data[s][1].deform2_s)) ,data[s][2].XY[data[s][1].deform2_s]), (2,3,1) )

# Cycle 3
map(s->lines!(ax_def_3, strain_fct[s]*(1:1:length(data[s][1].deform2_s)) ,data[s][2].XY[data[s][1].deform3_s]), (2,3,1) )

# Cycle 4
map(s->lines!(ax_def_4, strain_fct[s]*(1:1:length(data[s][1].deform4_s)) ,data[s][2].XY[data[s][1].deform4_s]), (2,3,1) )

# Legends
map(s->lines!(ax_leg,0,0,label=latexstring("\\dot{\\gamma}:~",data[s][3].shearRate,"~%\\mathrm{CL}:~",100*data[s][3].clCon)),(2,3,1))

Legend(fig_def[1:2,5],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )

# Compare each cycle with different shear rate
fig_rlx=Figure(size=(1920,1080));
ax_leg=Axis(fig_rlx[1:2,5],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_rlx_1=Axis(fig_rlx[1,1:2],
               title=latexstring("\\mathrm{Cycle}~1"),
               xlabel=L"\mathrm{Equivalent~Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_2=Axis(fig_rlx[1,3:4],
               title=latexstring("\\mathrm{Cycle}~2"),
               xlabel=L"\mathrm{Equivalent~Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_3=Axis(fig_rlx[2,1:2],
               title=latexstring("\\mathrm{Cycle}~3"),
               xlabel=L"\mathrm{Equivalent~Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_4=Axis(fig_rlx[2,3:4],
               title=latexstring("\\mathrm{Cycle}~4"),
               xlabel=L"\mathrm{Equivalent~Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )

strain_fct=map(s->parameters[s][25]*parameters[s][15]*parameters[s][16],eachindex(parameters));#*aux_parm.h;

# Cycle 1
map(s->lines!(ax_rlx_1, strain_fct[s]*(1:1:length(data[s][1].rlx1_s)) ,data[s][2].XY[data[s][1].rlx1_s]), (2,3,1) )

# Cycle 2
map(s->lines!(ax_rlx_2, strain_fct[s]*(1:1:length(data[s][1].rlx2_s)) ,data[s][2].XY[data[s][1].rlx2_s]), (2,3,1) )

# Cycle 3
map(s->lines!(ax_rlx_3, strain_fct[s]*(1:1:length(data[s][1].rlx3_s)) ,data[s][2].XY[data[s][1].rlx3_s]), (2,3,1) )

# Cycle 4
map(s->lines!(ax_rlx_4, strain_fct[s]*(1:1:length(data[s][1].rlx4_s)) ,data[s][2].XY[data[s][1].rlx4_s]), (2,3,1) )

# Legends
map(s->lines!(ax_leg,0,0,label=latexstring("\\dot{\\gamma}:~",data[s][3].shearRate,"~%\\mathrm{CL}:~",100*data[s][3].clCon)),(2,3,1))

Legend(fig_rlx[1:2,5],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )

#"""






#
