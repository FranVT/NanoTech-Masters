#!/bin/bash

mkdir infoPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58;
mkdir dumpPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58;
cd dumpPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 2.068243 -var NCL 1 -var NMO 9 -var seed1 1234 -var seed2 4321 -var seed3 10  -var tstep 0.001 -var Nsave 1 -var NsaveStress 1000 -var Ndump 1 -var Dir infoPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58 -var dumpDir dumpPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58 -var steps 9000 -var stepsheat 1000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 3 -var Nstep_per_strain 100000 -var shear_it 300000 -var Nsave 1 -var NsaveStress 1000 -var Ndump 1 -var seed3 10  -var rlxT1 2500 -var rlxT2 2500 -var rlxT3 2500 -var Dir infoPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58 -var dumpDir dumpPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58

mv infoPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58 ..; mv dumpPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58 data/storage/debugSwap6000NPart10damp5000T500cCL1000ShearRate100-Nexp58/info;
mv -f data.firstShear data/storage/debugSwap6000NPart10damp5000T500cCL1000ShearRate100-Nexp58/info;
mv -f data.hydrogel data/storage/debugSwap6000NPart10damp5000T500cCL1000ShearRate100-Nexp58/info;
mv -f dumpPhi6000NPart10damp5000T500cCL1000ShearRate100-Nexp58 data/storage/dumps;
