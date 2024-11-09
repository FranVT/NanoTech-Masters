#!/bin/bash

mkdir infoPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000;
mkdir dumpPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000;
cd dumpPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 6.798029 -var NCL 15 -var NMO 485 -var seed1 2234 -var seed2 5321 -var seed3 10  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000 -var dumpDir dumpPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000 -var steps 8000000 -var stepsheat 1000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.1 -var max_strain 2 -var Nstep_per_strain 10000 -var shear_it 20000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 20000 -var rlxT2 40000 -var rlxT3 40000 -var rlxT4 10000 -var Dir infoPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000 -var dumpDir dumpPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000

mv infoPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000 ..; mv dumpPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000 ..;
cd ..;
mv -f infoPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000 data/storage/systemTotalFreePhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000/info;
mv -f dumpPhi5000NPart500damp5000T500cCL300ShearRate1000-Nexp1000 data/storage/dumps;
