"""
    Script to solve the diffusion equation with harmonic potential in one dimension
"""

# Packages
using LinearAlgebra

# Physical parameters
"""
    D:      Diffusion coefficient   []
    κ:      Harmonic potential      []
    rl:     Spatial limit           [mts]
    tf:     Final time              [seg]
"""
D = 1;
κ = 5000000000000;
rl = 100e-6;
tf = 2.5e-12;

# Numerical parameters
"""
    CDL:    Courant-Lvdfv coefficient 
    dr:     Spatial differential
    dt:     Temporal differential
"""
CDL = 0.1;
dr = 0.2e-6;
dt = (CDL*dr^2)/D;

# Spatial and temporal domain
r = range(start=-rl/2,stop=rl/2,step=dr);
t = range(start=0,step=dt,length=100);


# Computational parameters
Nr = length(r);
Nt = length(t);
solhd = zeros(Nr,Nt);

# Auxiliaries
"""
    Auxiliaries for the numerical method
    aux1 
    m2
    m3plot
"""

m1 = (κ*dt)/(2*dr)*Tridiagonal(-ones(Nr-1),zeros(Nr),ones(Nr-1));
m2 = CDL.*Tridiagonal(ones(Nr-1),-2*ones(Nr),ones(Nr-1));

solhd[Nr÷2,1] = 1;

# Propagation
map(it->solhd[:,it+1] = κ*dt*solhd[:,it] + r.*m1*solhd[:,it] + m2*solhd[:,it] + solhd[:,it],1:Nt-1)

# Plots
