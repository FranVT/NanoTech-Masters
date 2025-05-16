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
id="2025-05-15-230326";
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


# Get the data from ALL shear simulations (N experiments) as an average
(system_shear,stress_shear,profile_shear)=extractInfoShear(path_shear,shear_dat,1);


#=
    A S S E M B L Y     P L O T S  
=#

# Time domains
time_system_assembly=assembly_dat."save-fix".*assembly_dat."time-step".*system_assembly."TimeStep";
time_shear_assembly=assembly_dat."time-step".*stress_assembly."TimeStep";


# Total energy, temperature, potential and kinetic energy
fig_system_assembly=plot_systemAssembly(time_system_assembly,system_assembly,"Assembly");

# Stress stuff
fig_stress_assembly=plot_stressAssembly(time_shear_assembly,stress_assembly)

#=
    S H E A R     P L O T S  
=#

# Time domain
time_system_shear=shear_dat."save-fix".*shear_dat."time-step".*system_shear."TimeStep"

# Strain domain

# Indixes for the shear moments
aux=shear_dat."time-step".*shear_dat."Shear-rate".*shear_dat."save-stress";
# Time steps per set of deformations
N_deform=shear_dat."Max-strain".*shear_dat."N_def";
# Time steps stored due to time average/Total of index per deformation cycle
ind_cycle=div.(N_deform,shear_dat."save-stress");

cycle=(1:1:ind_cycle[1]);


# Create strain and time domains
strain=aux[1].*cycle;


# Total energy, temperature, potential and kinetic energy
fig_system_shear=plot_systemShear(time_system_shear,system_shear,"Shear")

# Stress stuff

fig_stress_atom_shear=plot_stressShear(stress_shear."c_stress[1]",stress_shear."c_stress[2]",stress_shear."c_stress[3]",stress_shear."c_stress[4]",stress_shear."c_stress[5]",stress_shear."c_stress[6]",cycle,strain,"Stress~Atom")

fig_stress_atomVirial_shear=plot_stressShear(stress_shear."c_stressVirial[1]",stress_shear."c_stressVirial[2]",stress_shear."c_stressVirial[3]",stress_shear."c_stressVirial[4]",stress_shear."c_stressVirial[5]",stress_shear."c_stressVirial[6]",cycle,strain,"Stress~Virial~Atom")

fig_press_virial_shear=plot_stressShear(stress_shear."c_pressVirial[1]",stress_shear."c_pressVirial[2]",stress_shear."c_pressVirial[3]",stress_shear."c_pressVirial[4]",stress_shear."c_pressVirial[5]",stress_shear."c_pressVirial[6]",cycle,strain,"PRESSURE~Virial")


nothing
