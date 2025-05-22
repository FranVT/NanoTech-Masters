"""
    General julia script to create figures and the pdfs
"""

using DataFrames, CSV
using Plots, LaTeXStrings, Plots.PlotMeasures
gr()

include("functions.jl")

#= 
    D I R E C T O R I E S   A N D   P A T H S
=#

# Get the parent directory
parent_dir=dirname(pwd());
# Select the siimulation scheme (Version and stuff)
scheme_dir="bonds-3.0";
# Select the "system" by id
id="2025-05-15-230326";
# Select the system by "cross-linker" concentration
cl_con=0.5;
# Full system
system=string("system-",id,"-CL-",cl_con);


"""
    Get general paths
"""
# Path to the data directory of the simulation scheme
path_data=joinpath(parent_dir,scheme_dir,"data");
# Path to the data directory of the specific system
path_system=joinpath(path_data,system);
# Path to the LaTeX set-up
path_reports=joinpath(path_data,"report");

""""
    Get assembly info
"""
# Get data files of assembly (system)
assembly_dat=getDataFiles(path_system,"dataAssembly.dat");


"""
    Get shear paths and info
"""
# Path to ALL shear directories
aux=readdir(path_system);
path_shear=joinpath.(path_system,aux[findall(s->s==1,occursin.("shear",aux))]);

# Get data files of each shear
shear_dat=map(s->getDataFiles(s,"dataShear.dat"),path_shear);





# Create the pdf
run(`bash sandbox.sh $id $system $path_system $path_reports dataAssembly.dat`)


