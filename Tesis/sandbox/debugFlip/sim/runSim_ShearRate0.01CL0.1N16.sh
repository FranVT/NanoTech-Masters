#!/bin/bash

mkdir infoPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16;
mkdir dumpPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16;
cd dumpPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 2.129109 -var NCL 1 -var NMO 9 -var seed1 1250 -var seed2 4337 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var Dir infoPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16 -var dumpDir dumpPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16 -var steps 9000 -var stepsheat 1000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 2 -var Nstep_per_strain 100000 -var shear_it 200000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 2500 -var rlxT2 2500 -var rlxT3 2500 -var Dir infoPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16 -var dumpDir dumpPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16

mv infoPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16 ..; mv dumpPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16 data/storage/debugSwap5500NPart10damp5000T500cCL1000ShearRate100-Nexp16/info;
mv -f data.firstShear data/storage/debugSwap5500NPart10damp5000T500cCL1000ShearRate100-Nexp16/info;
mv -f data.hydrogel data/storage/debugSwap5500NPart10damp5000T500cCL1000ShearRate100-Nexp16/info;
mv -f dumpPhi5500NPart10damp5000T500cCL1000ShearRate100-Nexp16 data/storage/dumps;
