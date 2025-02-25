# Lennar-Jones Potential
function LennardJonesPotential(np,pRef,pos,ϵ,σ,rexp,aexp)
    # Array preparation
    nPart = collect(1:np)
    part = deleteat!(nPart,findall(x->x==pRef,nPart))
    # Compute the difference
    dif = sum(reduce(hcat, map( s-> pos[:,pRef] - pos[:,s], part) ),dims=2)
    # Compute radius and angle
    r = sqrt(sum(dif.^2));
    # Compute the force
    LJp = (4*ϵ)*((σ/r)^rexp - (σ/r)^aexp);

    return LJp
end


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

# Velocity Verlet
function VelocityVerlet()
    #include("parametersANDstuff.jl")

    # Simulation parameters
    """
    Nt:         Temporal nodes
    vR:         Position array for Np particles for a 3 dimensional cartisian coordinates
    vV:         Velocity array for Np particles for a 3 dimensional cartisian coordinates
    aux:        Array for store the velocity auxiliar of the numerical Method
    vK:         Kinetic energy vector
    """
    vR = zeros(2,Np);
    vV = zeros(2,Np);
    aux = zeros(2,Np);
    vKm = zeros(Nt);
    vK = zeros(Nt);
    vP = zeros(Nt);

    # Initial Conditions
    """
    For radial initial position
    
    auxTh = sample(0:2*pi/(Np):2*pi,Np, replace = false)
    vR[1,:] = wx1.*sample(0.25:(0.75-0.25)/(Np+1):0.75, Np, replace = false).*cos.(auxTh);
    vR[2,:] = wx1.*sample(0.25:(0.75-0.25)/(Np+1):0.75, Np, replace = false).*sin.(auxTh);
    """
    """
    For a 'square' distribution
    """
    vR[1,:] = sample( collect(0.75*wx2:0.75*(wx1-wx2)/(4*Np):0.75*wx1),Np,replace=false );
    vR[2,:] = sample( collect(0.75*wy2:0.75*(wy1-wy2)/(4*Np):0.75*wy1),Np,replace=false );

    # Save Initial Conditions
    save(File(format"JLD",string(auxDir,"\\part_r_1.jld")),"vR",vR)

    """
    Initial velocities using probability distribution of Boltzmann:
    Maxwell – Boltzmann distribution for molecular velocity components
    P(v) = sqrt( m/(2*pi*kB*T) )*exp( -m/(2*kB*T)v^2 )
    mean(vx) = 0
    sigma = sqrt(kB T/m)
    """
    vV[1,:] = rand( Normal(0,sqrt(kB*T/m)),Np );
    vV[2,:] = rand( Normal(0,sqrt(kB*T/m)),Np );

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
    save(File(format"JLD",string(auxDir,"\\kineticEnergy.jld")),"vK",vK)
    save(File(format"JLD",string(auxDir,"\\kinetimEnergy.jld")),"vKm",vKm)
    save(File(format"JLD",string(auxDir,"\\potentiEnergy.jld")),"vP",vP)


end