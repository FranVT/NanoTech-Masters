"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
#using Plots, LaTeXStrings, Plots.PlotMeasures
#gr()
using Statistics
using GLMakie, LaTeXStrings

# Functions to get the data and norm and trace
include("functions_data.jl")
# Functions to graph
include("functions_graphs.jl")


#= 
    D I R E C T O R I E S   AND   P A T H S
=#

dir_home=0;

# Directory to the stored data 
if dir_home == 0
    parent_dir=dirname(pwd());
elseif dir_home == 1
    parent_dir="/run/media/franpad/rogelio/NanoTech-Masters/cluster/";
elseif dir_home == 2
    parent_dir="/run/media/franpad/rogelio/NanoTech-Masters/minipc/";
else
    println("No parent directory")
    exit()
end

# Select the siimulation scheme (Version and stuff)
scheme_dir="tries";
# Select the "system" by id
id="2025-06-21-135024";
# Select the system by "cross-linker" concentration
cl_con=0.5;

# Extract the info or go directly to the graphs
doAssembly=1;
do_save=1;

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

#plotTimeAssSystem(domain,range,assembly_dat,shear_dat,title,subtitle,ylbl)
l_t=div(assembly_dat."N_heat".+assembly_dat."N_isot"...,assembly_dat."save-fix"...);
l_o=1;#div(assembly_dat."N_heat"...,assembly_dat."save-fix"...);

domain=system_assembly."TimeStep"[l_o:end].*assembly_dat."time-step";
range=system_assembly."c_t"[l_o:end];
fig_temp_as=plotTimeAssSystem(domain,range,assembly_dat,"\\mathrm{Time~vs~Temperature}","\\mathrm{Assembly}","\\mathrm{Temp}")

domain=system_assembly."TimeStep"[l_o:end].*assembly_dat."time-step";
range=system_assembly."v_eT"[l_o:end];
fig_eng_as=plotTimeAssSystem(domain,range,assembly_dat,"\\mathrm{Time~vs~Total~energy}","\\mathrm{Assembly}","\\mathrm{Energy}")

domain=system_assembly."TimeStep"[l_o:end].*assembly_dat."time-step";
range=system_assembly."c_ep"[l_o:end];
fig_engPot_as=plotTimeAssSystem(domain,range,assembly_dat,"\\mathrm{Time~vs~Potential~energy}","\\mathrm{Assembly}","\\mathrm{Energy}")

domain=system_assembly."TimeStep"[l_o:end].*assembly_dat."time-step";
range=system_assembly."c_ek"[l_o:end];
fig_engKin_as=plotTimeAssSystem(domain,range,assembly_dat,"\\mathrm{Time~vs~Kinetic~energy}","\\mathrm{Assembly}","\\mathrm{Energy}")


domain=system_assembly."TimeStep"[l_o:end].*assembly_dat."time-step";
range1=system_assembly."c_wcaPair"[l_o:end];
range2=system_assembly."c_patchPair"[l_o:end];
range3=system_assembly."c_swapPair"[l_o:end];
fig_engPots_as=plotTimeAssPotential(domain,range1,range2,range3,assembly_dat,"\\mathrm{Time~vs~Potential~energies}","\\mathrm{Assembly}","\\mathrm{Energy}")




if do_save == 1
     save(joinpath(path_system,"Time-vs-Temp-assembly.png"),fig_temp_as)
    save(joinpath(path_system,"Time-vs-Totalenergy-assembly.png"),fig_eng_as)
    save(joinpath(path_system,"Time-vs-Potential-assembly.png"),fig_engPots_as)
#    save(joinpath(path_system,"Time-vs-Swap-shear.png"),fig_swap)
#    save(joinpath(path_system,"Time-vs-Pot-shear.png"),fig_pot)
    println("Figures saved")
   
end

#=
    A S S E M B L Y     P L O T S  
=#

#plotsAssembly(id,path_system,assembly_dat,system_assembly,stress_assembly)

#=
    S H E A R     P L O T S  



# Same plot/graph
comp_temp=plotSystem(systemShear.timeShear,systemShear.temp,systemShear.dgamma,"Temperature")

comp_ep=plotSystem(systemShear.timeShear,systemShear.ep,systemShear.dgamma,"Total potential energy")

comp_ek=plotSystem(systemShear.timeShear,systemShear.ek,systemShear.dgamma,"Total Kinetic energy")

# Stress

#Plots.default(palette = :navia10)

comp_sgxy=plotStrain_Shear(systemShear.strain,systemShear.sigXY,systemShear.dgamma,"xy-Stress component",assembly_dat,shear_dat)

comp_sg=plotStrain_Shear(systemShear.strain,systemShear.sigNorm,systemShear.dgamma," Norm of Stress",assembly_dat,shear_dat)

comp_sgvirxy=plotStrain_Shear(systemShear.strain,systemShear.sigVirXY,systemShear.dgamma,"xy-Virial Stress component",assembly_dat,shear_dat)
=#

nothing

