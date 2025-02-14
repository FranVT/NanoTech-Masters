"""
    Script to create a mesh for FEM
"""

using CairoMakie
using LinearAlgebra
using SparseArrays

# Computational parameters
Nx = 2^4+1;
Ny = 2^4+1;
Nel = (2*Nx*Ny)-(2*(Nx+Ny))+2;

# Physical paraemters
xl = 10;
yl = 10;
xf = 3.0;
yf = 2.5;
w = 3;

function source(x,y,xo,yo,σ)
    return exp.(-(sqrt.((x.-xo).^2+(y.-yo).^2).^2)./(2*σ^2))  
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

#jsjs = Iterators.product(1:3,1:3)|>collect;

function createM(ind_el,are_el)
"""
    Create the 
    x3-x2   x1-x3   x2-x1
    y2-y3   y3-y1   y1-y2
"""
    ind_el_x = first.(ind_el);
    ind_el_y = last.(ind_el);

    aux_x = ((3,2),(1,3),(2,1));
    aux_y = reverse.(aux_x);

    dif_x = map(s-> ind_el_x[first(s)]-ind_el_x[last(s)],aux_x);
    dif_y = map(s-> ind_el_y[first(s)]-ind_el_y[last(s)],aux_y);

    M = diagm(map(s->-(dif_y[s]^2 + dif_x[s]^2)/(4*are_el),1:3));

    M[1,2] = -(dif_y[1]*dif_y[2] + dif_x[1]*dif_x[2])/(4*are_el);
    M[1,3] = -(dif_y[1]*dif_y[3] + dif_x[1]*dif_x[3])/(4*are_el);
    M[2,3] = -(dif_y[2]*dif_y[3] + dif_x[2]*dif_x[3])/(4*are_el);

    return Symmetric(M);
end

# Compute the K matrix with M matrix
K = spzeros(Nx^2,Ny^2);
RHS = zeros(Nx^2);

for it_el ∈ 1:size(el)[2]
    ind_el = el[:,it_el];
    nin_el = n_el[:,it_el];

    are_el = 0.5*det([first.(ind_el) last.(ind_el) ones(3)]);
    
    M = createM(ind_el,are_el);

    # Compute the S vector
    S = source_el[:,it_el]*are_el/3;

    # Create the K matrix
    K_ind = Iterators.product(nin_el,nin_el)|>collect;
    M_ind = Iterators.product(1:3,1:3)|>collect;

    map(s->K[K_ind[s]...] = K[K_ind[s]...] + M[M_ind[s]...],eachindex(M_ind))
    map(s->RHS[nin_el[s]] = RHS[nin_el[s]] + S[s],eachindex(nin_el))
end

# Solve the system of equation
V = K\RHS;

# Translate the solution to cartesian coordinates
x_grid = 0:1e-2:xl;
y_grid = 0:1e-2:yl;

X_grid = ones(length(x_grid)).*x_grid';
Y_grid = ones(1,length(y_grid)).*y_grid;
X_mesh = reshape(first.(mesh),length(x_range),length(y_range))';
Y_mesh = reshape(last.(mesh),length(x_range),length(y_range))';

Vgrid = zeros(size(Y_grid));

function A(n,X,Y,X_grid,Y_grid,i,j)
    x2p = X[n[2]]-X_grid[i,j];
    x3p = X[n[3]]-X_grid[i,j];
    y2p = Y[n[2]]-Y_grid[i,j];
    y3p = Y[n[3]]-Y_grid[i,j];
    A1 = 0.5*abs(x2p*y3p-x3p*y2p);

    x2p = X[n[2]]-X_grid[i,j];
    x1p = X[n[1]]-X_grid[i,j];
    y2p = Y[n[2]]-Y_grid[i,j];
    y1p = Y[n[1]]-Y_grid[i,j];
    A2 = 0.5*abs(x2p*y1p-x1p*y2p);

    x1p = X[n[1]]-X_grid[i,j];
    x3p = X[n[3]]-X_grid[i,j];
    y1p = Y[n[1]]-Y_grid[i,j];
    y3p = Y[n[3]]-Y_grid[i,j];
    A3 = 0.5*abs(x1p*y3p-x3p*y1p);
    
    x21 = X[n[2]]-X[n[1]];
    x31 = X[n[3]]-X[n[1]];
    y21 = Y[n[2]]-Y[n[1]];
    y31 = Y[n[3]]-Y[n[1]];
    Ae = 0.5*(x21*y31-x31*y21);

    return (abs(Ae-sum((A1,A2,A3))),Ae,y31,y21,x31,x21)
