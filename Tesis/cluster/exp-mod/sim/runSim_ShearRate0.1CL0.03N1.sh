#!/bin/bash

mkdir infoPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1;
mkdir dumpPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1;
cd dumpPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 5.665158 -var NCL 30 -var NMO 970 -var seed1 1235 -var seed2 4322 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1 -var dumpDir dumpPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1 -var steps 8000000 -var stepsheat 1000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.1 -var max_strain 2 -var Nstep_per_strain 10000 -var shear_it 20000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 2000000 -var rlxT2 2000000 -var rlxT3 2000000 -var Dir infoPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1 -var dumpDir dumpPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1

mv infoPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1 ..; mv dumpPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1 ..;
cd ..;
mv -f infoPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1 data/storage/systemTotalFreePhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1/info;
mv -f dumpPhi5500NPart1000damp5000T500cCL300ShearRate1000-Nexp1 data/storage/dumps;
