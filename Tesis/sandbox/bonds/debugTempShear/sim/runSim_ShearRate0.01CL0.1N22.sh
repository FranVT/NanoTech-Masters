#!/bin/bash

mkdir infoPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22;
mkdir dumpPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22;
cd dumpPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 3.045986 -var NCL 2 -var NMO 23 -var seed1 1256 -var seed2 4343 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var Dir infoPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22 -var dumpDir dumpPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22 -var steps 900000 -var stepsheat 100000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 250000 -var rlxT2 250000 -var rlxT3 250000 -var Dir infoPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22 -var dumpDir dumpPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22

mv infoPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22 ..; mv dumpPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22 data/storage/systemTotalFreePhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22/info;
mv -f data.firstShear data/storage/systemTotalFreePhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22/info;
mv -f dumpPhi5000NPart25damp5000T500cCL1000ShearRate100-Nexp22 data/storage/dumps;
