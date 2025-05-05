"""
    Script to compute the energies of a particle ina infinite box
"""

# Posible values for nx, ny and nz
n_max=5;
n = (1:1:n_max);

# Energy function
function getEnergy(nx,ny,nz)
    return nx.^2 .+ ny.^2 .+ nz.^2
end

# Create the tuples/states
tuples=Iterators.product(n,n,n);

# Get the energy of each state an array with that
states = reshape([ [getEnergy(it...),it] for it in tuples],prod(size(tuples)),1);

# Get the states and degeneracy
sort_states=sort(states,dims=1);

# Take the unique energies
energies = unique(first.(sort_states));

# Get the states and compute the degeneracy
index=map(s-> searchsorted(reduce(vcat,first.(sort_states)),s), energies);
degeneracy=length.(index);

