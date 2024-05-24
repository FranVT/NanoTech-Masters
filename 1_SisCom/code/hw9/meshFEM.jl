"""
    Script to create a mesh for FEM
"""

# Computational parameters
Nx = 25+1;
Ny = 25+1;

# Physical paraemters
xl = 4;
yl = 4;

# Spatial domain
x_range = range(start=-xl/2,stop=xl/2,length=Nx);
y_range = range(start=-yl/2,stop=yl/2,length=Ny);

# Create tuples with the space
"""
    The index of the array is the number of the node.
"""
mesh = [(s1,s2) for s2∈y_range for s1∈x_range]

# Create the list of the nodes to creates the triangular elements
n_el_dt = first.(Iterators.partition(1:Nx*Ny-Nx,Nx)|>collect)
n_el_ut = last.(Iterators.partition(1:Nx*Ny-Nx,Nx)|>collect)

domsAuxs = map( s->range(start=n_el_dt[s],stop=n_el_ut[s]-1),eachindex(n_el_dt));

el_dt = Iterators.flatmap(l-> map(s-> [mesh[s],mesh[s+1],mesh[s+1+Nx]],domsAuxs[l]),eachindex(domsAuxs) )|>collect;
el_ut = Iterators.flatmap(l-> map(s-> [mesh[s],mesh[s+Nx+1],mesh[s+Nx]],domsAuxs[l]),eachindex(domsAuxs) )|>collect;

meshGraph3 = plot()
scatter!(meshGraph3,mesh,markersize=1)
map(s->plot!(meshGraph3,el_dt[s],label=false),eachindex(jj))
map(s->plot!(meshGraph3,el_ut[s],label=false),eachindex(jj2))
