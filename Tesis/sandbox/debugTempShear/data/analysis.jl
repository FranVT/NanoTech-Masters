"""
    Script to analyse the data from experiment
"""

using FileIO
using GLMakie
using LaTeXStrings
using Statistics

# Add functions to acces infromation from files
include("functions.jl")

"""
    Select the desire systems to analyse
"""

selc_phi="5000";
selc_Npart="100";
selc_damp="5000";
selc_T="500";
selc_cCL="1000";
selc_ShearRate="100";#string.((10,50,100));
selc_Nexp="1";

dirs=getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp);

files_names = (
               parm = "parameters",
               engAss = "energy_assembly.fixf",
               wcaAss = "wcaPair_assembly.fixf",
               patchAss = "patchPair_assembly.fixf",
               swapAss = "swapPair_assembly.fixf",
               stressAss = "stressVirial_assembly.fixf",
               cmdispAss = "cmdisplacement_assembly.fixf",
               engDef = "energy_shear.fixf",
               wcaDef = "wcaPair_shear.fixf",
               patchDef = "patchPair_shear.fixf",
               swapDef = "swapPair_shear.fixf",
               stressDef = "stressVirial_shear.fixf",
               cmdispDef = "cmdisplacement_shear.fixf",
              );

file_dir=map(s->reduce(vcat,map(r->joinpath(r,"info",s),dirs)),files_names);

parameters = getParameters(dirs,files_names);

(inds,system)=getData(parameters,file_dir);

# Figures

"""
energy Log 10
"""

