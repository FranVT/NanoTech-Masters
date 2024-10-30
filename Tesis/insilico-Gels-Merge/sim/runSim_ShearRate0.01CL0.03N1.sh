#!/bin/bash

mkdir infoPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1;
mkdir dumpPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1;
cd dumpPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.1 -var L 9.998647 -var NCL 45 -var NMO 1455 -var seed1 1235 -var seed2 4322 -var seed3 3125  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1 -var dumpDir dumpPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.1 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 6 -var Nstep_per_strain 100000 -var shear_it 600000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 3125  -var rlxT1 600000 -var rlxT2 1200000 -var rlxT3 2400000 -var rlxT4 100000 -var Dir infoPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1 -var dumpDir dumpPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1

mv infoPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1 ..; mv dumpPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1 ..;
cd ..;
mv -f infoPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1 data/storage/systemTotalFreePhi550NPart1500damp100T50cCL30ShearRate10-Nexp1/info;
mv -f dumpPhi550NPart1500damp100T50cCL30ShearRate10-Nexp1 data/storage/dumps;
