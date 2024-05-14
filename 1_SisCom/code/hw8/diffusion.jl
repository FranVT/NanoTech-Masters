"""
    Script to solve the diffusion equation in one dimension
"""

# Packages
using LinearAlgebra
using Plots

# Physical parameters
"""
    D:      Diffusion coefficient   []
    rl:     Spatial limit           [mts]
    tf:     Final time              [seg]
"""
D = 1;
rl = 100e-6;
tf = 100e-12;


# Numerical parameters
"""
    CDL:    Courant-Lvdfv coefficient 
    dr:     Spatial differential
    dt:     Temporal differential
"""
CDL = 0.1;
dr = 0.5e-6;
dt = (CDL*dr^2)/D;

# Spatial and temporal domain
r = range(start=-rl/2,stop=rl/2,step=dr);
t = range(start=0,stop=tf,step=dt);

# Computaitonal parameters
"""
    Nr:     Spatial nodes
    Nt:     Temporal nodes
"""
Nr = length(r);
Nt = length(t);
sol = zeros(Nr,Nt);

# Auxiliaries
m = CDL.*Tridiagonal(ones(Nr-1),-2*ones(Nr),ones(Nr-1));

# Initial condition
sol[Nr÷2,1] = 100;

# Propagation
map(it-> sol[:,it+1] = m*sol[:,it] + sol[:,it], 1:Nt-1)

# Graph
heatmap(t,r,sol[:,1:10])
