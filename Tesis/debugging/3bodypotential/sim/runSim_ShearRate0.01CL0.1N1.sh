#!/bin/bash

mkdir infoPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1;
mkdir dumpPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1;
cd dumpPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 5.395600 -var NCL 25 -var NMO 225 -var seed1 1235 -var seed2 4322 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1 -var dumpDir dumpPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1 -var steps 8000000 -var stepsheat 1000000


mv infoPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1 ..; mv dumpPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1 ..;
cd ..;
mv -f infoPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1 data/storage/systemTotalFreePhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1/info;
mv -f dumpPhi5000NPart250damp5000T500cCL1000ShearRate100-Nexp1 data/storage/dumps;
