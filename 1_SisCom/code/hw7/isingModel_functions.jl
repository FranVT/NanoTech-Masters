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
function smallSysChange(sys,part,σs,Ng,id)
"""
    Change one spin of the system
"""
        nsys = copy(sys);
        nsys[first(part[id])...] = -sys[first(part[id])...]
        return nsys
end

# Create a change in the system
function rsmallSysChange(sys,part,σs,Ng,id)
"""
    Change one spin of the system
"""
        nsys = copy(sys);
        nsys[first(part[id])...] = rand([-1,1])
        return nsys
end

