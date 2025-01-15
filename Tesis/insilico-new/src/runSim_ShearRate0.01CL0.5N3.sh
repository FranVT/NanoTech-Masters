#!/bin/bash

mkdir infoPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3;
mkdir dumpPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3;
cd dumpPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 1.556360 -var NCL 3 -var NMO 3 -var seed1 1237 -var seed2 4324 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3 -var dumpDir dumpPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3 -var stepsassembly 250000 -var stepsheat 250000


mv infoPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3 ..; mv dumpPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3 ..;
cd ..;
mv -f infoPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3 data/storage/systemTotalFreePhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3/info;
mv -f dumpPhi5000NPart6damp5000T500cCL5000ShearRate100-Nexp3 data/storage/dumps;
