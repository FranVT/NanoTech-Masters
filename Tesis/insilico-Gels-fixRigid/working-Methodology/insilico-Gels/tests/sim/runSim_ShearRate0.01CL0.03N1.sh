#!/bin/bash

mkdir infoPhi550NPart500damp100T50cCL30ShearRate10-Nexp1;
mkdir dumpPhi550NPart500damp100T50cCL30ShearRate10-Nexp1;
cd dumpPhi550NPart500damp100T50cCL30ShearRate10-Nexp1; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.1 -var L 6.932675 -var NCL 15 -var NMO 485 -var seed1 1235 -var seed2 4322 -var seed3 3125  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi550NPart500damp100T50cCL30ShearRate10-Nexp1 -var dumpDir dumpPhi550NPart500damp100T50cCL30ShearRate10-Nexp1 -var steps 1000000

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.1 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 3 -var Nstep_per_strain 100000 -var shear_it 300000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 3125  -var rlxT1 300000 -var rlxT2 600000 -var rlxT3 1200000 -var rlxT4 100000 -var Dir infoPhi550NPart500damp100T50cCL30ShearRate10-Nexp1 -var dumpDir dumpPhi550NPart500damp100T50cCL30ShearRate10-Nexp1

mv infoPhi550NPart500damp100T50cCL30ShearRate10-Nexp1 ..; mv dumpPhi550NPart500damp100T50cCL30ShearRate10-Nexp1 ..;
cd ..;
mv -f infoPhi550NPart500damp100T50cCL30ShearRate10-Nexp1 data/storage/systemTotalFreePhi550NPart500damp100T50cCL30ShearRate10-Nexp1/info;
mv -f dumpPhi550NPart500damp100T50cCL30ShearRate10-Nexp1 data/storage/dumps;
