"""
    Functions
"""

function LJpotential(ϵ,σ,ηr,ηa,r)
    # Compute the Lennard-Jones potential
    return 4*ϵ*( ((σ)./r).^ηr - ((σ)./r).^ηa )  
end

function LJforce(ϵ,σ,ηr,ηa,r,vu)
    # Compute the Lennard-Jones Force
    return ((4*ϵ)./r).*( ηr.*((σ)./r).^ηr - ηa.*((σ)./r).^ηa ).*vu  
end

function dif(Ap,p1,p2)
    # Get the distance and unit vector.
    d = Ap[:,p1] - Ap[:,p2]
    n = sqrt(sum(d.^2))
    uv = d/n
    return (n,uv)
end

function LJFparticles(par,vR)
    N = length(vR[1,:]);
    nP = div(N,5)
    # The ids of the particles
    ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:N)) |> collect
    # Evaluate the force for each particle
    f = Iterators.flatmap(s-> LJforce(par...,dif(vR,ids[s]...)...),collect(1:1:length(ids))) |> collect
    # Reshape for x and y components
    fx = f[1:2:end]
    fy = f[2:2:end]
    # Allocate memory
    infox = zeros(N,N)
    infoy = zeros(N,N)
    # Create the upper triangular matrix
    map(s->infox[ids[s]...] = fx[s],collect(1:1:length(ids)))
    map(s->infoy[ids[s]...] = fy[s],collect(1:1:length(ids)))
    # Create complete the matrix and sum the forces
    infox = reshape(sum(infox - infox',dims=2)[1:nP],1,nP)
    infoy = reshape(sum(infoy - infoy',dims=2)[1:nP],1,nP)
    return [infox; infoy]
end

function LJparticles(n,xl,yl,nP,R)
    # par -> n,xl,yl,Np
    #R = ones(2,nP)    
    #Rg = zeros(2,4*nP)
    smAux = 2*[[n*xl,0],[0,n*yl],[-n*xl,0],[0,-n*yl]]
    Rg = stack(map(s->R.+smAux[s],collect(1:1:4)))
    auxR = [R reshape(Rg,2,nP*4)]
    N = length(auxR[1,:])
    
    # The ids of the particles
    ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:nP)) |> collect
    idm = Iterators.flatten(map( r-> map(s->(r,s),collect(1:r-1)  ), collect(2:nP) ))|>collect
    ida = Iterators.flatmap(s->findall(x->x == reverse(idm[s]),ids),collect(1:1:length(idm)))|>collect;
    # Evaluate the force for each particle
    f = stack(map(s-> LJforce(par...,dif(auxR,ids[s]...)...),collect(1:1:length(ids))))
    # Allocation of memory
    resx = zeros(nP,N);
    resy = zeros(nP,N);
    # x component
    map( s-> resx[ids[s]...] = f[1,s],collect(1:1:length(ids)) )
    map( s-> resx[idm[s]...] = -f[1,ida[s]],collect(1:1:length(idm)) )
    # y component
    map( s-> resy[ids[s]...] = f[2,s],collect(1:1:length(ids)) )
    map( s-> resy[idm[s]...] = -f[2,ida[s]],collect(1:1:length(idm)) )
    # Total force
    resx = reshape(sum(resx,dims=2),1,nP)
    resy = reshape(sum(resy,dims=2),1,nP)

    return [resx; resy]
        
end


function rCut(σ,kb,ϵ,T)
    return ( (2*(σ)^6)./((1).+sqrt.((1).+((kb/ϵ).*T))) ).^(1/6)
end

function InitialConditions(wx1,wx2,σ,Np,vR)
    dR = collect(wx1+σ:1.5*σ:wx2-σ);
    ndr = length(dR);
    space = reduce(vcat, collect( Iterators.product(dR,dR) ));
    idP = sample(collect(1:ndr*ndr),Np,replace=false);
    ubs = space[idP];
    map(s->vR[:,s].=ubs[s],collect(1:1:Np));
    return vR
end

"""
    Packages
"""

using Random, Distributions

Random.seed!(1234);

"""
    Parameters
"""
# Lennard-Jones parameters
epsP = 5;
sigmaP = 1;
reip = 12;
aeip = 6;
parmsLJ = (epsP,sigmaP,reip,aeip);

# r cut parameters
kB = 1;
T = 2;
parmsRcut = (sigmaP,kB,epsP,T);

# System parameters
m = 1;
ti = 0;
tf = 10;
dt = 1e-3;
Np = 20;
Nt = Int(div(tf-ti,dt,RoundUp)) + 1;
xl = 10*sigmaP;
yl = 10*sigmaP;
parmsLim = (-xl,xl,-yl,yl);

# Auxiliaries for Periodic Boundary Conditions
"""
    1 is the right cuadrant
    2 is the top quadrant
    3 is the left quadrant
    4 is the bottom quadrant 
"""
n = 1;
idAux = Iterators.flatmap( s-> [s*Np+1:(s*Np)+Np],collect(1:1:4) ) |> collect
smAux = 2*[[n*xl,0],[0,n*yl],[-n*xl,0],[0,-n*yl]]



# Directory to store the simulation
auxDir = joinpath(@__DIR__,"data");

"""
    Memory allocation
"""
vR = zeros(2,5*Np);
vV = zeros(2,Np);
aux = zeros(2,Np);
vKm = zeros(Nt);
vK = zeros(Nt);
vP = zeros(Nt);

# Save Initial Conditions
#save(File(format"JLD",string(auxDir,"\\part_r_1.jld")),"vR",vR)

vR[:,1:Np] = InitialConditions(-xl,xl,sigmaP,vR[:,1:Np])

map( s-> vR[:,idAux[s]] = vR[:,1:Np] .+ smAux[s],collect(1:1:4) )

#scatter(vR[1,:],vR[2,:],aspect_ratio = 1)
#scatter(vR[1,:],vR[2,:],aspect_ratio = 1,xlims=(-xl,xl),ylims=(-yl,yl),label = false)
#scatter(vR[1,:],vR[2,:],aspect_ratio = 1,xlims=(-4*xl,4*xl),ylims=(-4*yl,4*yl),label=false)


# Initial Velocities
vV[1,:] = rand( Normal(0,sqrt(kB*T/m)),Np );
vV[2,:] = rand( Normal(0,sqrt(kB*T/m)),Np );

# Get the force for all particles
Fp = LJFparticles(parmsLJ,vR)
# Get v*
aux[:,:] = reduce(hcat,map(s->vV[:,s] + (dt/2)*((1/m)*Fp[:,s]) ,collect(1:1:Np)))
# Get position
vR = reduce(hcat,map(s->vR[:,s] + dt*aux[:,s] ,collect(1:1:Np)))
# Function for pacman behavior



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
    vKm[it] = mean(sum(vV.^2,dims=1));
    # Compute Kinetic Energy
    vK[it] = sum(vV.^2);
    # Compute potential energy
    vP[it] = sum(map( s-> LennardJonesPotential(Np,s,vR,epsP,sigmaP,reip,aeip), collect(1:1:Np)));
    # Save the array of position
    if it%2 == 0; save(File(format"JLD",string(auxDir,"\\part_r_",it,".jld")),"vR",vR); end
end





N = length(vR[1,:]);
    # The ids of the particles
    ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:N)) |> collect
    # Evaluate the function
    feval = Iterators.flatmap(s-> LJforce(par...,dif(vR,ids[s]...)...),collect(1:1:length(ids))) |> collect
    # auxiliar to store the force for each particle
    info = zeros(N,N)
    # Create the upper triangular matrix
    map(s->info[ids[s]...] = feval[s],collect(1:1:length(ids)))
    # Get the lower triangular amtrix with the transpose
    info = info - info'
    # Get the force per particle
    ljf = sum(info,dims=2)


