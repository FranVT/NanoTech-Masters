#!/bin/bash

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -log log-161550-2025-04-08.lammps -var temp 0.05 -var damp 0.5 -var L 3.834426 -var NCL 2 -var NMO 48 -var seed1 1235 -var seed2 4322 -var seed3 10  -var tstep 0.001 -var Nsave 100 -var NsaveStress 1000 -var Ndump 1000 -var steps 80 -var stepsheat 50 -var Dir 2025-04-08-161550-phi-0.5-CLcon-0.05-Part-50-shear-0.01-Nexp-1 -var file1_name data_system_assembly.fixf -var file2_name data_stress_assembly.fixf -var file3_name data_clustP_assembly.dumpf -var file4_name traj_assembly.*.dumpf -var file5_name data.hydrogel

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var logname log-161550-2025-04-08.lammps -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 100 -var NsaveStress 1000 -var Ndump 1000 -var seed3 10 -var rlxT1 10 -var rlxT2 10 -var rlxT3 10 -var Dir 2025-04-08-161550-phi-0.5-CLcon-0.05-Part-50-shear-0.01-Nexp-1 -var file6_name data_system_shear.fixf -var file7_name data_stress_shear.fixf -var file8_name data_clustP_shear.fixf -var file9_name traj_shear.*.dumpf -var file10_name data.firstShear

mv log-161550-2025-04-08.lammps 2025-04-08-161550-phi-0.5-CLcon-0.05-Part-50-shear-0.01-Nexp-1/log.lammps
mv 2025-04-08-161550-phi-0.5-CLcon-0.05-Part-50-shear-0.01-Nexp-1 ../data;
