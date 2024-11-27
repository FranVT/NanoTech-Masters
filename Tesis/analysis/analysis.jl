"""
   Statistical analysisi and graph
"""

using FileIO
using GLMakie
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
selc_ShearRate="100";
selc_Nexp=string.(1:15);

dirs=getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp);


