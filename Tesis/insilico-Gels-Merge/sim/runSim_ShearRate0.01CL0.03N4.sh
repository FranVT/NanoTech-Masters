#!/bin/bash

mkdir infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp4;
mkdir dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp4;
cd dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp4; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.01 -var L 4.640962 -var NCL 4 -var NMO 146 -var seed1 1238 -var seed2 4325 -var seed3 3128  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp4 -var dumpDir dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp4

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.01 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 6 -var Nstep_per_strain 100000 -var shear_it 600000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 3128  -var rlxT1 600000 -var rlxT2 1200000 -var rlxT3 2400000 -var rlxT4 100000 -var Dir infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp4 -var dumpDir dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp4

mv infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp4 ..; mv dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp4 ..;
cd ..;
mv -f infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp4 data/storage/systemTotalFreePhi550NPart150damp10T50cCL30ShearRate10-Nexp4/info;
mv -f dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp4 data/storage/dumps;
