"""
    Script to solve the diffusion equation with harmonic potential in one dimension
"""

# Packages
using LinearAlgebra
using Plots

# Physical parameters
"""
    D:      Diffusion coefficient   []
    κ:      Harmonic potential      []
    rl:     Spatial limit           [mts]
    tf:     Final time              [seg]
"""
D = 0.1;
κ = 100;
rl = 100e-6;
tf = 10e-12;

# Numerical parameters
"""
    CDL:    Courant-Lvdfv coefficient 
    dr:     Spatial differential
    dt:     Temporal differential
"""
CDL = 0.1;
dr = 0.1e-6;
dt = (CDL*dr^2)/D;

# Spatial and temporal domain
r = range(start=-rl/2,stop=rl/2,step=dr);
t = range(start=0,stop=tf,step=dt);


# Computational parameters
Nr = length(r);
Nt = length(t);
sol = zeros(Nr,Nt);

# Auxiliaries
"""
    Auxiliaries for the numerical method
    aux1 
    m2
    m3
"""
aux1 = κ*dt;
aux2 = D*dt/dr^2;

m1 = 1/(2*dr)*Tridiagonal(ones(Nr-1),zeros(Nr),-ones(Nr-1));
m2 = aux2.*Tridiagonal(ones(Nr-1),-2*ones(Nr),ones(Nr-1));

sol[Nr÷2,1] = 10;
sol[Nr÷2+100,1] = 10;
sol[Nr÷2-100,1] = 10;


# Propagation
map(it->sol[:,it+1] = aux1.*(sol[:,it] + r.*m1*sol[:,it] ) + m2*sol[:,it] + sol[:,it],1:Nt-1)

# Plots
