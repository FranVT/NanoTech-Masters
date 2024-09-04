"""
    Script with the parameters for the simulation
"""

## Variables for assembly simulation

N_particles = 2*1250;
CL_concentration = 0.10;

L = 2*9;
N_CL = round(Int,CL_concentration*N_particles);
N_MO = N_particles - N_CL;

steps = 1500000;
tstep = 0.005;
sstep = 10000;

seed1 = 1234;
seed2 = 4321;
seed3 = 3124;

## Variables for shear deformation simulation
tstep_defor = 0.001;
sstep_defor = 10000;

shear_rate = 0.02;
max_strain = 12;
Nstep_per_strain = round(Int,(1/shear_rate)*(1/tstep_defor));
shear_it = max_strain*Nstep_per_strain;
Nsave = 500;
Nave = round(Int,1/tstep_defor);



