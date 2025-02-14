"""
    Homework # 1: A gas in a Lennard-Jones box
    Assigment dat: February , 2024

    Simulate a 2D gas ina box.
    100 particles should interact with each other through a Lennard-Jones potential.
    They should be confined by four walls, also modeled as a Lennard-Jones potentials, forming a box side of 20 sigma.
    Initial temerature: 2 epsilon/kb

    Simplify stuff:
    All particles have same mass.
    All particles have same size.
    For now, the epsilon parameter of particles and walls is the same.
"""

# Packages 
using LinearAlgebra
using Random, Distributions
using StatsBase
using JLD, FileIO
using Plots, LaTeXStrings

# Ñam
Random.seed!(1234);
include("functions.jl")
include("parametersANDstuff.jl")

# Compute the simulation
@time begin
    VelocityVerlet()    
end


gr()

@time begin
function posPlot(x,y,it)
    scatter( x,y,
            markersize = 1.5,
            xlims = (-wx1/sigmaP,wx1/sigmaP),
            ylims = (-wy1/sigmaP,wy1/sigmaP),
            #title = "Position of particles",
            xlabel = L"x/σ",
            ylabel = L"y/σ",
            label = false,
            size = (480,480),
            aspect_ratio = 1,
            annotate = [(-9,9,(string(L"t = ",latexstring("$(it)"),L"~μ\mathrm{s}"),10,:left,:black))]
        )
end

anim = @animate for it ∈ 2:4:3010
    info = load( string(auxDir,"\\part_r_",it,".jld"),"vR" )./sigmaP
    posPlot(info[1,:],info[2,:],it)
end
gif(anim,"gif100_Hw_2.gif",fps=60)
end

kinen = load( string(auxDir,"\\kineticEnergy.jld"),"vK" );
kinem = load( string(auxDir,"\\kinetimEnergy.jld"),"vKm" );

poten = load( string(auxDir,"\\potentiEnergy.jld"),"vP" );

plot(0.5*m*kinen)

plot(0.5*m*kinem)

plot( 0.5*m*kinen + poten )



info = load( string(auxDir,"\\part_r_",1002,".jld"),"vR" )
scatter!( info[1,:]./sigmaP,info[2,:]./sigmaP,markersize=2.5 )



# Graphics
info = load( string(auxDir,"\\part_r_",1,".jld"),"vR" )./sigmaP
grafP = scatter( info[1,:],info[2,:],
            markersize = 1.5,
            xlims = (-wx1/sigmaP,wx1/sigmaP),
            ylims = (-wy1/sigmaP,wy1/sigmaP),
            #title = "Position of particles",
            xlabel = L"x/σ",
            ylabel = L"y/σ",
            label = false,
            size = (480,480),
            aspect_ratio = 1,
            annotate = [(-9,9,(string(L"t = ",latexstring("$(dt*1)"),L"~\mathrm{s}"),10,:left,:black))]
        )

