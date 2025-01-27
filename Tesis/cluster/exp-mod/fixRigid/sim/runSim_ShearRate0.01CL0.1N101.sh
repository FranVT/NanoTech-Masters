#!/bin/bash

mkdir infoPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101;
mkdir dumpPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101;
cd dumpPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 2.087063 -var NCL 5 -var NMO 45 -var seed1 1335 -var seed2 4422 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101 -var dumpDir dumpPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101 -var steps 8000000 -var stepsheat 1000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 2 -var Nstep_per_strain 100000 -var shear_it 200000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 2000000 -var rlxT2 2000000 -var rlxT3 2000000 -var Dir infoPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101 -var dumpDir dumpPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101

mv infoPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101 ..; mv dumpPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101 ..;
cd ..;
mv -f infoPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101 data/storage/systemTotalFreePhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101/info;
mv -f dumpPhi5500NPart50damp5000T500cCL1000ShearRate100-Nexp101 data/storage/dumps;
