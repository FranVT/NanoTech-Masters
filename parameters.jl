"""
    parameters.jl

    File that contains all physical parameters to define the physical system.
"""

# Physical parameters
"""
    Kb:         Boltzman constant           [J/K]
    m:          Mass                        [Kg]
    sigmaP:     Particle size               [m]
    sigmaW:     Wall size                   [m]
    epsP:       Innerparticle energy        [J]
    epsW:       Wall energy                 [J]
    T:          Temperature                 [K]
    reip:       Repulsive eponent for Innerparticle potential
    aeip:       Attractive eponent for Innerparticle potential
    rew:        Repulsive eponent for Wall potential
    aew:        Attractive eponent for Wall potential
"""
kB = 1;
m = 1;
sigmaP = 1;
sigmaW = 1;
epsP = 5;
epsW = epsP;
T = 2*epsP/kB;
reip = 12;
aeip = 6;
rew = 20;
aew = 1;

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
tf = 10;
dt = 1e-3;
Np  = 100;
wx1 = 10*sigmaP;
wx2 = -wx1;
wy1 = 10*sigmaP;
wy2 = -wy1;
Nt = Int(div(tf-ti,dt,RoundUp)) + 1;

# Directory to store the simulation
auxDir = joinpath(@__DIR__,"data");
