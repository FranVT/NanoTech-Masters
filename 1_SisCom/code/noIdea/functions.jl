"""
    functions.jl

    File with all the functions needed for molecular dynamics using Lennard-Jones potential.
        LennardJonesPotential()     ---> Compute potential energy
        LennardJonesForce()         ---> Compute force due to Lennard-Jones potential
        LennardJonesBoundCond()     ---> Compute force due to boundary conditions.
        VelocityVerlet()            ---> Numerical Method

"""

# Lennar-Jones Potential
function LennardJonesPotential(np,pRef,pos,ϵ,σ,rexp,aexp)
    """
        np:         Number of particles
        pRef:       Number of the particle of reference
        pos:        Array with the position of n particles; size --> (2,np)
        ϵ:          Energy of the potential
        σ:          Particle size
        rexp:       Repulsive exponent
        aexp:       Attractive exponent
        LJp:        Variable with the value of the potential for the system.
    """
    # Array preparation
    nPart = collect(1:np);
    part = deleteat!(nPart,findall(x->x==pRef,nPart));
    # Compute the difference
    dif = reduce(hcat, map( s-> pos[:,pRef] - pos[:,s], part) );
    # Compute the distance
    r = sqrt.( sum( dif.^2,dims=1) );
    # Compute the force
    LJp = sum((4*ϵ)*(((σ)./r).^rexp .- ((σ)./r).^aexp));

    return LJp
end

# Lennar-Jones Force
function LennardJonesForce(np,pRef,pos,ϵ,σ,rexp,aexp)
    """
        np:         Number of particles
        pRef:       Number of the particle of reference
        pos:        Array with the position of n particles; size --> (2,np)
        ϵ:          Energy of the potential
        σ:          Particle size
        rexp:       Repulsive exponent
        aexp:       Attractive exponent
        LFf:        Array with the force in the particle of reference; size --> (2,1)
    """
    # Array preparation
    nPart = collect(1:np)
    part = deleteat!(nPart,findall(x->x==pRef,nPart))
    # Compute the difference
    dif = reduce(hcat, map( s-> pos[:,pRef] - pos[:,s], part) )
    # Compute the distance
    dist = sqrt.( sum( dif.^2,dims=1) )
    # Compute the force
    LJf = sum(((4*ϵ)./dist).*(rexp.*((σ)./dist).^rexp .- aexp.*((σ)./dist).^aexp).*(dif./dist),dims=2)

    return LJf
end

# boundary conditions
function LennardJonesBoundCond(np,wx,wy,pos,ϵ,σ,rexp,aexp)
    """
        np:         Number of particles
        wx:         Position of the boundary in the x axis
        wy:         Position of the boundary in the y axis
        pos:        Array with the position of n particles; size --> (2,np)
        ϵ:          Energy of the potential for the boundary
        σ:          Boundary size
        rexp:       Repulsive exponent
        aexp:       Attractive exponent
        LJfx:       Array with the force due to boundary conditions in x; size --> (1,np)
        LJfy:       Array with the force due to boundary conditions in y; size --> (1,np)
    """
    # Array preparation
    nPart = collect(1:np)
    # Compute the difference in x 
    dif = reduce(hcat, map( s-> pos[1,s] - wx, nPart) )
    # Compute the force in x
    LJfx = ((4*ϵ)./dif).*(rexp.*((σ)./dif).^rexp .- aexp.*((σ)./dif).^aexp)
    # Compute the difference in x 
    dif = reduce(hcat, map( s-> pos[2,s] - wy, nPart) )
    # Compute the force in x
    LJfy = ((4*ϵ)./dif).*(rexp.*((σ)./dif).^rexp .- aexp.*((σ)./dif).^aexp)

    return [LJfx; LJfy]
end

# Velocity Verlet
function VelocityVerlet()
    """
    Memory Allocation:
        Nt:         Temporal nodes
        vR:         Position array for Np particles for a 3 dimensional cartisian coordinates
        vV:         Velocity array for Np particles for a 3 dimensional cartisian coordinates
        aux:        Array for store the velocity auxiliar of the numerical Method
        vKm:        Mean od the Kinetic energy vector
        vK:         Kinetic energy vector
        vP:         Potential energy

    Initial Positions:
        dR:         Array with spatial range for initial positions
        ndr:        Auxiliary variable
        space:      Array with tuples of cartessian coordinates;                    size --> (ndr,1)
        idP:        Array with the index of the coordinate for the particles;       size --> (1,np)
        ubs:        Auxiliary variable for store the coordinates for the particles; size --> (1,np)
    
    Initial Velocities
        Maxwell – Boltzmann distribution for molecular velocity components
        P(v) = sqrt( m/(2*pi*kB*T) )*exp( -m/(2*kB*T)v^2 )
        mean(vx) = 0            sigma = sqrt(kB T/m)

    Velocity Verlet
        Fp:         Force per particle due to interactions between particles;   size --> (2,nNp)
        Fbc:        Force per particle due to boundary conditions;              size --> (2,nNp)
        ac:         Acceleration per particle;                                  size --> (2,nNp)
        aux:        Velocity at half time step;                                 size --> (2,nNp)


    """

    # Memory Allocation
    vR = zeros(2,Np);
    vV = zeros(2,Np);
    aux = zeros(2,Np);
    vKm = zeros(Nt);
    vK = zeros(Nt);
    vP = zeros(Nt);

    # Initial Position
    dR = collect(wx2+sigmaW:1.5*sigmaP:wx1-sigmaW);
    ndr = length(dR);
    space = reduce(vcat, collect( Iterators.product(dR,dR) ));
    idP = sample(collect(1:ndr*ndr),Np,replace=false);
    ubs = space[idP];
    map(s->vR[:,s].=ubs[s],collect(1:1:Np));

    # Save Initial Conditions
    save(File(format"JLD",string(auxDir,"\\part_r_1.jld")),"vR",vR)

    # Initial Velocities
    vV[1,:] = rand( Normal(0,sqrt(kB*T/m)),Np );
    vV[2,:] = rand( Normal(0,sqrt(kB*T/m)),Np );

    # Velocity Verlet
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
    # Save the energies arrays
    save(File(format"JLD",string(auxDir,"\\kineticEnergy.jld")),"vK",vK)
    save(File(format"JLD",string(auxDir,"\\kinetimEnergy.jld")),"vKm",vKm)
    save(File(format"JLD",string(auxDir,"\\potentiEnergy.jld")),"vP",vP)

end