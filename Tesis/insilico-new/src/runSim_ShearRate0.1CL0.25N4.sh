#!/bin/bash

mkdir infoPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4;
mkdir dumpPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4;
cd dumpPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 6.310732 -var NCL 50 -var NMO 150 -var seed1 1238 -var seed2 4325 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4 -var dumpDir dumpPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4 -var stepsassembly 1000000 -var stepsheat 250000


mv infoPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4 ..; mv dumpPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4 ..;
cd ..;
mv -f infoPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4 data/storage/systemTotalFreePhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4/info;
mv -f dumpPhi2500NPart200damp5000T500cCL2500ShearRate1000-Nexp4 data/storage/dumps;
