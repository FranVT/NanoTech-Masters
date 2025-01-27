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

selc_phi="5500";
selc_Npart="1000";
selc_damp="5000";
selc_T="500";
selc_cCL="300";
selc_ShearRate="1000";#string.((10,50,100));
selc_Nexp="2";

dirs=getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp);

files_names = (
               parm = "parameters",
               engAss = "energy_assembly.fixf",
               wcaAss = "wcaPair_assembly.fixf",
               patchAss = "patchPair_assembly.fixf",
               swapAss = "swapPair_assembly.fixf",
               lngAss = "langevinPot_assembly.fixf",
               stressAss = "stressVirial_assembly.fixf",
               cmdispAss = "cmdisplacement_assembly.fixf",
               engDef = "energy_shear.fixf",
               wcaDef = "wcaPair_shear.fixf",
               patchDef = "patchPair_shear.fixf",
               swapDef = "swapPair_shear.fixf",
               lngDef = "langevinPot_shear.fixf",
               stressDef = "stressVirial_shear.fixf",
               cmdispDef = "cmdisplacement_shear.fixf",
              );

file_dir=map(s->reduce(vcat,map(r->joinpath(r,"info",s),dirs)),files_names);

parameters = getParameters(dirs,files_names);

(inds,system)=getData(parameters,file_dir);

# Figures

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


