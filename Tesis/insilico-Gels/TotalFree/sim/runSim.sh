#!/bin/bash

rm -f -r info;
mkdir info;
cd info; mkdir dumps; cd dumps;
mkdir assembly; mkdir shear; cd ..; cd ..;

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var temp 0.05 -var damp 1 -var L 9.998647 -var NCL 30 -var NMO 1470 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 6000000 -var tstep 0.001 -var sstep 10000 -var Nave 100000

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var temp 0.05 -var damp 1 -var tstep 0.00001 -var sstep 10000 -var shear_rate 0.01 -var max_strain 12 -var Nstep_per_strain 10000000 -var shear_it 120000000 -var Nsave 500 -var seed3 3124 -var Nave 100000 -var rlxT1 60000000 -var rlxT2 120000000 -var rlxT3 240000000 -var rlxT4 720000000

cp -r info ..;
cd ..;
mv -f info data/storage/systemTotalFreePhi550T50damp1000cCL20NPart1500ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp1;
cd data/storage/systemTotalFreePhi550T50damp1000cCL20NPart1500ShearRate10RT1_600RT2_1200RT3_2400RT4_7200Nexp1/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;
