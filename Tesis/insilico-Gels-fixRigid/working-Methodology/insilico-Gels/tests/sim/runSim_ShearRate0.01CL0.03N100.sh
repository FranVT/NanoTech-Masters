#!/bin/bash

mkdir infoPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100;
mkdir dumpPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100;
cd dumpPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.05 -var L 6.798029 -var NCL 15 -var NMO 485 -var seed1 1334 -var seed2 4421 -var seed3 10  -var tstep 0.001 -var Nsave 2 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100 -var dumpDir dumpPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100 -var steps 2000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.05 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 1 -var Nstep_per_strain 100000 -var shear_it 100000 -var Nsave 2 -var NsaveStress 1000 -var Ndump 100 -var seed3 10  -var rlxT1 100000 -var rlxT2 200000 -var rlxT3 200000 -var rlxT4 100000 -var Dir infoPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100 -var dumpDir dumpPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100

mv infoPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100 ..; mv dumpPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100 ..;
cd ..;
mv -f infoPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100 data/storage/systemTotalFreePhi5000NPart500damp500T500cCL300ShearRate100-Nexp100/info;
mv -f dumpPhi5000NPart500damp500T500cCL300ShearRate100-Nexp100 data/storage/dumps;
