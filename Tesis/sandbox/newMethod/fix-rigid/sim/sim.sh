#!/bin/bash

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 8.272260 -var NCL 50 -var NMO 450 -var seed1 1236 -var seed2 4323 -var seed3 10  -var tstep  -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var dumpDir  -var steps  -var stepsheat  -var Dir 2025-03-13-154342-phi-0.5-CLcon-0.1-Part-500-shear-0.01-Nexp-2 -var file1_name data_stress_assembly.fixf -var file2_name data_clustP_assembly.dumpf -var file3_name traj_assembly.*.dumpf -var file4_name data.hydrogel -var file5_name data_system_shear.fixf

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep  -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 2500000 -var rlxT2 2500000 -var rlxT3 2500000 -var Dir 2025-03-13-154342-phi-0.5-CLcon-0.1-Part-500-shear-0.01-Nexp-2 -var file1_name data_stress_shear.fixf -var file2_name data_clustP_shear.fixf -var file3_name traj_shear.*.dumpf -var file4_name data.firstShear -var file5_name 

mv  ..; mv  ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f  data/storage/2025-03-13-154342-phi-0.5-CLcon-0.1-Part-500-shear-0.01-Nexp-2/info;
mv -f data.firstShear data/storage/2025-03-13-154342-phi-0.5-CLcon-0.1-Part-500-shear-0.01-Nexp-2/info;
mv -f data.hydrogel data/storage/2025-03-13-154342-phi-0.5-CLcon-0.1-Part-500-shear-0.01-Nexp-2/info;
mv -f  data/storage/dumps;
