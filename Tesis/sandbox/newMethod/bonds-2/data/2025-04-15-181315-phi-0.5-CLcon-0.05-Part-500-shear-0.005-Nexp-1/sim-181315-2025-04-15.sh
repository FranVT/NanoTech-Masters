#!/bin/bash

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -log log-181315-2025-04-15.lammps -var temp 0.05 -var damp 1 -var L 8.262893 -var NCL 25 -var NMO 475 -var seed1 1235 -var seed2 4322 -var seed3 10  -var tstep 0.001 -var Nsave 100 -var NsaveStress 1000 -var Ndump 1000 -var steps 8000000 -var stepsheat 500000 -var Dir 2025-04-15-181315-phi-0.5-CLcon-0.05-Part-500-shear-0.005-Nexp-1 -var file1_name data_system_assembly.fixf -var file2_name data_stress_assembly.fixf -var file3_name data_clustP_assembly.dumpf -var file4_name traj_assembly.*.dumpf -var file5_name data.hydrogel

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var logname log-181315-2025-04-15.lammps -var temp 0.05 -var damp 1 -var tstep 0.001 -var shear_rate 0.005 -var max_strain 5 -var Nstep_per_strain 200000 -var shear_it 1000000 -var Nsave 100 -var NsaveStress 1000 -var Ndump 1000 -var seed3 10 -var rlxT1 1000000 -var rlxT2 1000000 -var rlxT3 1000000 -var Dir 2025-04-15-181315-phi-0.5-CLcon-0.05-Part-500-shear-0.005-Nexp-1 -var file6_name data_system_shear.fixf -var file7_name data_stress_shear.fixf -var file8_name data_clustP_shear.fixf -var file9_name traj_shear.*.dumpf -var file10_name data.firstShear

mv log-181315-2025-04-15.lammps 2025-04-15-181315-phi-0.5-CLcon-0.05-Part-500-shear-0.005-Nexp-1/log.lammps
mv sim* 2025-04-15-181315-phi-0.5-CLcon-0.05-Part-500-shear-0.005-Nexp-1
mv 2025-04-15-181315-phi-0.5-CLcon-0.05-Part-500-shear-0.005-Nexp-1 ../data;
