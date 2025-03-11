#!/bin/bash

mkdir infoPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2;
mkdir dumpPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2;
cd dumpPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 11.677732 -var NCL 150 -var NMO 1350 -var seed1 1236 -var seed2 4323 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var Dir infoPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2 -var dumpDir dumpPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2 -var steps 9000000 -var stepsheat 1000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 10 -var Nstep_per_strain 100000 -var shear_it 1000000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 2500000 -var rlxT2 2500000 -var rlxT3 2500000 -var Dir infoPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2 -var dumpDir dumpPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2

mv infoPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2 ..; mv dumpPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2 data/storage/systemTotalFreePhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2/info;
mv -f data.firstShear data/storage/systemTotalFreePhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2/info;
mv -f dumpPhi5000NPart1500damp5000T500cCL1000ShearRate100-Nexp2 data/storage/dumps;
