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

# Ñam
Random.seed!(1234);

#include("auxFunc.jl")
#include("auxBounCond.jl")
#include("auxVelVerlet.jl")

# functions
# Lennar-Jones Force
function LennardJonesForce(np,pRef,pos,ϵ,σ,rexp,aexp)
    # Array preparation
    nPart = collect(1:np)
    part = deleteat!(nPart,findall(x->x==pRef,nPart))
    # Compute the difference
    dif = sum(reduce(hcat, map( s-> pos[:,pRef] - pos[:,s], part) ),dims=2)
    # Compute radius and angle
    r = sqrt(sum(dif.^2));      ang = atan(dif[2],dif[1]);
    # Compute the force
    LFf = (4*ϵ/r)*(rexp*(σ/r)^rexp - aexp*(σ/r)^aexp);
    # Get x and y components of the force
    LJfx = LFf*cos(ang);        
    LJFy = LFf*sin(ang);

    return [LJfx; LJFy]
end

# boundary conditions
function LennardJonesBoundCond(np,wx,wy,pos,ϵ,σ,rexp,aexp)
    # Array preparation
    nPart = collect(1:np)
    # Compute the difference in x 
    dif = reduce(hcat, map( s-> pos[1,s] - wx, nPart) )
    # Compute the force in x
    LFfx = ((4*ϵ)./dif).*(rexp.*((σ)./dif).^rexp .- aexp.*((σ)./dif).^aexp)
    # Compute the difference in x 
    dif = reduce(hcat, map( s-> pos[2,s] - wy, nPart) )
    # Compute the force in x
    LFfy = ((4*ϵ)./dif).*(rexp.*((σ)./dif).^rexp .- aexp.*((σ)./dif).^aexp)

    return [LFfx; LFfy]
end


# Physical parameters
"""
    Kb:         Boltzman constant           [J/K]
    m:          Mass                        [Kg]
    T:          Temperature                 [K]
    sigmaP:     Particle size               [m]
    sigmaW:     Wall size                   [m]
    epsP:       Innerparticle energy        [J]
    epsW:       Wall energy                 [J]
    reip:       Repulsive eponent for Innerparticle potential
    aeip:       Attractive eponent for Innerparticle potential
    rew:        Repulsive eponent for Wall potential
    aew:        Attractive eponent for Wall potential
"""
kB = 1.380649*10^(-23);
m = 5e-20;     # 10^-23 aprox 10 000 atomic mass unit
sigmaP = 100e-6;
sigmaW = 1*sigmaP;
epsP = 200*kB;
epsW = epsP;
reip = 12;
aeip = 6;
rew = 20;
aew = 1;
T = 2*epsP/kB;     # 20 °C

# System parameters
"""
    ti:         Initial time                [s]
    tf:         Final time                  [s]
    dt:         Time diferential            [s]
    Np:         Number of particles         []
    wx:         Coordinates of the wall     [m]
    wy:         Coordinates of the wall     [m]
"""
ti = 0;
tf = 10e-4;
dt = 1e-6;
Np  = 10;
wx1 = 10*sigmaP;
wx2 = -wx1;
wy1 = 10*sigmaP;
wy2 = -wy1;
auxw = [wx1,wx2]; auxwy = [wy1,wy2];

# Simulation parameters
"""
    Nt:         Temporal nodes
    vR:         Position array for Np particles for a 3 dimensional cartisian coordinates
    vV:         Velocity array for Np particles for a 3 dimensional cartisian coordinates
    aux:        Array for store the velocity auxiliar of the numerical Method
    vK:         Kinetic energy vector
"""
Nt = Int(div(tf-ti,dt,RoundUp)) + 1
vR = zeros(2,Np);
vV = zeros(2,Np);
aux = zeros(2,Np);
vK = zeros(Nt);

# Initial Conditions
"""
    For radial initial position
"""
auxTh = sample(0:2*pi/(Np):2*pi,Np, replace = false)
vR[1,:] = wx1.*sample(0.25:0.01:0.75, Np, replace = false).*cos.(auxTh);
vR[2,:] = wx1.*sample(0.25:0.01:0.75, Np, replace = false).*sin.(auxTh);

