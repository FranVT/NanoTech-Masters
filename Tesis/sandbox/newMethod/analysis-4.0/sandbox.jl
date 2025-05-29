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
doShear=1;

# Path to the data directory of the simulation scheme
path_data=joinpath(parent_dir,scheme_dir,"data");
# Path to the data directory of the specific system
path_system=joinpath(path_data,string("system-",id,"-CL-",cl_con));

if doAssembly == 1 
    # Get data files of assembly (system)
    assembly_dat=getDataFiles(path_system,"dataAssembly.dat");

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
time_system=map(eachindex(path_shear)) do s
    Time_System(shear_dat[s],shear_info[s][1]) 
end

time_system=DataFrame(time_system);

# Same plot/graph
comp_temp=plotSystem(time_system.gamma,time_system.temp,time_system.dgamma,"Temperature")

comp_ep=plotSystem(time_system.gamma,time_system.ep,time_system.dgamma,"Total potential energy")

comp_ek=plotSystem(time_system.gamma,time_system.ek,time_system.dgamma,"Total Kinetic energy")

# Stress

# Get inidivual plots of each shear rate
strain_stress=map(eachindex(path_shear)) do s
    Strain_Shear(assembly_dat."L"...,shear_dat[s],shear_info[s][1],shear_info[s][2]) 
end

strain_stress=DataFrame(strain_stress);

Plots.default(palette = :tab10)

comp_sgxy=plotStrain_Shear(strain_stress.gamma,strain_stress.sxy,strain_stress.dgamma,"xy-Stress component")

comp_sg=plotStrain_Shear(strain_stress.gamma,strain_stress.snorm,strain_stress.dgamma," Norm of Stress")

comp_sgvirxy=plotStrain_Shear(strain_stress.gamma,strain_stress.svirxy,strain_stress.dgamma,"xy-Virial Stress component")

=#

comp_sgxy=plotStrain_Shear(systemShear.strain,systemShear.sigXY,systemShear.dgamma,"xy-Stress component")




nothing

