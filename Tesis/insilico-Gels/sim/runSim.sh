#!/bin/bash

rm -f -r info;
mkdir info;
cd info; mkdir dumps; cd dumps;
mkdir assembly; mkdir shear; cd ..; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 4 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 1 -var L 6.932675 -var NCL 10 -var NMO 490 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 1000000 -var tstep 0.001 -var sstep 500 -var Nave 100000


cp -r info ..;
cd ..;
mv -f info data/storage/systemTotalFreePhi550T50damp1000cCL20NPart500ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp2;
cd data/storage/systemTotalFreePhi550T50damp1000cCL20NPart500ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp2/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;
