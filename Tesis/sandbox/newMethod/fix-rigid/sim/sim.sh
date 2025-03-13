#!/bin/bash

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 3.839648 -var NCL 5 -var NMO 45 -var seed1 1236 -var seed2 4323 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var steps 900 -var stepsheat 100 -var Dir 2025-03-13-172602-phi-0.5-CLcon-0.1-Part-50-shear-0.01-Nexp-2 -var file1_name data_system_assembly.fixf -var file2_name data_stress_assembly.fixf -var file3_name data_clustP_assembly.dumpf -var file4_name traj_assembly.*.dumpf -var file5_name data.hydrogel

mv log.lammps 2025-03-13-172602-phi-0.5-CLcon-0.1-Part-50-shear-0.01-Nexp-2/log_assembly.lammps
env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10 -var rlxT1 250 -var rlxT2 250 -var rlxT3 250 -var Dir 2025-03-13-172602-phi-0.5-CLcon-0.1-Part-50-shear-0.01-Nexp-2 -var file6_name data_system_shear.fixf -var file7_name data_stress_shear.fixf -var file8_name data_clustP_shear.fixf -var file9_name traj_shear.*.dumpf -var file10_name data.firstShear

mv log.lammps 2025-03-13-172602-phi-0.5-CLcon-0.1-Part-50-shear-0.01-Nexp-2/log_shear.lammps
mv 2025-03-13-172602-phi-0.5-CLcon-0.1-Part-50-shear-0.01-Nexp-2 ..; cd ..;
mv 2025-03-13-172602-phi-0.5-CLcon-0.1-Part-50-shear-0.01-Nexp-2 data
