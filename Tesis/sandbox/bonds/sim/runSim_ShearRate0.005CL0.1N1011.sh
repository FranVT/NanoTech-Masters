#!/bin/bash

mkdir infoPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011;
mkdir dumpPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011;
cd dumpPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 4.496439 -var NCL 50 -var NMO 450 -var seed1 2245 -var seed2 5332 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var Dir infoPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011 -var dumpDir dumpPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011 -var steps 80000 -var stepsheat 20000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.005 -var max_strain 1 -var Nstep_per_strain 200000 -var shear_it 200000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 10 -var seed3 10  -var rlxT1 200000 -var rlxT2 200000 -var rlxT3 200000 -var Dir infoPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011 -var dumpDir dumpPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011

mv infoPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011 ..; mv dumpPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011 ..; mv data.hydrogel ..; mv data.firstShear ..
cd ..;
mv -f infoPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011 data/storage/systemTotalFreePhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011/info;
mv -f data.firstShear data/storage/systemTotalFreePhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011/info;
mv -f data.hydrogel data/storage/systemTotalFreePhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011/info;
mv -f dumpPhi5500NPart500damp5000T500cCL1000ShearRate50-Nexp1011 data/storage/dumps;
