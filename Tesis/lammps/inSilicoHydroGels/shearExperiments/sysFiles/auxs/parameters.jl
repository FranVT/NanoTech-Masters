"""
    Script with the parameters for the simulation
"""

## Variables for assembly simulation
"""
    |    |    |    |
    phi:           Packing fraction
    r_Parti:       Radius of central particle [sigma]
"""

phi = 0.9;
CL_concentration = 0.10;

L = 9.5;
L_real = 2*L;
Vol_box = L_real^3;

Vol_Ptot = phi*Vol_box;
Vol_CLT = CL_concentration*Vol_Ptot;
Vol_MOT = Vol_Ptot - Vol_CLT;

r_Parti = 0.5;
r_Patch = 0.4;
r_separ = r_Parti;
Vol_Parti = 4/3*pi*r_Parti^3;
Vol_Patch = 4/3*pi*r_Patch^3;
Vol_dif = pi/(12*r_separ)*(r_Parti+r_Patch-r_separ)^2*(r_separ^2+2*r_separ*r_Patch-3*r_Patch^2+2*r_separ*r_Parti+6*r_Patch*r_Parti-3*r_Parti^2); 

Vol_CL = Vol_Parti + 4*(Vol_Patch - Vol_dif);
Vol_MO = Vol_Parti + 2*(Vol_Patch - Vol_dif);

N_CL = round(Int64,Vol_CLT/Vol_CL);
N_MO = round(Int64,Vol_MOT/Vol_MO);
N_particles = N_MO + N_CL;

phi_N = (N_CL*Vol_CL + N_MO*Vol_MO)/Vol_box;

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

## Directory and files names
af = 100000;
dir_system = string("system",round(Int64,af*phi),round(Int64,af*CL_concentration),round(Int64,af*shear_rate),round(Int64,af*L))

assemblyFiles_names = (
                       "energy_assembly.fixf",
                       " "
                      );

shearFiles_names = (
                        "energy_shear.fixf",
                        "stressVirial_shear.fixf",
                    );

files = (assemblyFiles_names,shearFiles_names);

