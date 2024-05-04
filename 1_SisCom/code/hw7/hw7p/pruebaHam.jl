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
            t1 = -J*sum(map(r->sys[part[r][1]...]*sum(map(s->sys[last.(part)[r][s]...],1:4)),dom))
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
        energ = sum(first.(fetch_sum))÷2;
        mag = sum(last.(fetch_sum))÷2;
        
        #println("One state")
    return (energ,mag)
end       
    
using Base.Threads
using Random, Distributions

#include("isingModel_functions_parallel.jl")
include("isingModel_parameters_parallel.jl")

sys = wsample(σs,[1-η,η],(Ng,Ng));

# ids with its neighbors
part = idNeighbors(Ng);
#(energ,mag) = computeHamiltonianP(J,B,sys,part,Ng)

Ne = 2^3;
Nstep = 24;
sysE = [[wsample(σs,[1-η,η],(Ng,Ng)) for l∈1:Nstep] for s∈1:Ne];

domExp = 1:Ne;

chunksExpr = Iterators.partition(sysE[1],4)

function hamExpr(J,B,expr,part,Ng)
"""
    Compute the Hamiltonian for each state in a given expriment with N states
"""
    chunksStates = Iterators.partition(expr,length(eachindex(expr)) ÷ Threads.nthreads())
    task = map(chunksStates) do s
        Threads.@spawn map(r->computeHamiltonianP(J,B,r,part,Ng),s)
    end
    fetch_ham = fetch.(task)
    println("One Experiment done")
    return Iterators.flatten(fetch_ham)
end

@time begin
haml = Iterators.flatmap(s->hamExpr(J,B,sysE[s],part,Ng),eachindex(sysE))|>collect
end

"""
println(collect(chunks))

function auxH(J,B,sysE,part,Ng)
    Ne = length(sysE);
    comp = map(l-> map(r->computeHamiltonianP(J,B,sysE[l][r],part,Ng),eachindex(sysE[l])),1:Ne)
    println("chunk done")
    return comp
end


@time begin
    task = map(chunksExp) do s
        Threads.@spawn auxH(J,B,s,part,Ng)
    end
    fetch_ham = fetch.(task)
    nothing
end
"""
