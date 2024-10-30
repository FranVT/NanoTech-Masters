#!/bin/bash

mkdir infoPhi550NPart200damp100T50cCL30ShearRate10-Nexp2;
mkdir dumpPhi550NPart200damp100T50cCL30ShearRate10-Nexp2;
cd dumpPhi550NPart200damp100T50cCL30ShearRate10-Nexp2; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.1 -var L 5.108040 -var NCL 6 -var NMO 194 -var seed1 1236 -var seed2 4323 -var seed3 3126  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi550NPart200damp100T50cCL30ShearRate10-Nexp2 -var dumpDir dumpPhi550NPart200damp100T50cCL30ShearRate10-Nexp2

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 0.1 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 6 -var Nstep_per_strain 100000 -var shear_it 600000 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var seed3 3126  -var rlxT1 600000 -var rlxT2 1200000 -var rlxT3 2400000 -var rlxT4 100000 -var Dir infoPhi550NPart200damp100T50cCL30ShearRate10-Nexp2 -var dumpDir dumpPhi550NPart200damp100T50cCL30ShearRate10-Nexp2

mv infoPhi550NPart200damp100T50cCL30ShearRate10-Nexp2 ..; mv dumpPhi550NPart200damp100T50cCL30ShearRate10-Nexp2 ..;
cd ..;
mv -f infoPhi550NPart200damp100T50cCL30ShearRate10-Nexp2 data/storage/systemTotalFreePhi550NPart200damp100T50cCL30ShearRate10-Nexp2/info;
mv -f dumpPhi550NPart200damp100T50cCL30ShearRate10-Nexp2 data/storage/dumps;