end

for i = eachindex(x_grid)
    for j = eachindex(y_grid)
        for e = 1:size(el)[2]
            (At,Ae,y31,y21,x31,x21) = A(n_el[:,e],X_mesh,Y_mesh,X_grid,Y_grid,i,j)
            if At < 1e-6*Ae   
                zeta = (y31*(X_grid[i,j]-X_mesh[n_el[1,e]])-x31*(Y_grid[i,j]-Y[n_el[1,e]]))/(2*Ae);
                eta = (-y21*(X_grid[i,j]-X_mesh[n_el[1,e]])+x21*(Y_grid[i,j]-Y[n_el[1,e]]))/(2*Ae);
                sai1=  1-zeta-eta;
                sai2 = zeta;
                sai3 = eta;
                Vgrid[i,j] = sai1*V[n_el[1,e]]+sai2*V[n_el[2,e]]+sai3*V[n_el[3,e]];
           end
        end
    end
end

"""
Vgrid = zeros(size(Y_grid));
for i = eachindex(x_grid)
    for j = eachindex(y_grid)
        for e = 1:TE
            x2p = X[n[e,2]]-X_grid[i,j];
            x3p = X[n[e,3]]-X_grid[i,j];
            y2p = Y[n[e,2]]-Y_grid[i,j];
            y3p = Y[n[e,3]]-Y_grid[i,j];
            A1 = 0.5*abs(x2p*y3p-x3p*y2p);
                
            x2p = X[n[e,2]]-X_grid[i,j];
            x1p = X[n[e,1]]-X_grid[i,j];
            y2p = Y[n[e,2]]-Y_grid[i,j];
            y1p = Y[n[e,1]]-Y_grid[i,j];
            A2 = 0.5*abs(x2p*y1p-x1p*y2p);
                
            x1p = X[n[e,1]]-X_grid[i,j];
            x3p = X[n[e,3]]-X_grid[i,j];
            y1p = Y[n[e,1]]-Y_grid[i,j];
            y3p = Y[n[e,3]]-Y_grid[i,j];
            A3 = 0.5*abs(x1p*y3p-x3p*y1p);
                
            x21 = X[n[e,2]]-X[n[e,1]];
            x31 = X[n[e,3]]-X[n[e,1]];
            y21 = Y[n[e,2]]-Y[n[e,1]];
            y31 = Y[n[e,3]]-Y[n[e,1]];
            Ae = 0.5*(x21*y31-x31*y21);
                
            if abs(Ae-(A1+A2+A3)) < 1e-6*Ae   
                 zeta = (y31*(X_grid[i,j]-X[n[e,1]])-x31*(Y_grid[i,j]-Y[n[e,1]]))/(2*Ae);
                 eta = (-y21*(X_grid[i,j]-X[n[e,1]])+x21*(Y_grid[i,j]-Y[n[e,1]]))/(2*Ae);
                 sai1=  1-zeta-eta;
                 sai2 = zeta;
                 sai3 = eta;
                 Vgrid[i,j] = sai1*V[n[e,1]]+sai2*V[n[e,2]]+sai3*V[n[e,3]];
            end
        end
    end
end
"""



#meshGraph3 = plot()
#map(s->plot!(meshGraph3,el_dt[s],label=false),eachindex(el_dt))
#map(s->plot!(meshGraph3,el_ut[s],label=false),eachindex(el_ut))
#scatter!(meshGraph3,mesh,markersize=1)