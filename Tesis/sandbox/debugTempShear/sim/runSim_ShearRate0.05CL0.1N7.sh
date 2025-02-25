#!/bin/bash

mkdir infoPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7;
mkdir dumpPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7;
cd dumpPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 3.758247 -var NCL 5 -var NMO 45 -var seed1 1241 -var seed2 4328 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var Dir infoPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7 -var dumpDir dumpPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7 -var steps 900000 -var stepsheat 100000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.05 -var max_strain 1 -var Nstep_per_strain 20000 -var shear_it 20000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 250000 -var rlxT2 250000 -var rlxT3 250000 -var Dir infoPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7 -var dumpDir dumpPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7

mv infoPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7 ..; mv dumpPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7 data/storage/systemTotalFreePhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7/info;
mv -f data.firstShear data/storage/systemTotalFreePhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7/info;
mv -f dumpPhi5000NPart50damp5000T500cCL1000ShearRate500-Nexp7 data/storage/dumps;
