"""
    Homework # 1: A gas in a Lennard-Jones box
    Assigment dat: February , 2024

    Simulate a 2D gas ina box.
    100 particles should interact with each other through a Lennard-Jones potential.
    They should be confined by four walls, also modeled as a Lennard-Jones potentials, forming a box side of 20 sigma.
    Initial temerature: 2 epsilon/kb

    Important considerations:
    All particles have same mass.
    All particles have same size.
    Almost all physical values will have unit value. Temperature and particle size can be change.
"""

# Packages
using Pkg; Pkg.activate(@__DIR__)
Pkg.instantiate(); Pkg.precompile()
using Random, Distributions, StatsBase
using JLD, FileIO
using Plots, LaTeXStrings

# Set seed, include physical parameters and functions.
Random.seed!(1234);
include("parameters.jl")
include("functions.jl")

# Compute the temporal evolution of the system
@time begin
    VelocityVerlet()    
end

# Backend for graphics
gr()

# Functions for graphics
function temPlot(x,y)
    """
        Plot the temperature
    """
    plot(x,y,
        xlabel = L"t",
        ylabel = L"T(t)",
        label = false,
        size = (480,480),
        #aspect_ratio = 3/4,
        title = L"\mathrm{Temperature}"
    )
end

function posPlot(x,y,T,it)
    """
        Plot the position for the animation
    """
    scatter(x,y,
            title = string(
                    L"\mathrm{Nt} = ",latexstring("$(it)"),
                    L",~~~\mathrm{T:}~",latexstring("$(round(T,digits=6))"),L"~[\mathrm{K}]"
                    ),
            titlelocation = :left,
            titlefontsize = 12,
            markersize = 10*sigmaP,
            tickfontsize = 8,
            xlims = (-wx1/sigmaP,wx1/sigmaP),
            ylims = (-wy1/sigmaP,wy1/sigmaP),
            xlabel = L"x/σ",
            ylabel = L"y/σ",
            label = false,
            size = (480,480),
            aspect_ratio = 1,
            formatter = :plain,
            minorgrid = true,
            minorgridalpha = 0.5,
            labelfontsize = 13,
            framestyle = :box
        )
end


# Retrieved the data for graphics
kinen = load( string(auxDir,"\\kineticEnergy.jld"),"vK" );
kinem = load( string(auxDir,"\\kinetimEnergy.jld"),"vKm" );
poten = load( string(auxDir,"\\potentiEnergy.jld"),"vP" );

# Compute the temperaute
vT = (1/3)*(cumsum(kinem)./collect(1:length(kinen)));

# Plot the temperature
tempPlot = temPlot(collect(0:dt:tf),vT)

# Save the Temperatur plot
savefig(tempPlot,"100TempPlot.pdf")

# Plot Initial position
info = load( string(auxDir,"\\part_r_",1,".jld"),"vR" )./sigmaP
inPos = posPlot(info[1,:],info[2,:],vT[1],1)

# Save the initial position plot
savefig(inPos,"100IniPos.pdf")

# Plot trayectories
# Array preparation
idAux = collect(2:2:Nt);
auxPos = zeros(2,length(idAux),Np);

# Gather the information
@time begin
    for it = 1:1:length(idAux)
        info = load( string(auxDir,"\\part_r_",idAux[it],".jld"),"vR" )./sigmaP;
        map(p->auxPos[:,it,p]= info[:,p],collect(1:1:Np));
    end  
end

# Create the plot
info = load( string(auxDir,"\\part_r_",1,".jld"),"vR" )./sigmaP;
plot10Part = posPlot(info[1,:],info[2,:],vT[1],1)
plot!( auxPos[1,:,:],auxPos[2,:,:], label = false )

# SAve the plot
savefig(plot10Part,"10PartPosition.pdf")


# Create the animation
@time begin
    anim = @animate for it ∈ 2:4:Nt
        info = load( string(auxDir,"\\part_r_",it,".jld"),"vR" )./sigmaP
        posPlot(info[1,:],info[2,:],vT[it],it)
    end
    gif(anim,"gif100_Hw.gif",fps=24)
end

