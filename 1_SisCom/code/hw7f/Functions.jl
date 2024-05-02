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
function rsmallSysChange(sys,part,id)
    """
        Change one spin of the system
    """
        nsys = copy(sys);
        nsys[first(part[id])...] = rand([-1,1])
        return nsys
end

# Compute the chanage of energy
function computeDeltaE(J,B,sysn,syso,part,Ng,id)
    """
        Compute the changeof energy given the spin that changes.
        sysn:       System with the change
        syso:       Original system
    """
        info = part[id];
        ΔE = J*2*syso[info[1]...]*sum(map(s->sysn[info[2][s]...],1:4));
        return ΔE
end
    

# Compue the energy
function computeEnergyPmap(J,B,sys,part,Ng)
    """
        Compute the energy given an arrange of a grid with spins and neigbor lists
    """
        dom = eachindex(sys);
        t1 = sum(map(r->sys[part[r][1]...]*sum(map(s->sys[last.(part)[r][s]...],(1,3))),dom));
        t2 = sum(map(r->sys[part[r][1]...],dom));
        return (-J*t1, B*t2)
end

function computeHamiltonianThreads(J,B,sys,part,N)
    """
        Compute the Hamiltonian with parallel particles
    """
        # Auxiliary function
        function sumPart(J,sys,part,dom)
        """
            Compute the Hamiltonian of a particle in the Ising model
            Paralelizaition scheme: Particles
            t1: Energy
            t2: Magnetization
        """
            t1 = -J*mapreduce(r->sys[part[r][1]...]*mapreduce(s->sys[last.(part)[r][s]...],+,(1,3)),+,dom)
            t2 = -B*mapreduce(r->sys[part[r][1]...],+,dom)
            #println(dom," finish")
            return (t1,t2)
        end

        domPart = eachindex(sys);
        chunksPart = Iterators.partition(domPart, length(domPart) ÷ (Threads.nthreads()-N));
        taskPart = map(chunksPart) do s
            Threads.@spawn sumPart(J,sys,part,s)
        end

        fetch_sum = fetch.(taskPart)
        
    return (sum(first.(fetch_sum)),sum(last.(fetch_sum)))
end

function computeAllHam(states)
    include("parameters.jl")
    part = Functions.idNeighbors(Ng);
    return map(s->Functions.computeHamiltonianThreads(J,B,states[s],part,Ng),eachindex(states))
end

function metropoliAlgorithm(σ,Ng,Nsteps,part,J,B,kb,T,Eo)
    
    # Create a set of random seed for each step
    setSeeds = abs.(rand(Int,Nsteps));

    # Array to save the sates
    states = [zeros(Ng,Ng) for s∈1:Nsteps*Ng*Ng+1];
    energ = zeros(Int64,Nsteps*Ng*Ng+1);
    mag = zeros(Int64,Nsteps*Ng*Ng+1);
    auxs = 1;

    # Start the energy array
    energy = copy(Eo);
    energ[auxs] = energy;
    mag[auxs] = sum(σ);

    for step ∈ 1:Nsteps
        # Change the seed 
        Random.seed!(setSeeds[step])
        for trial ∈ eachindex(σ)
            auxs += 1;

            # Make tha change in the one particle
            η = Functions.rsmallSysChange(σ,part,trial);
            
            # Compute the difference in energy
            ΔE = Functions.computeDeltaE(J,B,η,σ,part,Ng,trial);

            # Acceptance step 
            if ΔE < 1 # Accepted
                σ = copy(η);
                energy = energ[auxs-1] + 0.25*ΔE;
            else # Rejected, not yet
                # Accpet or reject with probability of exp(-ΔE/kb T)
                γ = exp(-ΔE/(kb*T));
                aux = wsample([0,1],[1-γ,γ]);
                if aux == 1 # Accepted
                    σ = copy(η)
                    energy = energ[auxs-1] + 0.25*ΔE;
                else # Rejected, now it is for real
                    σ = copy(σ);
                    energy = energ[auxs-1];
                end
            end
            states[auxs].= σ;
            mag[auxs] = sum(σ);
            energ[auxs] = energy;
        end
    end
    return (states,(energ./Nsteps,mag./Nsteps))
end

println("Loaded")
end