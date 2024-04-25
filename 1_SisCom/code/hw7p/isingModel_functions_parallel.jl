"""
    Script with usefull functions
"""

function dictPBC(Ng)
    # Range
    dom = 1:Ng;

    # Mapping stuff
    relation = [(x,x) for x∈dom]

    # Include boundary condition
    append!(relation,[(0,Ng),(Ng+1,1)])

    # Converted to dictionary
    return Dict(relation);
end

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

# Compue the energy
function computeEnergy(J,B,sys,part,Ng)
    """
        Compute the energy given an arrange of a grid with spins and neigbor lists
    """
        t1 = sum(map(r->sys[part[r][1]...]*sum(map(s->sys[last.(part)[r][s]...],1:4)),1:Ng*Ng));
        t2 = sum(map(r->sys[part[r][1]...],1:Ng*Ng));
        return -(J*t1 + B*t2)/2
end

# Compute the Hamiltonian with a parallel scheme
function computeHamiltonianP(J,B,sys,part,Ng,Nth)
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
            t1 = -J*sum(map(r->sys[part[r][1]...]*sum(map(s->sys[last.(part)[r][s]...],1:4)),dom))
            t2 = -B*sum(map(r->sys[part[r][1]...],dom))
            return (t1,t2)
        end
    
        # Domain of particles
        domPart = 1:Ng^2;
        
        # Chunks are the domains partitions
        chunksPart = Iterators.partition(domPart, length(domPart) ÷ ((Threads.nthreads()-Nth)÷Nth));
    
        # Task of getting the values of the neighbors
        taskPart = map(chunksPart) do s
            Threads.@spawn sumPart(J,sys,part,s)
        end
    
        # Fetch
        fetch_sum = fetch.(taskPart)

        # Energy and Magnetization
        eneg = sum(first.(fetch_sum))÷2;
        mag = sum(last.(fetch_sum))÷2;
    
        println("Done computeEnergyP")
        # Compute the final Energy
        return (energ,mag)
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

# Create a change in the system
function smallSysChange(sys,part,id)
"""
    Change one spin of the system
"""
        nsys = copy(sys);
        nsys[first(part[id])...] = -sys[first(part[id])...]
        return nsys
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

function metropoliAlgorithm(σ,nExp,Nth)
"""
    Computes the metropoli 
"""
    # Includes parameters and auxiliary functions
    include("isingModel_parameters.jl")
    include("isingModel_functions.jl")

    # Array to save the sates
    states = [zeros(Ng,Ng) for s∈1:Nsteps*Ng*Ng]
    energ = [0.0 for s∈1:Nsteps*Ng*Ng]
    mag = [0.0 for s∈1:Nsteps*Ng*Ng]
    auxs = 1;
    
        for step ∈ 1:Nsteps
            # Change the seed 
            Random.seed!(setSeeds[step])
            for trial ∈ 1:Ng*Ng
                # Make tha change in the one particle
                η = rsmallSysChange(σ,part,trial);
                
                # Compute the difference in energy
                ΔE = computeDeltaE(J,B,η,σ,part,Ng,trial);
                
                # Acceptance step 
                if ΔE < 1 # Accepted
                    σ = copy(η);
                    states[auxs].= σ;
                    (t1, t2) = computeHamiltonianP(J,B,sys,part,Ng,Nth)
                    energ[auxs] = t1
                    mag[auxs] = t2
                else # Rejected, not yet
                    # Accpet or reject with probability of exp(-ΔE/kb T)
                    γ = exp(-ΔE/(kb*T));
                    aux = wsample([0,1],[1-γ,γ],(Ng,Ng));
                    if aux == 1 # Accepted
                        σ = copy(η)
                        states[auxs].= σ;
                        (t1, t2) = computeHamiltonianP(J,B,sys,part,Ng,Nth)
                        energ[auxs] = t1
                        mag[auxs] = t2
                    else # Rejected, now it is for real
                        σ = copy(σ)
                    end
                end
                auxs = auxs + 1;
            end
        end
    # Clean the data
    states = filter(!iszero,states);
    energ = filter(!iszero,energ);
    mag = filter(!iszero,mag);

    # Save the data
    save(File(format"JLD",string(path,"/T_",T,nExp,"states.jld")),"states",states)
    save(File(format"JLD",string(path,"/T_",T,nExp,"energ.jld")),"energ",energ)
    save(File(format"JLD",string(path,"/T_",T,nExp,"mag.jld")),"mag",mag)
    save(File(format"JLD",string(path,"/seeds",step,".jld")),"seeds",setSeeds)

    return (states,(energ,mag))

end

# Function to extract the information
function getInfo(T,nExp)
    info = load(string(path,"/T_",T,nExp,"states.jld"),"states");
    return (info,length(info))
end

# Function to extract the information
function getInfoObs(path,Ng,Nsteps)
    saveStates = load(string(path,"/idsState",Nsteps,".jld"),"mcss");
    frames = sum(first.(size.(saveStates)));
    info = zeros(Int64,Ng,Ng,frames);
    aux = append!([0],cumsum(first.(size.(saveStates))));
    
    for s∈1:Nsteps
        for t∈1:length(saveStates[s])
            info[:,:,t+aux[s]] = load(string(path,"/state",s,"_",saveStates[s][t],".jld"),"σ")
        end
    end
    return (info, frames)
end

