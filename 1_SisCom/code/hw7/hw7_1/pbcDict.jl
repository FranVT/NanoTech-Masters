"""
    Script to explore application of periodic boundary conditions using Dicts
"""

include("isingModel_parameters.jl");

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

function dictPBCtuples(Ng)
    # Range
    dom = 1:Ng;

    # Create the tuples
    tuples = [(y,x) for y∈dom, x∈dom]

    # Main maps 
    relation = reshape(Pair.(tuples,tuples),Ng*Ng);

    map(s->(Ng+1,s),dom);

    # Include boundary condition
    xul = Pair.( map(s->(Ng+1,s),1:Ng),map(s->(1,s),1:Ng));
    xbl = Pair.( map(s->(0,s),1:Ng),map(s->(Ng,s),1:Ng));
    yul = Pair.( map(s->(s,Ng+1),1:Ng),map(s->(s,1),1:Ng));
    ybl = Pair.( map(s->(s,0),1:Ng),map(s->(s,Ng),1:Ng));

    append!(relation,xul,xbl,yul,ybl)

    # Converted to dictionary
    return Dict(relation);
end

function idNeighbors2(Ng)
"""
    id:         List of nodes
    auxn:       "Direction" of the neighbors
    Nn:         Number of neighbors
"""
    id = [(x,y) for y∈1:Ng, x∈1:Ng];
    auxn = ((1,0),(0,1));
    Nn = length(auxn);
    Nid = length(id);

    # Assign the neighbors
    neigh = map(r->map(s->id[s].+auxn[r],1:Nid),1:Nn);
    return neigh


end
