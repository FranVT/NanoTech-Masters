"""
    Assigment 6 - Monte Carlo Methods

    Use a Monte-Caro algorithm to approximate the value of pi.
    Plot the error in this approximation as the number of random samples is increased from 10 to 10e6.
"""

using Random, Distributions
using Plots, LaTeXStrings

# Set the backend from graphs
gr()

# Set the seed
Random.seed!(4321)

# Set parameters
"""
    r:      Radius of the circle
    Ns:     Number of samples
    srng:     Sample range 
    spdf:   Sample probability function
"""
r = 1;
Ns = 2^8;
srng  = round.(Int,range(start=10,stop=1e6,length=Ns));
spdf = Uniform(-1,1);

# Evaluate the random varaibles
X = map(s->rand(spdf,s),srng);
Y = map(s->rand(spdf,s),srng);

# Take the radius
R = map(s->(X[s].^2 .+ Y[s].^2),1:1:Ns);

# Get the estimated value of pi
Pi = map(s->sum(R[s].<=r.^2)/srng[s],1:1:Ns ).*4; 

# Plot of the error
ge = plot()
plot!(ge,abs.(pi.-Pi))

# Plot the estimation
gp = plot()
plot!(gp,Pi)


