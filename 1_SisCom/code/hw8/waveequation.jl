"""
    Script to solve the wave equation
"""

# Packages
using LinearAlgebra
using Plots

# Physical parameters
"""
    rl:     Spatial limit           [mts]
    tf:     Final time              [seg]
"""
rl = 2.5;
tf = 10;
xl = rl/2;
yl = rl/2;
f = 0.5;
υ1 = 0.3;
υ2 = 0.1;


# Numerical parameters
"""
    CDL:    Courant-Friedrich coefficient 
    dr:     Spatial differential
    dt:     Temporal differential
"""
CFL = 0.2;
dr = 1e-2;
dt = (CFL*dr)/maximum((υ1,υ2));

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
sol = zeros(Nr,Nr,Nt);

nxs = 10;
nys = 10;

# Auxiliaries
m = Tridiagonal(ones(Nr-1),-2*ones(Nr),ones(Nr-1));
mΥ = υ1.*ones(Nr,Nr);

w_y = ((ones(1,Nr).*r).>-0.5).*((ones(1,Nr).*r).<0.5);
w_x = ((ones(Nr,1).*r').>-0.25).*((ones(Nr,1).*r').<0.25)

w = w_y.*w_x;

mΥ[w].= υ2;


function dfcX(m,sol,it)
    """
        Second order derivative in x
    """
    info = copy(sol[:,:,it]);
    map(r->info[r,:] = m*info[r,:],eachindex(info[1,:]))
    return info
end

function dfcY(m,sol,it)
    """
        Second order derivative in y
    """
    info = copy(sol[:,:,it]);
    map(r->info[:,r] = m*info[:,r],eachindex(info[:,1]))
    return info
end

function source(f,t)
    return 10*sin(2π/f * t)
end

# Initial conditions
sol[nys,nxs,1] = source(f,1*dt);
sol[nys,nxs,2] = source(f,2*dt);

# Propagation
for it∈2:Nt-1
    # Propagation
    sol[:,:,it+1] = (dt^2/dr^2).*(mΥ.^2).*(dfcX(m,sol,it) + dfcY(m,sol,it)) + 2*sol[:,:,it] - sol[:,:,it-1]

    # Source
    sol[nys,nxs,it+1] = source(f,(it+1)*dt);

    # Boundary Conditions
    sol[:,1,it+1].=0;
    sol[:,end,it+1].=0;
    sol[1,:,it+1].=0;
    sol[end,:,it+1].=0;
end