"""
    Assigment 6
    Asymmetric Simple Exlusion Process
"""

# Packages and stuff
using Random, Distributions
using FileIO, JLD

# Set the path to save the data
path = "/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk6";

# Setting the sead and the random number generator
Random.seed!(4321)

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
parms = (Nb,η,Np,α,β,ϕ);

# Discretize the values
"""
    dx:     Spatial interval (Can be interpreted as particle size)
    dt:     Temporal interval
    Nt:     Time Steps
"""
dx = 1;
dt = 1e-2;
Nt = 500;
values = (dx,dt,Nt);

# Save parameters and stuff 
save(File(format"JLD",string(path,"/parameters.jld")),"parms",parms);
save(File(format"JLD",string(path,"/values.jld")),"values",values);

function propagation(Nb,η,Np,α,β,ϕ,dx,dt,Nt)

# Initial position
"""
    σ:      State 
"""
σ = wsample([0,1],[1-η,η],Nb);
save(File(format"JLD",string(path,"/state_0.jld")),"σ",σ);

# Allocate mamory for the current
j_p = zeros(Nt);
j_n = zeros(Nt);

for it = 1:Nt

# Get location of the particles
"""
    loc:    Location of the particles 
    aux1:   New location if all particles move forward 
    aux2:   New location if all particles move backward
"""
loc = findall(s->s==1,σ);

aux1 = copy(loc) .+ 1;
aux2 = copy(loc) .- 1;

# Apply Boundary Conditions
aux1[aux1.>Nb].=1;
aux2[aux2.<1].=Nb;

# Know if the particles can move forward or backward.
"""
    cmf:    Particles that can move forward 
    cmb:    Particles that can move backward 
    cm:     Particales that can move forward and backward. 
"""
cmf = setdiff(aux1,loc) .- 1;
cmb = setdiff(aux2,loc) .+ 1;

# Apply Boundary Conditions
cmb[cmb.>Nb].=1;
cmf[cmf.<1].=Nb;

cm = cmf∩cmb;

# Clear values
cmf = setdiff(cmf,cm);
cmb = setdiff(cmb,cm);

# Assign te probabilities and steps 
"""
    First it is assigned the probability and step for the particles that can move forward and backward, due to a higher degrees of freedom.
    Then the backward and forward taking into account the exclusion principle.

    Δ:      The movement of the particles.
    pf:     New position of particles that move forward
    pb:     New position of particles that move backward 
"""
# Probability of going forward or backward 
Δ1 = wsample([-1,0,1],[β*dt,1-(β+α)*dt,α*dt],length(cm));

# Update the particle position
ncm = cm .+ Δ1;

# Actualize the list of particles that can move forward and backward 
cmf = setdiff(cmf,ncm);
cmb = setdiff(cmb,ncm);

# Probability of going forward 
Δ2 = wsample([0,1],[1-α*dt,α*dt],length(cmf));
# Update particle position 
ncmf = cmf .+ Δ2;

# Probability of going backward 
Δ3 = wsample([-1,0],[β*dt,1-β*dt],length(cmb));
# Update particle position 
ncmb = cmb .+ Δ3;

# Apply Boundary Conditions
ncmf[ncmf.>Nb].=1;
ncmb[ncmb.<1].=Nb;

# Apply Boundary Conditions
ncm[ncm.>Nb].=1;
ncm[ncm.<1].=Nb;

# Count the numer of particles that move.
j_p[it] = sum(isone.(Δ2)) + sum(isone.(Δ1));
j_n[it] = (length(cmb)-sum(iszero.(Δ3))) + (length(cm)-sum(iszero.(Δ1))-sum(isone.(Δ1)));
                                        
# Update the state
σ = copy(σ);
σ[union(cm,cmf,cmb)].=0;
σ[union(ncm,ncmf,ncmb)].=1;

# Save the new state
save(File(format"JLD",string(path,"/state_",it,".jld")),"σ",σ);

end

# Save the currents
save(File(format"JLD",string(path,"/j_p.jld")),"j_p",j_p);
save(File(format"JLD",string(path,"/j_n.jld")),"j_n",j_n);

end

propagation(parms...,values...)
