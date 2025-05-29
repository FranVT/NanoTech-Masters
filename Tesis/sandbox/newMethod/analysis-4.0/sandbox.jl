"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
using Plots, LaTeXStrings, Plots.PlotMeasures
gr()

# Functions to get the data and norm and trace
include("functions_data.jl")
# Functions to graph
include("functions_graphs.jl")


#= 
    D I R E C T O R I E S   AND   P A T H S
=#

# Get the parent directory
parent_dir=dirname(pwd());
# Select the siimulation scheme (Version and stuff)
scheme_dir="aux-cluster";
# Select the "system" by id
id="2025-05-09-134206";
# Select the system by "cross-linker" concentration
cl_con=0.03;

# Extract the info or go directly to the graphs
doAssembly=0;
doShear=0;

# Path to the data directory of the simulation scheme
path_data=joinpath(parent_dir,scheme_dir,"data");
# Path to the data directory of the specific system
path_system=joinpath(path_data,string("system-",id,"-CL-",cl_con));

# Get data files of assembly (system)
assembly_dat=getDataFiles(path_system,"dataAssembly.dat");



if doAssembly == 1 
    # Get the data from assembly simulation
    (system_assembly,stress_assembly,clust_assembly,profile_assembly)=extractInfoAssembly(path_system,assembly_dat);

    println("Assembly information loaded")
end

if doShear == 1
    # Path to ALL shear directories
    aux=readdir(path_system);
    path_shear=joinpath.(path_system,aux[findall(s->s==1,occursin.("shear",aux))]);

    # Get data files of each shear
    shear_dat=map(s->getDataFiles(s,"dataShear.dat"),path_shear);

    # Get the data from ALL shear simulations (N experiments) as an average
    systemShear=shearData(path_shear,shear_dat);

    println("Shear information loaded")
end


#=
    A S S E M B L Y     P L O T S  
=#

#plotsAssembly(id,path_system,assembly_dat,system_assembly,stress_assembly)

#=
    S H E A R     P L O T S  
=#


# Same plot/graph
comp_temp=plotSystem(systemShear.strain,systemShear.temp,systemShear.dgamma,"Temperature")

comp_ep=plotSystem(systemShear.strain,systemShear.ep,systemShear.dgamma,"Total potential energy")

comp_ek=plotSystem(systemShear.strain,systemShear.ek,systemShear.dgamma,"Total Kinetic energy")

# Stress

Plots.default(palette = :tab10)

comp_sgxy=plotStrain_Shear(systemShear.strain,systemShear.sigXY,systemShear.dgamma,"xy-Stress component")

comp_sg=plotStrain_Shear(systemShear.strain,systemShear.sigNorm,systemShear.dgamma," Norm of Stress")

comp_sgvirxy=plotStrain_Shear(systemShear.strain,systemShear.sigVirXY,systemShear.dgamma,"xy-Virial Stress component",assembly_dat,shear_dat)






nothing

