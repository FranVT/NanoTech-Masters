#!/bin/bash

mkdir infoPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022;
mkdir dumpPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022;
cd dumpPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 5.848029 -var NCL 50 -var NMO 450 -var seed1 2256 -var seed2 5343 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var Dir infoPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022 -var dumpDir dumpPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022 -var steps 80000 -var stepsheat 20000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 200000 -var rlxT2 200000 -var rlxT3 200000 -var Dir infoPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022 -var dumpDir dumpPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022

mv infoPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022 ..; mv dumpPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022 data/storage/systemTotalFreePhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022/info;
mv -f data.firstShear data/storage/systemTotalFreePhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022/info;
mv -f dumpPhi2500NPart500damp5000T500cCL1000ShearRate100-Nexp1022 data/storage/dumps;
