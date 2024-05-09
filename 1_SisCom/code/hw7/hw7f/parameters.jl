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
Ng = 25;
σs = [-1,1];
η = 0.1;
J = 1;
B = 1;
kb = 1; 
T = [2.3]; #range(start=1.3,stop=3,length=100);

# Parameters for the Metropoli algorithm
"""
    Nsteps:   Number of cicles in the algorithm
    setSeeds: Set of seeds for every step  
"""
Nsteps = 100;

# Parameter for the amount of simulations per termperature
Nexp = 1;

# Set the seed 
seed = 4321;

# Path to save the information
path = string("/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk7p/");

println("Load parameters")
