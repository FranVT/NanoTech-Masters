
function VelocityVerlet(vR,vV,aux,dt,Np,Nt,m,sigmaP,sigmaW,reip,aeip,rew,aew,epsP,epsW,auxwy,auxw)
    """
    Velocity Verlet Method for a force of n particles

    pos:        Array of positions      [x1,y1 x2,y2 ... xn,yn]
    vel:        Array of velocities     [vx1,y1 vx2,vy2 ... vxn,vyn]
    m:          Array of mass           [m1 m2 ... mn]
    dt:         Temporal diferential
    Np:         Number of particles
    nt:         Time iterations
"""
auxDir = joinpath(@__DIR__,"data");

    for it = 1:Nt
        # Acceleration of all particles
        ac = (1/m).*LJf(vR,sigmaP,reip,aeip,epsP);
        # Acceleration due to Boundary conditions
        bc = (1/m).*sum(reduce(vcat,map(t->map( s-> BoundCond(vR,auxw[s],auxwy[t],sigmaW,rew,aew,epsW),collect(1:1:2)),collect(1:1:2))));
        # Get v*
        aux[:,:] = reduce(hcat,map(s->vV[:,s] + (dt/2)*(ac[:,s] + bc[:,s] ) ,collect(1:1:Np)));
        # Get position
        vR = reduce(hcat,map(s->vR[:,s] + dt*aux[:,s] ,collect(1:1:Np)));
        # Acceleration of all particles
        ac = (1/m).*LJf(vR,sigmaP,reip,aeip,epsP);
        # Acceleration due to Boundary conditions
        bc = (1/m).*sum(reduce(vcat,map(t->map( s-> BoundCond(vR,auxw[s],auxwy[t],sigmaW,rew,aew,epsW),collect(1:1:2)),collect(1:1:2))));
        # Get velocity
        vV = reduce(hcat,map(s->aux[:,s] + (dt/2)*(ac[:,s] + bc[:,s]) ,collect(1:1:Np)));
        # Compute mean of Kinetic energy 
        vK[it] = mean(sum(vV.^2,dims=1));
        # Save the array of position
        if it%4 == 0; save(File(format"JLD",string(auxDir,"\\part_r_",it,".jld")),"vR",vR); end
    end

end

