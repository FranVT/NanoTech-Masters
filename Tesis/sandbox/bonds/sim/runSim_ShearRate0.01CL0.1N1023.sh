#!/bin/bash

mkdir infoPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023;
mkdir dumpPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023;
cd dumpPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 8.434326 -var NCL 150 -var NMO 1350 -var seed1 2257 -var seed2 5344 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var Dir infoPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023 -var dumpDir dumpPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023 -var steps 9000000 -var stepsheat 1000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 10 -var Nstep_per_strain 100000 -var shear_it 1000000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 2500000 -var rlxT2 2500000 -var rlxT3 2500000 -var Dir infoPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023 -var dumpDir dumpPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023

mv infoPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023 ..; mv dumpPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023 data/storage/systemTotalFreePhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023/info;
mv -f data.firstShear data/storage/systemTotalFreePhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023/info;
mv -f dumpPhi2500NPart1500damp5000T500cCL1000ShearRate100-Nexp1023 data/storage/dumps;
