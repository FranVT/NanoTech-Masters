"""
    Assigment 6
    Asymmetric Simple Exlusion Process
"""

# Packages and stuff
using Plots, Random

# Setting the sead and the random number generator
rgn = Random.Xoshiro(1234);

# Define the parameters
"""
    Nb:     Number of boxes
    η:      Packing fraction
    Np:     Number of particles
    α:      Rate to move forward
    β:      Rate to move backward
"""
Nb = 100;
η = 1/10;
Np = Int(η*Nb);
α = 3;
β = 2;

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
wsample([0,1],[1-η,η],Nb);
