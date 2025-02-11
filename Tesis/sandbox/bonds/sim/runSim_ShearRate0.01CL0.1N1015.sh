#!/bin/bash

mkdir infoPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015;
mkdir dumpPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015;
cd dumpPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 4.807498 -var NCL 50 -var NMO 450 -var seed1 2249 -var seed2 5336 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var Dir infoPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015 -var dumpDir dumpPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015 -var steps 80000 -var stepsheat 20000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 200000 -var rlxT2 200000 -var rlxT3 200000 -var Dir infoPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015 -var dumpDir dumpPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015

mv infoPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015 ..; mv dumpPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015 data/storage/systemTotalFreePhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015/info;
mv -f data.firstShear data/storage/systemTotalFreePhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015/info;
mv -f dumpPhi4500NPart500damp5000T500cCL1000ShearRate100-Nexp1015 data/storage/dumps;
