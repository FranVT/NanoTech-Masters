#!/bin/bash

rm -f -r info;
mkdir info;
cd info; mkdir dumps; cd dumps;
mkdir assembly; mkdir shear; cd ..; cd ..;


env OMP_RUN_THREADS=1 mpirun -np 4 lmp -sf omp -in in.shear.lmp -var temp 0.05 -var damp 1 -var tstep 0.001 -var sstep 10000 -var shear_rate 0.01 -var max_strain 4 -var Nstep_per_strain 100000 -var shear_it 400000 -var Nsave 500 -var seed3 3124 -var Nave 1000 -var rlxT1 600000 -var rlxT2 1200000 -var rlxT3 2400000 -var rlxT4 7200000

cp -r info ..;
cd ..;
mv -f info data/storage/systemTotalFreePhi550T50damp1000cCL20NPart500ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp9;
cd data/storage/systemTotalFreePhi550T50damp1000cCL20NPart500ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp9/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;
