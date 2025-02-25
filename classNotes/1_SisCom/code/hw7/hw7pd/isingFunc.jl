module isingFunc

"""
    Module with all the dunctions for the Ising model
        with the popuse of distributed computing.
"""

export idNeighbors, computeHamiltonianP, computeHamiltonianP2, computeDeltaE, rsmallSysChange, metropoliAlgorithm

using Pkg; Pkg.instantiate()
using Distributions
using Random

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

# Compute the Hamiltonian with a parallel scheme
function computeHamiltonianP(J,B,sys,part,Ng)
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
            t1 = -J*sum(map(r->sys[part[r][1]...]*sum(map(s->sys[last.(part)[r][s]...],(1,4))),dom))
            t2 = -B*sum(map(r->sys[part[r][1]...],dom))
            #println(dom," finish")
            return (t1,t2)
        end

        # Domain of particles
        domPart = 1:Ng^2;
        
        # Chunks are the domains partitions
        chunksPart = Iterators.partition(domPart, length(domPart) ÷ Threads.nthreads());
 
        #@time begin
        # Task of getting the values of the neighbors
        taskPart = map(chunksPart) do s
            Threads.@spawn sumPart(J,sys,part,s)
        end
    
        # Fetch
        fetch_sum = fetch.(taskPart)
        #end
        
        # Energy and Magnetization
        energ = sum(first.(fetch_sum));
        mag = sum(last.(fetch_sum));
        
        #println("One state")
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
function rsmallSysChange(sys,part,id)
    """
        Random change on one spin of the system
    """
        nsys = copy(sys);
        nsys[first(part[id])...] = rand([-1,1])
        return nsys
end
    
function metropoliAlgorithm(part,nExp)
    """
        Computes the metropoli 
    """
    # Includes parameters and auxiliary functions
    include("isingModel_parameters.jl")

    # Array to save the sates
    states = [zeros(Ng,Ng) for s∈1:Nsteps*Ng*Ng];
    #energ = zeros(Nsteps*Ng*Ng);
    #mag = zeros(Nsteps*Ng*Ng);
    auxs = 1;

    # Create a set of random seed for each step
    setSeeds = abs.(rand(Int,Nsteps));

    # Initial state
    σ = wsample(σs,[1-η,η],(Ng,Ng));
    #energy = first(computeHamiltonianP(J,B,σ,part,Ng));

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
                    #energy = energy + ΔE;
                    states[auxs].= σ;
                    #mag[auxs] = sum(σ);
                    #energ[auxs] = energy;
                else # Rejected, not yet
                    # Accpet or reject with probability of exp(-ΔE/kb T)
                    γ = exp(-ΔE/(kb*T));
                    aux = wsample([0,1],[1-γ,γ],(Ng,Ng));
                    if aux == 1 # Accepted
                        σ = copy(η)
                        #energy = energy + ΔE;
                        states[auxs].= σ;
                        #mag[auxs] = sum(σ);
                        #energ[auxs] = energy;
                    else # Rejected, now it is for real
                        σ = copy(σ)
                        states[auxs].= σ;
                        #mag[auxs] = sum(σ);
                        #energ[auxs] = energy;
                        #energy = energy;
                    end
                end
                auxs = auxs + 1;
            end
        end
    # Clean the data
    #states = filter(!iszero,states);
    #energ = filter(!iszero,energ);
    #mag = filter(!iszero,mag);

    return states

    # Save the data
    #save(File(format"JLD",string(path,"/T_",T,nExp,"states.jld")),"states",states)
    #save(File(format"JLD",string(path,"/seeds",step,".jld")),"seeds",setSeeds)
    
end

println("Loaded")

end