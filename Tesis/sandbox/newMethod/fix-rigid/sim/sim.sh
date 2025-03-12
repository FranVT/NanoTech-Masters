#!/bin/bash

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 8.272260 -var NCL 50 -var NMO 450 -var seed1 1236 -var seed2 4323 -var seed3 10  -var tstep  -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var dumpDir  -var steps  -var stepsheat  -var Dir  -var file1_name data_stress_assembly.fixf

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep  -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 2500000 -var rlxT2 2500000 -var rlxT3 2500000 -var Dir  -var dumpDir 

mv  ..; mv  ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f  data/storage/2025-03-12-144001-phi-0.5-CLcon-0.1-Part-500-shear-0.01-Nexp-2/info;
mv -f data.firstShear data/storage/2025-03-12-144001-phi-0.5-CLcon-0.1-Part-500-shear-0.01-Nexp-2/info;
mv -f data.hydrogel data/storage/2025-03-12-144001-phi-0.5-CLcon-0.1-Part-500-shear-0.01-Nexp-2/info;
mv -f  data/storage/dumps;
