

using Base.Threads
using Distributed
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

# Compue the energy
@everywhere function computeEnergyPmap(J,B,sys,part,Ng)
    """
        Compute the energy given an arrange of a grid with spins and neigbor lists
    """
        dom = eachindex(sys);
        t1 = sum(pmap(r->sys[part[r][1]...]*sum(pmap(s->sys[last.(part)[r][s]...],(1,3))),dom));
        t2 = sum(pmap(r->sys[part[r][1]...],dom));
        return (-J*t1, B*t2)
end

@everywhere function computeHamiltonianThreads(J,B,sys,part,Ng)
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
            t1 = -J*sum(map(r->sys[part[r][1]...]*sum(map(s->sys[last.(part)[r][s]...],(1,3))),dom))
            t2 = -B*sum(map(r->sys[part[r][1]...],dom))
            #println(dom," finish")
            return (t1,t2)
        end

        # Domain of particles
        domPart = 1:Ng^2;
        
        # Chunks are the domains partitions
        println(Threads.nthreads())
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

Ng = 2^7;
sys = wsample([-1,1],[0.5,0.5],(Ng,Ng));
part = idNeighbors(Ng);

nworkers()
nprocs()
println("Parallel map")
@time begin
    energPmap = computeEnergyPmap(1,1,sys,part,Ng)
end

nworkers()
nprocs()
println("Threads scheme")
@time begin
    energThreads = computeHamiltonianThreads(1,1,sys,part,Ng)
end

nworkers()
nprocs()
println("Combo")
@time begin
    pmap(s->computeHamiltonianThreads(1,1,sys,part,Ng),1:4,distributed=true)
end