N = length(vR[1,:]);
nP = div(N,5)
# The ids of the particles
ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:N)) |> collect
# Evaluate the force for each particle
f = Iterators.flatmap(s-> LJforce(parmsLJ...,dif(vR,ids[s]...)...),collect(1:1:length(ids))) |> collect
# Reshape for x and y components
fx = f[1:2:end]
fy = f[2:2:end]
# Allocate memory
infox = zeros(N,N)
infoy = zeros(N,N)
# Create the upper triangular matrix
map(s->infox[ids[s]...] = fx[s],collect(1:1:length(ids)))
map(s->infoy[ids[s]...] = fy[s],collect(1:1:length(ids)))
# Create complete the matrix and sum the forces
infox = reshape(sum(infox - infox',dims=2)[1:nP],1,nP)
infoy = reshape(sum(infoy - infoy',dims=2)[1:nP],1,nP)

final = [infox; infoy]


function LJFparticles(par,vR)
    N = length(vR[1,:]);
    nP = div(N,5)
    # The ids of the particles
    ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:N)) |> collect
    # Evaluate the force for each particle
    f = Iterators.flatmap(s-> LJforce(par...,dif(vR,ids[s]...)...),collect(1:1:length(ids))) |> collect
    # Reshape for x and y components
    fx = f[1:2:end]
    fy = f[2:2:end]
    # Allocate memory
    infox = zeros(N,N)
    infoy = zeros(N,N)
    # Create the upper triangular matrix
    map(s->infox[ids[s]...] = fx[s],collect(1:1:length(ids)))
    map(s->infoy[ids[s]...] = fy[s],collect(1:1:length(ids)))
    # Create complete the matrix and sum the forces
    infox = reshape(sum(infox - infox',dims=2)[1:nP],1,nP)
    infoy = reshape(sum(infoy - infoy',dims=2)[1:nP],1,nP)
    return [infox; infoy]
end





infox = zeros(N,N)




"""

NVE is the micro canonical assemble. Constante number of particles, volume and energy
NVT is the canonical assemble. Constant number of particles, volume and temperature.

Include a medium:
    We can model the medium with an extra term in the equation, known as an implicit medium, or
    Add a different type of particle in the simulation, known as a explicit medium.

    In the explicit medium, the temperature is controlled by Nose-Hover thermostat.
    In the implicit medium, the temperature is controlled by F = -γυ + η

"""
