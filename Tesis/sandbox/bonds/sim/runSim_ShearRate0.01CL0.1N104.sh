#!/bin/bash

mkdir infoPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104;
mkdir dumpPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104;
cd dumpPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 9.687290 -var NCL 500 -var NMO 4500 -var seed1 1338 -var seed2 4425 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104 -var dumpDir dumpPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104 -var steps 800000 -var stepsheat 100000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 2 -var Nstep_per_strain 100000 -var shear_it 200000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 200000 -var rlxT2 200000 -var rlxT3 200000 -var Dir infoPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104 -var dumpDir dumpPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104

mv infoPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104 ..; mv dumpPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104 ..;
cd ..;
mv -f infoPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104 data/storage/systemTotalFreePhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104/info;
mv -f dumpPhi5500NPart5000damp5000T500cCL1000ShearRate100-Nexp104 data/storage/dumps;
