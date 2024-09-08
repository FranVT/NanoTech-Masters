"""
    Script with the parameters for the simulation
"""

## Variables for assembly simulation
"""
    |    |    |    |
    phi:           Packing fraction
    r_Parti:       Radius of central particle [sigma]
"""

phi = 0.6;
CL_concentration = 0.05;

N_particles = 2000;
N_CL = round(Int64,CL_concentration*N_particles); #round(Int64,Vol_CLT/Vol_CL);
N_MO = round(Int64,N_particles - N_CL); #round(Int64,Vol_MOT/Vol_MO);
#N_particles = N_MO + N_CL;


r_Parti = 0.5;
r_Patch = 0.4;
r_separ = r_Parti;
Vol_Parti = 4/3*pi*r_Parti^3;
Vol_Patch = 4/3*pi*r_Patch^3;
Vol_dif = pi/(12*r_separ)*(r_Parti+r_Patch-r_separ)^2*(r_separ^2+2*r_separ*r_Patch-3*r_Patch^2+2*r_separ*r_Parti+6*r_Patch*r_Parti-3*r_Parti^2); 

Vol_CL = 4/3*pi*(r_Parti + r_Patch/2); #Vol_Parti + 4*(Vol_Patch - Vol_dif);
Vol_MO = 4/3*pi*(r_Parti + r_Patch/2); #Vol_Parti + 2*(Vol_Patch - Vol_dif);

#Vol_Ptot = phi*Vol_box;
Vol_CLT = N_CL*Vol_CL; #CL_concentration*Vol_Ptot;
Vol_MOT = N_MO*Vol_MO; #Vol_Ptot - Vol_CLT;

Vol_tot = (Vol_MOT + Vol_CLT)/phi;

L_real = round(cbrt(Vol_tot),digits=2);
L = L_real/2;
#L = 12;
#L_real = 2*L;
Vol_box = L_real^3;
Vol_Ptot = phi*Vol_box;

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
cycles = 4;
relaxTime1 = round(Int64,Nstep_per_strain/2);
relaxTime2 = Nstep_per_strain;
relaxTime3 = round(Int64,1.5*Nstep_per_strain);
relaxTime4 = round(Int64,2*Nstep_per_strain);


## Directory and files names
af = 100000;
dir_system = string("systemCL",round(Int64,N_CL),"MO",round(Int64,N_MO),"ShearRate",round(Int64,af*shear_rate),"Cycles",round(Int64,cycles))

assemblyFiles_names = (
                       "energy_assembly.fixf",
                       "bondlenPatch_assembly.fixf",
                       "bondlenCL_assembly.fixf"
                      );

shearFiles_names = (
                        "energy_shear.fixf",
                        "stressVirial_shear.fixf",
                        "bondlenPatch_shear.fixf",
                        "bondlenCL_shear.fixf" 
                      );

files = (assemblyFiles_names,shearFiles_names);

