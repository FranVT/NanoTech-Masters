"""
    Script with the parameters for the Ising model simulation
"""

# System parameters
"""
    Ng:     Number of nodes in the grid
    σs:     Possible states for the spin
    η:      Percentage of particles with spin up
    J: 
    B: 
    kb:     Bolztamnn constant
    T:      Temperature
"""
Ng = 2^6;
σs = [-1,1];
η = 0.5;
J = 1;
B = 0;
kb = 1;
T = 1;

# Parameters for the Metropoli algorithm
"""
    Nsteps:   Number of cicles in the algorithm
    setSeeds: Set of seeds for every step  
"""
Nsteps = 100;
setSeeds = abs.(rand(Int,Nsteps));

# Path to save the information
path = string("/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk7_1/");
