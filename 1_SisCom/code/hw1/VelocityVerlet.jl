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