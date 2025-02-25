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
m = 10e-20;     # 10^-23 aprox 10 000 atomic mass unit
sigmaP = 500e-2;
sigmaW = 1*sigmaP;
epsP = 1e-10;
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
tf = 6e-3;
dt = 1e-6;
Np  = 100;
wx1 = 10*sigmaP;
wx2 = -wx1;
wy1 = 10*sigmaP;
wy2 = -wy1;
auxw = [wx1,wx2]; auxwy = [wy1,wy2];
Nt = Int(div(tf-ti,dt,RoundUp)) + 1;

# Directory to store the simulation
auxDir = joinpath(@__DIR__,"data");
