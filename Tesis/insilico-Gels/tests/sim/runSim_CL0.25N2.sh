#!/bin/bash

mkdir infoPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2;
mkdir dumpPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2;
cd dumpPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 4 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 1 -var L 3.419491 -var NCL 15 -var NMO 45 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 1000000 -var tstep 0.001 -var sstep 500 -var Nave 1000 -var Dir infoPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2 -var dumpDir dumpPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2

env OMP_RUN_THREADS=1 mpirun -np 4 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 1 -var tstep 0.001 -var sstep 10000 -var shear_rate 0.1 -var max_strain 4 -var Nstep_per_strain 10000 -var shear_it 40000 -var Nsave 500 -var seed3 3124 -var Nave 1000 -var rlxT1 60000 -var rlxT2 120000 -var rlxT3 240000 -var rlxT4 720000 -var Dir infoPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2 -var dumpDir dumpPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2

mv infoPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2 ..; mv dumpPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2 ..;
cd ..;
mv -f infoPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2 data/storage/systemTotalFreePhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2/info;
mv -f dumpPhi550T50damp1000cCL250NPart60ShearRate100RT1_60RT2_120RT3_240RT4_720Nexp2 data/storage/dumps;
