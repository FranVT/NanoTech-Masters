#!/bin/bash

mkdir infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp200;
mkdir dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp200;
cd dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp200; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.01 -var L 4.640962 -var NCL 4 -var NMO 146 -var seed1 1434 -var seed2 4521 -var seed3 3324  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp200 -var dumpDir dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp200 -var steps 1000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.01 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 3 -var Nstep_per_strain 100000 -var shear_it 300000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 3324  -var rlxT1 300000 -var rlxT2 600000 -var rlxT3 1200000 -var rlxT4 100000 -var Dir infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp200 -var dumpDir dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp200

mv infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp200 ..; mv dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp200 ..;
cd ..;
mv -f infoPhi550NPart150damp10T50cCL30ShearRate10-Nexp200 data/storage/systemTotalFreePhi550NPart150damp10T50cCL30ShearRate10-Nexp200/info;
mv -f dumpPhi550NPart150damp10T50cCL30ShearRate10-Nexp200 data/storage/dumps;
