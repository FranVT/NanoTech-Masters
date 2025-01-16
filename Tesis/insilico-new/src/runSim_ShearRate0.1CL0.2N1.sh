#!/bin/bash

mkdir infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1;
mkdir dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1;
cd dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 10.791198 -var NCL 200 -var NMO 800 -var seed1 1235 -var seed2 4322 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1 -var dumpDir dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1 -var stepsassembly 1000000 -var stepsheat 1000


mv infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1 ..; mv dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1 ..;
cd ..;
mv -f infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1 data/storage/systemTotalFreePhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1/info;
mv -f dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp1 data/storage/dumps;
