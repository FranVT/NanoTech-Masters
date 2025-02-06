#!/bin/bash

mkdir infoPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004;
mkdir dumpPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004;
cd dumpPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 4.999999 -var NCL 50 -var NMO 450 -var seed1 2238 -var seed2 5325 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004 -var dumpDir dumpPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004 -var steps 8000000 -var stepsheat 1000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 200000 -var rlxT2 200000 -var rlxT3 200000 -var Dir infoPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004 -var dumpDir dumpPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004

mv infoPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004 ..; mv dumpPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004 data/storage/systemTotalFreePhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004/info;
mv -f data.firstShear data/storage/systemTotalFreePhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004/info;
mv -f dumpPhi4000NPart500damp5000T500cCL1000ShearRate100-Nexp1004 data/storage/dumps;
