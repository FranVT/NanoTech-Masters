"""
    Script with all the neccesary parameters for:
        - createInfile.jl
        - createSwapfile.jl
        - createTablePatch.jl
        - createTable.jl
"""

## Parameters of the system
L_box = 10;
N_CL = 50;
N_MO = 450;
T_sys = 0.05;
damp_lg = 0.5;
N_steps = 10000000;
N_saves = 1000;
N_energ = 10;

## Parameters for Lammps commands
L_overlap = 1.0;
N_tries = 5000;
L_neighbor = 1.8;
seed_langevin = 12345;
seed1 = 34512;
seed2 = 31245;
vor_edge = 18;
vor_edgemin = 0;
t_step = 0.005;

## Parameters for table scripts
N_Swap = 50;
N_Patch = 5000000;

# Parameters for table potential
eps_ij = 10.0;
eps_ik = 10.0;
eps_jk = 10.0;
sig = 0.4;
rmin_tp = sig-sig/10;
rmax_tp = 1.499*sig;

# Parameters for threebody/table potential
eps_tbp = 1.0;
rmin_tbp = 0.000001;
rmax_tbp = 5*sig;

## Parameters for the potentials
"""
   m: (CL, MO, PA, PB)
"""
# General
m = (1.0,1.0,0.5,0.5);
diam = (1.0,1.0,0.4,0.4);

# LJ
rcut_CL = round(diam[1]*2^(1/6),digits=2);
rcut_MO = round(diam[2]*2^(1/6),digits=2);

# Patch - Patch
rcut_patch = round(1.5*diam[3],digits=2);

## Parameters for molecule files
# Cl


## Start to create the file
workdir = cd("/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/assembly_variations/")
filename = "in.assembly.lmp";