"""
    Initial velocities using probability distribution of Boltzmann:
    Maxwell – Boltzmann distribution for molecular velocity components
    P(v) = sqrt( m/(2*pi*kB*T) )*exp( -m/(2*kB*T)v^2 )
    mean(vx) = 0
    sigma = sqrt(kB T/m)
"""
vV[1,:] = rand( Normal(0,sqrt(kB*T/m)),Np );
vV[2,:] = rand( Normal(0,sqrt(kB*T/m)),Np );

auxDir = joinpath(@__DIR__,"data");

for it = 1:Nt
    # Get the force for all particles
    Fp = reduce(hcat,map( s-> LennardJonesForce(Np,s,vR,epsP,sigmaP,reip,aeip), collect(1:1:Np)))
    # Get force due to Boundary condition for all particles
    Fbc = LennardJonesBoundCond(Np,wx1,wy1,vR,epsW,sigmaW,rew,aew) .+ LennardJonesBoundCond(Np,wx2,wy2,vR,epsW,sigmaW,rew,aew)
    # Total force and Acceleration 
    ac = (1/m)*(Fp .+ Fbc);
    # Get v*
    aux[:,:] = reduce(hcat,map(s->vV[:,s] + (dt/2)*(ac[:,s]) ,collect(1:1:Np)));
    # Get position
    vR = reduce(hcat,map(s->vR[:,s] + dt*aux[:,s] ,collect(1:1:Np)));
    # Get the force for all particles
    Fp = reduce(hcat,map( s-> LennardJonesForce(Np,s,vR,epsP,sigmaP,reip,aeip), collect(1:1:Np)))
    # Get force due to Boundary condition for all particles
    Fbc = LennardJonesBoundCond(Np,wx1,wy1,vR,epsW,sigmaW,rew,aew) .+ LennardJonesBoundCond(Np,wx2,wy2,vR,epsW,sigmaW,rew,aew)
    # Total force and Acceleration 
    ac = (1/m)*(Fp .+ Fbc);
    # Get velocity
    vV = reduce(hcat,map(s->aux[:,s] + (dt/2)*(ac[:,s]) ,collect(1:1:Np)));
    # Compute mean of Kinetic energy 
    vK[it] = mean(sum(vV.^2,dims=1));
    # Save the array of position
    if it%2 == 0; save(File(format"JLD",string(auxDir,"\\part_r_",it,".jld")),"vR",vR); end
end



function VelocityVerlet()
    include("parametersANDstuff.jl")    

    for it = 1:Nt
        # Get the force for all particles
        Fp = reduce(hcat,map( s-> LennardJonesForce(Np,s,vR,epsP,sigmaP,reip,aeip), collect(1:1:Np)))
        # Get force due to Boundary condition for all particles
        Fbc = LennardJonesBoundCond(Np,wx1,wy1,vR,epsW,sigmaW,rew,aew) .+ LennardJonesBoundCond(Np,wx2,wy2,vR,epsW,sigmaW,rew,aew)
        # Total force and Acceleration 
        ac = (1/m)*(Fp .+ Fbc);
        # Get v*
        aux[:,:] = reduce(hcat,map(s->vV[:,s] + (dt/2)*(ac[:,s]) ,collect(1:1:Np)));
        # Get position
        vR = reduce(hcat,map(s->vR[:,s] + dt*aux[:,s] ,collect(1:1:Np)));
        # Get the force for all particles
        Fp = reduce(hcat,map( s-> LennardJonesForce(Np,s,vR,epsP,sigmaP,reip,aeip), collect(1:1:Np)))
        # Get force due to Boundary condition for all particles
        Fbc = LennardJonesBoundCond(Np,wx1,wy1,vR,epsW,sigmaW,rew,aew) .+ LennardJonesBoundCond(Np,wx2,wy2,vR,epsW,sigmaW,rew,aew)
        # Total force and Acceleration 
        ac = (1/m)*(Fp .+ Fbc);
        # Get velocity
        vV = reduce(hcat,map(s->aux[:,s] + (dt/2)*(ac[:,s]) ,collect(1:1:Np)));
        # Compute mean of Kinetic energy 
        vK[it] = mean(sum(vV.^2,dims=1));
        # Save the array of position
        if it%2 == 0; save(File(format"JLD",string(auxDir,"\\part_r_",it,".jld")),"vR",vR); end
    end    

end
