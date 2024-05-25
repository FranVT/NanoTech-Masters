"""
    Script to create a mesh for FEM
"""

using CairoMakie

# Computational parameters
Nx = 2^6+1;
Ny = 2^6+1;
Nel = (2*Nx*Ny)-(2*(Nx+Ny))+2;

# Physical paraemters
xl = 10;
yl = 10;
xf = 3.0;
yf = 2.5;
w = 3;

function source(x,y,xo,yo,σ)
    return exp.(-(sqrt.((x.-xo).^2+(y.-yo).^2).^2)./2*σ^2)  
end

# Spatial domain
x_range = range(start=0,stop=xl,length=Nx);
y_range = range(start=0,stop=yl,length=Ny);

# Create tuples with the space
"""
    The index of the array is the number of the node.
"""
mesh = [(s1,s2) for s2∈y_range for s1∈x_range];

# Create the list of the nodes to creates the triangular elements
function createElements(Nx,Ny)
"""
    Function that return triplets of nodes that defines a triangular element.
        n_el_dt:    Auxiliary that represent the initial node
        n_el_ut:    Auxiliary that represent the initial node
        domsAuxs:   Auxiliary that represent the domain of the nodes
        el_dt:      Triplets of nodes that create the down triangles
        el_ut:      Triplets of nodes that create the upper triangles
"""
    n_el_dt = first.(Iterators.partition(1:Nx*Ny-Nx,Nx)|>collect)
    n_el_ut = last.(Iterators.partition(1:Nx*Ny-Nx,Nx)|>collect)

    domsAuxs = map( s->range(start=n_el_dt[s],stop=n_el_ut[s]-1),eachindex(n_el_dt));
    n_el_dt = Iterators.flatmap(l-> map(s-> [s,s+1,s+1+Nx],domsAuxs[l]),eachindex(domsAuxs) )|>collect;
    n_el_ut = Iterators.flatmap(l-> map(s-> [s,s+Nx+1,s+Nx],domsAuxs[l]),eachindex(domsAuxs) )|>collect;

    el_dt = Iterators.flatmap(l-> map(s-> [mesh[s],mesh[s+1],mesh[s+1+Nx]],domsAuxs[l]),eachindex(domsAuxs) )|>collect;
    el_ut = Iterators.flatmap(l-> map(s-> [mesh[s],mesh[s+Nx+1],mesh[s+Nx]],domsAuxs[l]),eachindex(domsAuxs) )|>collect;

    return (stack(append!(n_el_dt,n_el_ut)),stack(append!(el_dt,el_ut)))
end

(n_el,el) = createElements(Nx,Ny);

"""
f = Figure(size=(480,480))
ax = Axis(f[1,1],
    title = "Nodes",
    xlabel = "x",
    ylabel = "y"
)
map(s->triplot!(ax,el[:,s]),1:Nel)
#f
"""
# Evaluate the source in the space
source_eval = source(first.(mesh),last.(mesh),xf,yf,w);

# Evaluate the soruce in the elements
source_el = source(first.(el),last.(el),xf,yf,w);
"""
g = Figure(size=(480,480))
axg = Axis3(g[1,1],
    title = "Nodes",
    xlabel = "x",
    ylabel = "y"
)
map(s->scatter!(axg,first.(el[:,s]),last.(el[:,s]),source_el[:,s]),1:Nel)
#f
"""

jsjs = Iterators.product(1:3,1:3)|>collect;

# Compute the M matrix
ind_el = el[:,1];
are_el = 0.5*det([first.(ind_el) last.(ind_el) ones(3)]);
ind_el_x = first.(ind_el);
ind_el_y = last.(ind_el);

"""
    x3-x2,x1-x3,x2-x1
    y2-y3,y3-y1,y1-y2
"""
aux_x = ((3,2),(1,3),(2,1));
aux_y = reverse.(aux_x);

dif_x = map(s-> ind_el_x[first(s)]-ind_el_x[last(s)],aux_x);
dif_y = map(s-> ind_el_y[first(s)]-ind_el_y[last(s)],aux_y);

M = diagm(map(s->-(dif_y[s]^2 + dif_x[s]^2)/(4*are_el),1:3));

M[1,2] = -(dif_y[1]*dif_y[2] + dif_x[1]*dif_x[2])/(4*are_el);
M[1,3] = -(dif_y[1]*dif_y[3] + dif_x[1]*dif_x[3])/(4*are_el);
M[2,3] = -(dif_y[2]*dif_y[3] + dif_x[2]*dif_x[3])/(4*are_el);

M = Symmetric(M);

# Compute the S vector
S = source_el[:,1]*are_el/3;


#meshGraph3 = plot()
#map(s->plot!(meshGraph3,el_dt[s],label=false),eachindex(el_dt))
#map(s->plot!(meshGraph3,el_ut[s],label=false),eachindex(el_ut))
#scatter!(meshGraph3,mesh,markersize=1)