"""
    Assigment 6
    Asymmetric Simple Exlusion Process
"""

# Packages and stuff
using Plots, Random, Distributions

# Setting the sead and the random number generator

rgn = Random.Xoshiro(1234);

# Define the parameters
"""
    Nb:     Number of boxes
    η:      Packing fraction
    Np:     Number of particles
    α:      Rate to move forward
    β:      Rate to move backward
    ϕ:      Possible change 
"""
Nb = 10;
η = 3/4;
Np = ceil(Int64,η*Nb);
α = 3;
β = 2;
ϕ = [-1,0,1];

# Discretize the values
"""
    dx:      Spatial interval (Can be interpreted as particle size)
    dt:      Temporal intervlal
"""
dx = 1;
dt = 1e-2;

# Physical space
space = zeros(Np,1);

# Initial position
"""
    σ:      State 
"""
σ = wsample([0,1],[1-η,η],Nb);


# Get the probabilities of change place
"""
   ids:     Ids of the particles
   aux1:    Ids of particles that move forward
   aux2:    Ids of particles that move backward
   mf:      Particles that can move forward 
   mb:      Particles that can move backward
"""
ids = findall(s->s==1,σ);
aux1 = ids.+1;
aux2 = ids.-1;

# Periodic boundary condition
aux1[aux1.>Nb].=1;
aux2[aux2.<1].=Nb;

mf = setdiff(aux1,ids).-1;
# Periodic Boundary condition
mf[mf.<1].=Nb;

mb = setdiff(aux2,ids).+1;
# Periodic boundary condition
mb[mb.>Nb].=1;

# Define the probabilities for each particles 
"""
    mfb:    Particles that can move forward and backward
    mf:     Particles that can move forward 
    mb:     PArticles that can move backward
"""
mfb = intersect(mf,mb);
mf = setdiff(mf,mfb);
mb = setdiff(mb,mfb);

# Assign the step 
fb = wsample([-1 0 1],[β*dt,1-(β+α)*dt,α*dt],length(mfb));
f = wsample([0 1],[1-α*dt,α*dt],length(mf));
b = wsample([-1 0],[β*dt,1-β*dt],length(mb));


"""
aux1 = copy(σ);
aux2 = copy(σ);
permute!(aux1,append!([Nb],collect(1:Nb-1)));
permute!(aux2,append!(collect(2:Nb),[1]));
pjf = α*dt*iszero.(aux1-σ);
pjb = β*dt*iszero.(aux2-σ);
pnj = 1.-(pjf+pjb);
"""
