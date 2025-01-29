#!/bin/bash

mkdir infoPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114;
mkdir dumpPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114;
cd dumpPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 4.496439 -var NCL 50 -var NMO 450 -var seed1 1348 -var seed2 4435 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114 -var dumpDir dumpPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114 -var steps 8000 -var stepsheat 1000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 2000 -var rlxT2 2000 -var rlxT3 2000 -var Dir infoPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114 -var dumpDir dumpPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114

mv infoPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114 ..; mv dumpPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114 data/storage/systemTotalFreePhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114/info;
mv -f data.firstShear data/storage/systemTotalFreePhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114/info;
mv -f dumpPhi5500NPart500damp5000T500cCL1000ShearRate100-Nexp114 data/storage/dumps;
