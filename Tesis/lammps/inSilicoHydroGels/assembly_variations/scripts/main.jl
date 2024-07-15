"""
    Script to generate a set of input scripts.
"""

include("functions.jl")

## Parameters for the simulation
L_box = 10;
N_CL = 50;
N_MO = 450;

# Auxiliar variable for the if
changes = 0;

if changes != 0
    ## If necesary, create the tables and molecules files
    Create_Swapfile()
    Create_PatchTablefile()
    Create_Swaptable()
end

## Create the in.assembly.lmp file
Create_Infile(L_box,N_CL,N_MO)