fig_energy_log=Figure(size=(1920,1080));
ax_leg=Axis(fig_energy_log[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig_energy_log[1,1:2],
               title=L"\mathrm{Total~Energy~of~the~simulation}",
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
ax_assembly=Axis(fig_energy_log[2,1],
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
ax_shear=Axis(fig_energy_log[2,2],
               title=L"\mathrm{Total~Energy~of~Shear~simulation}",
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
lines!(ax_total,system.energy)
lines!(ax_assembly,system.energy[inds.assembly])
lines!(ax_shear,system.energy[inds.shear])

save(joinpath(dirs[1],"imgs","fig_energyLog.png"),fig_energy_log)

"""
energy
"""

fig_energy=Figure(size=(1920,1080));
ax_leg=Axis(fig_energy[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig_energy[1,1:2],
               title=L"\mathrm{Total~Energy~of~the~simulation}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig_energy[2,1],
               title=L"\mathrm{Total~Energy~of~Assembly~simulation}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig_energy[2,2],
               title=L"\mathrm{Total~Energy~of~Shear~simulation}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.energy)
lines!(ax_assembly,system.energy[inds.assembly])
lines!(ax_shear,system.energy[inds.shear])

save(joinpath(dirs[1],"imgs","fig_energy.png"),fig_energy)

"""
temperature
"""

fig_temp=Figure(size=(1920,1080));
ax_leg=Axis(fig_temp[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig_temp[1,1:2],
               title=L"\mathrm{Temperature~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Temperature}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig_temp[2,1],
               title=L"\mathrm{Temperature~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Temperature}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig_temp[2,2],
               title=L"\mathrm{Temperature~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Temperature}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.temp)
lines!(ax_total,inds.shear,system.tmp_df)
lines!(ax_assembly,system.temp[inds.assembly])
lines!(ax_shear,system.temp[inds.shear])
lines!(ax_shear,system.tmp_df)



save(joinpath(dirs[1],"imgs","fig_temperature.png"),fig_temp)

"""
Pressure
"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\mathrm{Pressure~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Pressure}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{Pressure~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Pressure}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{Pressure~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Pressure}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.p)
lines!(ax_assembly,system.p[inds.assembly])
lines!(ax_shear,system.p[inds.shear])

save(joinpath(dirs[1],"imgs","fig_pressure.png"),fig)

"""
Potential energy
"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\mathrm{Potential~energy~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{Potential~energy~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{Potential~energy~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.ep)
lines!(ax_assembly,system.ep[inds.assembly])
lines!(ax_shear,system.ep[inds.shear])

save(joinpath(dirs[1],"imgs","fig_potential.png"),fig)

"""
Kinetic energy
"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\mathrm{Kinetic~energy~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{Kinetic~energy~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{Kinetic~energy~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.ek)
lines!(ax_assembly,system.ek[inds.assembly])
lines!(ax_shear,system.ek[inds.shear])

save(joinpath(dirs[1],"imgs","fig_kinetic.png"),fig)

"""
ecouple and econserve
"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\mathrm{Energy~couple~and~conserve~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{Energy~couple~and~conserve~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{Energy~couple~and~conserve~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.ecple,label=L"\mathrm{ecouple}")
lines!(ax_total,system.ecrve,label=L"\mathrm{econserve}")

axislegend(ax_total)

lines!(ax_assembly,system.ecple[inds.assembly])
lines!(ax_assembly,system.ecrve[inds.assembly])

lines!(ax_shear,system.ecple[inds.shear])
lines!(ax_shear,system.ecrve[inds.shear])

save(joinpath(dirs[1],"imgs","fig_ecpleANDcrve.png"),fig)

"""
Pair potentials
"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\mathrm{Pair~potentials~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{Pair~potentials~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{Pair~potentials~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.wca,label=L"\mathrm{WCA}")
lines!(ax_total,system.patch,label=L"\mathrm{Patch}")
lines!(ax_total,system.swap,label=L"\mathrm{Swap}")

axislegend(ax_total)

lines!(ax_assembly,system.wca[inds.assembly])
lines!(ax_assembly,system.patch[inds.assembly])
lines!(ax_assembly,system.swap[inds.assembly])

lines!(ax_shear,system.wca[inds.shear])
lines!(ax_shear,system.patch[inds.shear])
lines!(ax_shear,system.swap[inds.shear])

save(joinpath(dirs[1],"imgs","fig_pairPotentials.png"),fig)

"""
Pressure cumpted using the stess
"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\mathrm{Pressure~(Stress)~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Pressure}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{Pressure~(Stress)~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Pressure}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{Pressure~(Stress)~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{Pressure}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.presss)
lines!(ax_assembly,system.presss[inds.assemblys])
lines!(ax_shear,system.presss[inds.shears])

save(joinpath(dirs[1],"imgs","fig_pressure-stress.png"),fig)

"""
Stress
"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\mathrm{Stress~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{Stress~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{Stress~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system.stress)
lines!(ax_assembly,system.stress[inds.assemblys])
lines!(ax_shear,system.stress[inds.shears])

save(joinpath(dirs[1],"imgs","fig_stress.png"),fig)

"""
Stress XY
"""
fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\sigma_{xy}\mathrm{~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\sigma_{xy}\mathrm{~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\sigma_{xy}\mathrm{~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,-system.sig_XY)
lines!(ax_assembly,-system.sig_XY[inds.assemblys])
lines!(ax_shear,-system.sig_XY[inds.shears])

save(joinpath(dirs[1],"imgs","fig_stress-xy.png"),fig)

"""
stress XY relax and deformation periods
"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\sigma_{xy}\mathrm{~of~the~system}",
               xlabel=L"\mathrm{Time~units~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{Deformation~periods}",
               xlabel=L"\mathrm{Strain~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{Relaxation~periods}",
               xlabel=L"\mathrm{Time~units~}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,(parameters.dt*parameters.save_s).*eachindex(inds.shears),-system.sig_XY[inds.shears])
vlines!(ax_total,(parameters.dt*parameters.save_s)*(last(inds.def1s)-last(inds.assemblys)),linestyle=:dash)
vlines!(ax_total,(parameters.dt*parameters.save_s)*(last(inds.def2s)-last(inds.assemblys)),linestyle=:dash)
vlines!(ax_total,(parameters.dt*parameters.save_s)*(last(inds.def3s)-last(inds.assemblys)),linestyle=:dash)

lines!(ax_assembly,(parameters.dt*parameters.sh_rt*parameters.save_s).*(inds.def1s .- first(inds.def1s)),-system.sig_XY[inds.def1s])
lines!(ax_assembly,(parameters.dt*parameters.sh_rt*parameters.save_s).*(inds.def2s .- (first(inds.def1s)+div(parameters.N_rlx1,parameters.save_s))),-system.sig_XY[inds.def2s])
lines!(ax_assembly,(parameters.dt*parameters.sh_rt*parameters.save_s).*(inds.def3s .- (first(inds.def1s)+2*div(parameters.N_rlx1,parameters.save_s))),-system.sig_XY[inds.def3s])

lines!(ax_shear,(parameters.dt*parameters.save_s).*eachindex(inds.rlx1s),-system.sig_XY[inds.rlx1s])
lines!(ax_shear,(parameters.dt*parameters.save_s).*eachindex(inds.rlx2s),-system.sig_XY[inds.rlx2s])
lines!(ax_shear,(parameters.dt*parameters.save_s).*eachindex(inds.rlx3s),-system.sig_XY[inds.rlx3s])

save(joinpath(dirs[1],"imgs","fig_stress-xy-periods.png"),fig)


