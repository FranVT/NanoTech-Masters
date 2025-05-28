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

if doAssembly == 1 
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

if doShear == 1
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

#plotsAssembly(id,path_system,assembly_dat,system_assembly,stress_assembly)

#=
    S H E A R     P L O T S  
=#

#map(eachindex(path_shear)) do s
#    plotsShear(id,path_shear[s],assembly_dat."L"...,shear_dat[s],shear_info[s][1],shear_info[s][2]) 
#end

# Get inidivual plots of each shear rate
strain_stress=map(eachindex(path_shear)) do s
    plotStrain_Shear(id,path_shear[s],assembly_dat."L"...,shear_dat[s],shear_info[s][1],shear_info[s][2]) 
end

strain_stress=DataFrame(strain_stress);

fig_system=plot(
                layout = (1,1),
                suptitle = latexstring(string("\\mathrm{Comparison}")),
                plot_titlefontsize = 15,
                size=(1600,900),
                right_margin=10px,
                left_margin=30px,
                top_margin=10px,
                bottom_margin=15px
             )


fig_comp=plot(strain_stress.gamma,strain_stress.sxy,
              layout = (1,1),
              title =L"\sigma_{xy}",#latexstring(string("\\mathrm{Comparison}")),
                plot_titlefontsize = 15,
                size=(1600,900),
                right_margin=10px,
                left_margin=30px,
                top_margin=10px,
                bottom_margin=15px,
                labels = strain_stress.dgamma
               )


#plot!(labels=string.(1:10))
#map(s->plot!(fig_system,s[1]),strain_stress)
#annotate!(0.5, 0.95, text.(strain_stress.dgamma, 8), 
#          coords = :figure)

nothing

