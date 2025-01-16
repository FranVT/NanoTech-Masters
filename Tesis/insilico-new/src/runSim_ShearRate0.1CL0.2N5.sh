#!/bin/bash

mkdir infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5;
mkdir dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5;
cd dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 10.791198 -var NCL 200 -var NMO 800 -var seed1 1239 -var seed2 4326 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5 -var dumpDir dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5 -var stepsassembly 1000000 -var stepsheat 1000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.1 -var max_strain 1 -var Nstep_per_strain 10000 -var shear_it 10000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 5000 -var rlxT2 5000 -var rlxT3 5000 -var Dir infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5 -var dumpDir dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5

mv infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5 ..; mv dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5 data/storage/systemTotalFreePhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5/info;
mv -f data.firstShear data/storage/systemTotalFreePhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5/info;
mv -f dumpPhi2500NPart1000damp5000T500cCL2000ShearRate1000-Nexp5 data/storage/dumps;
