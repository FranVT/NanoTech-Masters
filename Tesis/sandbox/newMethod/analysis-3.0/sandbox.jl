"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
using Plots, LaTeXStrings, Plots.PlotMeasures
gr()

include("functions.jl")

#= 
    D I R E C T O R I E S   AND   P A T H S
=#

# Get the parent directory
parent_dir=dirname(pwd());
# Select the siimulation scheme (Version and stuff)
scheme_dir="bonds-3.0";
# Select the "system" by id
id="2025-05-20-100954";
# Select the system by "cross-linker" concentration
cl_con=0.5;


if !(@isdefined stress_assembly)
    # Path to the data directory of the simulation scheme
    path_data=joinpath(parent_dir,scheme_dir,"data");
    # Path to the data directory of the specific system
    path_system=joinpath(path_data,string("system-",id,"-CL-",cl_con));

    # Get data files of assembly (system)
    assembly_dat=getDataFiles(path_system,"dataAssembly.dat");

    # Get the data from assembly simulation
    (system_assembly,stress_assembly,clust_assembly,profile_assembly)=extractInfoAssembly(path_system,assembly_dat);

    println("Assembly information loaded")
end

if !(@isdefined shear_info)
    # Path to ALL shear directories
    aux=readdir(path_system);
    path_shear=joinpath.(path_system,aux[findall(s->s==1,occursin.("shear",aux))]);

    # Get data files of each shear
    shear_dat=map(s->getDataFiles(s,"dataShear.dat"),path_shear);

    # Get the data from ALL shear simulations (N experiments) as an average
    shear_info=map(eachindex(path_shear)) do s
        (system_shear,stress_shear)=extractInfoShear(path_shear[s],shear_dat[s]);
    end

    println("Shear information loaded")
end


#=
    A S S E M B L Y     P L O T S  
=#

#plotsAssembly(id,pwd(),assembly_dat,system_assembly,stress_assembly)

#=
    S H E A R     P L O T S  
=#


(fig_system_shear,fig_stress_atom_shear,fig_pressure_shear,fig_comp_stress_press)=plotsShear(id,pwd(),shear_dat[1],shear_info[1][1],shear_info[1][2]) 

nothing

#=



nothing

=#
