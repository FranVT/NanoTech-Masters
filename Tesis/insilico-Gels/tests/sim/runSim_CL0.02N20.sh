#!/bin/bash

mkdir infoPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20;
mkdir dumpPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20;
cd dumpPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 1 -var L 3.217864 -var NCL 1 -var NMO 49 -var seed1 1254 -var seed2 4341 -var seed3 3144 -var steps 1000000 -var tstep 0.001 -var sstep 500 -var Nave 1000 -var Dir infoPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20 -var dumpDir dumpPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20

env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 1 -var tstep 0.001 -var sstep 10000 -var shear_rate 0.01 -var max_strain 2 -var Nstep_per_strain 100000 -var shear_it 200000 -var Nsave 500 -var seed3 3144 -var Nave 1000 -var rlxT1 600000 -var rlxT2 1200000 -var rlxT3 2400000 -var rlxT4 7200000 -var Dir infoPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20 -var dumpDir dumpPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20

mv infoPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20 ..; mv dumpPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20 ..;
cd ..;
mv -f infoPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20 data/storage/systemTotalFreePhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20/info;
mv -f dumpPhi550T50damp1000cCL20NPart50ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp20 data/storage/dumps;