module Functions

export idNeighbors, computeEnergyPmap, computeHamiltonianThreads, metropoliAlgorithm

using Random
using Distributions

# Construct the neighbor lists
function idNeighbors(Ng)
    """
    id:     List of nodes
    auxn:   "Direction" of the neighbors
    neigh:  List of neighbors:
                1 -> Left
                2 -> Right 
                3 -> Bottom
                4 -> Top
    part:   List of nodes with its neighbors
                ((xi,yi),((xi,yi+1),(x1,yi-1),(xi+1,yi),(xi-1,yi)))
    """
        id = [(x,y)  for y∈1:Ng, x∈1:Ng];
        auxn = ((0,1),(0,-1),(1,0),(-1,0));
    
        # Assign the neighbors
        miau = map(s->id[s].+auxn[1],1:length(id));
    
        neigh = map(r->map(s->id[s].+auxn[r],1:length(id)),1:length(auxn));
    
        # Apply periodic boundary conditions
        # Right and left 
        neigh[1][last.(neigh[1]).>Ng] = map(.+,neigh[1][last.(neigh[1]).>Ng],[(0,-Ng) for x∈1:Ng]);
        neigh[2][last.(neigh[2]).<1] = map(.+,neigh[2][last.(neigh[2]).<1],[(0,Ng) for x∈1:Ng]);
    
        # Top and Bottom
        neigh[3][first.(neigh[3]).>Ng] = map(.+,neigh[3][first.(neigh[3]).>Ng],[(-Ng,0) for x∈1:Ng]);
        neigh[4][first.(neigh[4]).<1] = map(.+,neigh[4][first.(neigh[4]).<1],[(Ng,0) for x∈1:Ng]);
    
        # Construct the node with its neighbors
        return map(s->(id[s],(neigh[1][s],neigh[2][s],neigh[3][s],neigh[4][s])),1:Ng*Ng);
end

# Create a change in the system
function smallSysChange(sys,part,id)
    """
        Change one spin of the system
    """
        nsys = copy(sys);
        nsys[first(part[id])...] = -nsys[first(part[id])...]
        return nsys
end

# Compute the chanage of energy
function computeDeltaE(J,syso,part,id)
    """
        Compute the changeof energy given the spin that changes.
        sysn:       System with the change
        syso:       Original system
    """
        info = part[id];
        ΔE = J*2*syso[info[1]...]*mapreduce(s->syso[info[2][s]...],+,1:4);
        return ΔE #/last(eachindex(syso))
end

function computeHamiltonian(J,B,sys,part)
    """
        Compute the Hamiltonian with "parallel particles"
        Compute the Hamiltonian of a particle in the Ising model
            Paralelizaition scheme: Particles
            t1: Energy
            t2: Magnetization
    """

        t1 = -J*mapreduce(r->sys[part[r][1]...]*mapreduce(s->sys[last.(part)[r][s]...],+,(1,3)),+,eachindex(sys))
        t2 = -B*sum(sys)

    return (t1,t2)#(t1/last(eachindex(sys)),t2/last(eachindex(sys)))
end

function metropoliAlgorithm(σ,Ng,Nsteps,part,J,kb,T,Eo)
    
    # Create a set of random seed for each step
    setSeeds = abs.(rand(Int,Nsteps));

    # Array to save the sates
    states = [zeros(Int64,Ng,Ng) for s∈1:Nsteps];
    energ = zeros(Nsteps*Ng*Ng+1);
    mag = zeros(Nsteps*Ng*Ng+1);
    auxs = 1;

    # Start the energy array
    
    energy = copy(Eo);
    energ[auxs] = energy;
    mag[auxs] = -sum(σ); #/Ng^2;
    states[auxs].= σ

    for step ∈ 1:Nsteps
        # Change the seed 
        Random.seed!(setSeeds[step])
        for trial ∈ eachindex(σ)
            auxs += 1;
            
            # Compute the difference in energy
            ΔE = Functions.computeDeltaE(J,σ,part,trial);

            # Acceptance step 
            if energy+ΔE < energy #ΔE < 1/Ng^2 # Accepted
                # Make tha change in the one particle
                σ = Functions.smallSysChange(σ,part,trial);
                energy += ΔE;
            else # Rejected, not yet
                # Accpet or reject with probability of exp(-ΔE/kb T)
                γ = exp(-ΔE/(kb*T));
                aux = wsample([0,1],[1-γ,γ]);
                if aux == 1 # Accepted
                    # Make tha change in the one particle
                    σ = Functions.smallSysChange(σ,part,trial);
                    energy += ΔE;
                else # Rejected, now it is for real
                    σ = copy(σ);
                end
            end
            
            mag[auxs] = -sum(σ); #/Ng^2;
            energ[auxs] = energy;
            #println(energy)
            #states[auxs].= σ;
            #mag[auxs] = sum(σ);
            #energ[1,auxs] = energy;
            #energ[2,auxs] = ΔE
        end
        states[step].= σ;
    end
    return (states,(energ,mag))
end

println("Loaded functions")
end