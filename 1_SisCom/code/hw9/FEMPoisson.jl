"""
    Script for Finite Element Method For the Poisson Equation in D
"""

using SparseArrays
using LinearAlgebra

## Input Paremeters
W = 1e-6;               # Width of simulation domain
H = 1e-6;               # Hight of simulation domain
XB = 30;                 # Number of bricks in x-direction
YB = 30;                 # Number of bricks in y-direction
# Define the electric potential on the each wall
Vup = 1;
Vdo = 1;
Vl = 2;
Vr = 2;
# constant RHS
f = 1;

##
# Generate the triangular mesh
a = 0;                              # left x-line
b = W;                              # right x-line
c = 0;                              # lower y-line
d = H;                              # upper y-line
TB = XB*YB;                         # Total number of bricks
dx = (b-a)/XB;                      # dx along x-direction
dy = (d-c)/YB;                      # dy along y-direction

TN = (XB+1)*(YB+1);                 # Total number of nodes
TE = 2*TB;                          # Total number of triangular elements

println("Number of nodes: ",TN)
println("Number of elements: ",TN)

# Nodes coordinates
X = zeros(TN);
Y = zeros(TN);
map(1:TN) do s
    X[s] = mod(s-1,XB+1)*dx;
    Y[s] = floor((s-1)/(XB+1))*dy
end

# Create the connections for the elemnts
n = zeros(Int,2*TB,3);
map(1:TB) do s
    n[2*s-1,1] = s+floor(Int,(s-1)/XB);
    n[2*s-1,2] = n[2*s-1,1]+1+(XB+1);
    n[2*s-1,3] = n[2*s-1,1]+1+(XB+1)-1;
    
    n[2*s,1] = s+floor((s-1)/XB);
    n[2*s,2] = n[2*s,1]+1;
    n[2*s,3] = n[2*s,1]+1+(XB+1);
end

## Boundary conditions
BCNOD = append!( findall(isequal(a),X), findall(isequal(b),X), findall(isequal(c),Y), findall(isequal(d),Y) )
BCVAL = append!( Vl*ones(length(findall(isequal(a),X))), Vr*ones(length(findall(isequal(b),X))), Vdo*ones(length(findall(isequal(c),Y))), Vup*ones(length(findall(isequal(d),Y))) )

## K matrix and RHS vector
K = spzeros(TN,TN);
RHS = zeros(TN);

for l ∈ eachindex(1:TE)
    x21 = X[n[l,2]]-X[n[l,1]];
    x31 = X[n[l,3]]-X[n[l,1]];
    x32 = X[n[l,3]]-X[n[l,2]];
    x13 = X[n[l,1]]-X[n[l,3]];
    y12 = Y[n[l,1]]-Y[n[l,2]];
    y21 = Y[n[l,2]]-Y[n[l,1]];
    y31 = Y[n[l,3]]-Y[n[l,1]];
    y23 = Y[n[l,2]]-Y[n[l,3]];
    
    Ae = 0.5*(x21*y31-x31*y21);

    # The matrix
    Me = zeros(3,3);
    Me[1,1] = -(y23^2+x32^2)/(4*Ae);
    Me[1,2] = -(y23*y31+x32*x13)/(4*Ae);
    Me[2,1] = Me[1,2];
    Me[1,3] = -(y23*y12+x32*x21)/(4*Ae);
    Me[3,1] = Me[1,3];
    Me[2,2] = -(y31^2+x13^2)/(4*Ae);
    Me[2,3] = -(y31*y12+x13*x21)/(4*Ae);
    Me[3,2] = Me[2,3];
    Me[3,3] = -(y12^2+x21^2)/(4*Ae);

    # The S vector
    S = zeros(3);
    S[1] = f*Ae/3;
    S[2] = f*Ae/3;
    S[3] = f*Ae/3;

    # Create the K matrix and RHS vector
    for i = 1:3
        for j = 1:3
            K[n[l,i],n[l,j]] = K[n[l,i],n[l,j]]+ Me[i,j];
        end
        RHS[n[l,i]] = RHS[n[l,i]]+ S[i];
    end
end

# Dirichlet Bounary condition
for i = 1:count
    for j = 1:TN
        if j ~= BCNOD[i] 
            RHS[j] = RHS[j]-K[j,BCNOD[i]]*BCVAL[i];
        end
    end
    K[:,BCNOD[i]] = 0;
    K[BCNOD[i],:] = 0;
    K[BCNOD[i],BCNOD[i]] = 1;
    RHS[BCNOD[i]] = BCVAL[i];
end

# Solution
V = K\RHS;

# Generate the solution over a grid 
#[Xgrid,Ygrid] = meshgrid(a:0.01*(b-a):b, c:0.01*(d-c):d);
Xgrid = ones(101).*(a:0.01*(b-a):b)';
Ygrid = ones(1,101).*(c:0.01*(d-c):d);
Vgrid = zeros(101,101);
for i = 1:101
    for j = 1:101
        for e = 1:TE
            x2p = X[n[e,2]]-Xgrid[i,j];
            x3p = X[n[e,3]]-Xgrid[i,j];
            y2p = Y[n[e,2]]-Ygrid[i,j];
            y3p = Y[n[e,3]]-Ygrid[i,j];
            A1 = 0.5*abs(x2p*y3p-x3p*y2p);
                
            x2p = X[n[e,2]]-Xgrid[i,j];
            x1p = X[n[e,1]]-Xgrid[i,j];
            y2p = Y[n[e,2]]-Ygrid[i,j];
            y1p = Y[n[e,1]]-Ygrid[i,j];
            A2 = 0.5*abs(x2p*y1p-x1p*y2p);
                
            x1p = X[n[e,1]]-Xgrid[i,j];
            x3p = X[n[e,3]]-Xgrid[i,j];
            y1p = Y[n[e,1]]-Ygrid[i,j];
            y3p = Y[n[e,3]]-Ygrid[i,j];
            A3 = 0.5*abs(x1p*y3p-x3p*y1p);
                
            x21 = X[n[e,2]]-X[n[e,1]];
            x31 = X[n[e,3]]-X[n[e,1]];
            y21 = Y[n[e,2]]-Y[n[e,1]];
            y31 = Y[n[e,3]]-Y[n[e,1]];
            Ae = 0.5*(x21*y31-x31*y21);
                
            if abs(Ae-(A1+A2+A3)) < 1e-6*Ae   
                 zeta = (y31*(Xgrid[i,j]-X[n[e,1]])-x31*(Ygrid[i,j]-Y[n[e,1]]))/(2*Ae);
                 eta = (-y21*(Xgrid[i,j]-X[n[e,1]])+x21*(Ygrid[i,j]-Y[n[e,1]]))/(2*Ae);
                 sai1=  1-zeta-eta;
                 sai2 = zeta;
                 sai3 = eta;
                 Vgrid[i,j] = sai1*V[n[e,1]]+sai2*V[n[e,2]]+sai3*V[n[e,3]];
            end
        end
    end
end
 

