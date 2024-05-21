type Mesh
    n_nodes::Int64
    n_elements::Int64
    nodes::Array{Float64, 2}
    internal_nodes::Array{Int64}
    boundary_nodes::Array{Int64}
    elements::Array{Int64, 2}
    Mesh(
         n_nodes::Int64,
         n_elements::Int64,
         nodes::Array{Float64,2},
         internal_nodes::Array{Int64,1},
         boundary_nodes::Array{Int64,1},
         elements::Array{Int64,2}
        ) = new(
                n_nodes,
                n_elements,
                nodes,
                internal_nodes,
                boundary_nodes,
                elements
               )
end

# Quadrature points & weight
const xi = 1/3
const eta = 1/3
const weight = 1/2

# Line 1
phi1(xi,eta) = 1 - xi - eta
const dphi1_dxi = -1.0
const dphi1_deta = -1.0

# Line 2
phi2(xi,eta) = xi
const dphi2_dxi = 1.0
const dphi2_deta = 0.0

# Line 3
phi3(xi,eta) = eta
const dphi3_dxi = 0.0
const dphi3_deta = 1.0

size = mesh.n_nodes - length(mesh.boundary_nodes)
stiff = zeros(size,size)
global_stiff = sparse(temp_stiff)
stiff = zeros(3,3)
gc() # Throw away the full sized array and keep the sparse one
global_load = zeros(size)
load = zeros(3)

# Get element nodes, and their locations
elem_nodes = mesh.elements[elemIdx,:]
x1, y1 = mesh.nodes[elem_nodes[1],:]
x2, y2 = mesh.nodes[elem_nodes[2],:]
x3, y3 = mesh.nodes[elem_nodes[3],:]

# Find the barycentric coordinates
x = x1×phi1(xi,eta) + x2×phi2(xi,eta) + x3×phi3(xi,eta)
y = y1×phi1(xi,eta) + y2×phi2(xi,eta) + y3×phi3(xi,eta)

# Area and some slopes
area = (x1-x3)×(y2-y1) - (x1-x2)×(y3-y1)
dxi_dx, dxi_dy = (y3-y1)/area, -(x3-x1)/area
deta_dx, deta_dy = -(y2-y1)/area, (x2-x1)/area

# Compute Jacobian matrix
j11 = x1×dphi1_dxi  + x2×dphi2_dxi  + x3×dphi3_dxi
j12 = x1×dphi1_deta + x2×dphi2_deta + x3×dphi3_deta
j21 = y1×dphi1_dxi  + y2×dphi2_dxi  + y3×dphi3_dxi
j22 = y1×dphi1_deta + y2×dphi2_deta + y3×dphi3_deta

# And the value of the Jacobian
jacobian = abs(j11*j22 - j12*j21)
Dphi[1,1] = dphi1_dxi×dxi_dx + dphi1_deta×deta_dx
Dphi[1,2] = dphi1_dxi×dxi_dy + dphi1_deta×deta_dy
Dphi[2,1] = dphi2_dxi×dxi_dx + dphi2_deta×deta_dx
Dphi[2,2] = dphi2_dxi×dxi_dy + dphi2_deta×deta_dy
Dphi[3,1] = dphi3_dxi×dxi_dx + dphi3_deta×deta_dx
Dphi[3,2] = dphi3_dxi×dxi_dy + dphi3_deta×deta_dy

for i=1:3
    for j=1:3
        stiff[i,j] = weight * jacobian * (Dphi[i,1]*Dphi[j,1] + Dphi[i,2]*Dphi[j,2])
    end
end

for i=1:3
    pos_i = findin(mesh.internal_nodes, elem_nodes[i])
    if length(pos_i) > 0
        for j=1:3
            pos_j = findin(mesh.internal_nodes, elem_nodes[j])
            if length(pos_j) > 0
                global_stiff[pos_i[1], pos_j[1]] += stiff[i,j]
            end
        end
    end
end

for i=1:3
    load[i] = weight * jacobian * f_ext(x,y) * psi[i]
end

for i=1:3
    pos_i = findin(mesh.internal_nodes, elem_nodes[i])
    if length(pos_i) > 0
        global_load[pos_i[1]] += load[i]
        for j=1:3
            pos_j = findin(mesh.internal_nodes, elem_nodes[j])
            if length(pos_j) < 1
                global_load[pos_i[1]] -= stiff[i,j] * field[elem_nodes[j]]
            end
        end
    end
end

U = global_stiff\global_load