#!/bin/bash

mkdir infoPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105;
mkdir dumpPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105;
cd dumpPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 2.629534 -var NCL 10 -var NMO 90 -var seed1 1339 -var seed2 4426 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105 -var dumpDir dumpPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105 -var steps 800000 -var stepsheat 100000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 2 -var Nstep_per_strain 100000 -var shear_it 200000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 200000 -var rlxT2 200000 -var rlxT3 200000 -var Dir infoPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105 -var dumpDir dumpPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105

mv infoPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105 ..; mv dumpPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105 ..;
cd ..;
mv -f infoPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105 data/storage/systemTotalFreePhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105/info;
mv -f dumpPhi5500NPart100damp5000T500cCL1000ShearRate100-Nexp105 data/storage/dumps;
