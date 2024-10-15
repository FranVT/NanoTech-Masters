#!/bin/bash

rm -f -r info;
mkdir info;
cd info; mkdir dumps; cd dumps;
mkdir assembly; mkdir shear; cd ..; cd ..;

env OMP_RUN_THREADS=2 mpirun -np 3 lmp -sf omp -in in.assemblyShear.lmp -var temp 0.05 -var damp 0.5 -var L 9.998647 -var NCL 30 -var NMO 1470 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 500000 -var tstep 0.001 -var sstep 10000 -var Nave 1000


cp -r info ..;
cd ..;
mv -f info data/storage/systemTotalFreePhi550T50damp500cCL20NPart1500ShearRate20RT1_300RT2_600RT3_1200RT4_3600Nexp1;
cd data/storage/systemTotalFreePhi550T50damp500cCL20NPart1500ShearRate20RT1_300RT2_600RT3_1200RT4_3600Nexp1/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;
