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
id="2025-05-08-144955";
# Select the system by "cross-linker" concentration
cl_con=0.5;


# Path to the data directory of the simulation scheme
path_data=joinpath(parent_dir,scheme_dir,"data");
# Path to the data directory of the specific system
path_system=joinpath(path_data,string("system-",id,"-CL-",cl_con));

# Get data files of assembly (system)
assembly_dat=getDataFiles(path_system,"dataAssembly.dat");

# Path to the shear directory
aux=readdir(path_system);
path_shear=joinpath(path_system,aux[findall(s->s==1,occursin.("shear",aux))]...);

# Get data files of shear
shear_dat=getDataFiles(path_shear,"dataShear.dat");


# Get the data from assembly simulation
(system_assembly,stress_assembly,clust_assembly,profile_assembly)=extractInfoAssembly(path_system,assembly_dat);


# Get the data from ALL shear simulations (N experiments)
(system_shear,stress_shear,clust_shear,profile_shear)=extractInfoShear(path_shear,shear_dat);


#=
    A S S E M B L Y     P L O T S  
=#

# Time domains
time_assembly=assembly_dat."time-step".*system_assembly."TimeStep";
time_assembly_stress=assembly_dat."time-step".*system_shear."TimeStep";

# Total Energy
p1 = plot(
            title=L"\mathrm{Total~Energy}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"'J'",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_assembly,df_stressA.p,label=L"\mathrm{Assembly}")
#plot!(time_shear_pressure,df_stressS.p,label=L"\mathrm{Shear}")



# Combo of all previous plots
fig_system_assembly=plot(p1,p2,p3,p4,
                layout = (2,2),
                suptitle = L"\mathrm{Assembly}",
                plot_titlefontsize = 15,
                size=(1600,900)
             )




# Total energy, temperature, potential and kinetic energy





