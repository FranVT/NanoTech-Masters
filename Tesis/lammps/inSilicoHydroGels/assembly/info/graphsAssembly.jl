"""
    Script to create graphs of energy from dumpfile
"""

using GLMakie
include("funcsAssembly.jl")

workdir = cd("/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/assembly/")
filepwd = "info/"
filename = "energy_assembly.fixf";

info = getInfoEnergy(filepwd*filename);
fig = graphs(info)

