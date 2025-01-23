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
selc_Npart="1500";
selc_damp="5000";
selc_T="500";
selc_cCL="300";
selc_ShearRate=10;#string.((10,50,100));
selc_Nexp=string.(1:15);

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

file_dir=joinpath(first(dirs),first(files_names));
parameters=open(file_dir) do f
    map(s->parse(Float64,s),readlines(f))
end


