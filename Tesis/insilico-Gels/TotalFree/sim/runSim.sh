#!/bin/bash

rm -f -r info;
mkdir info;
cd info; mkdir dumps; cd dumps;
mkdir assembly; mkdir shear; cd ..; cd ..;

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var temp 0.05 -var damp 1 -var L 9.998647 -var NCL 30 -var NMO 1470 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 6000000 -var tstep 0.001 -var sstep 10000 -var Nave 1000

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var temp 0.05 -var damp 1 -var tstep 0.001 -var sstep 10000 -var shear_rate 0.0001 -var max_strain 12 -var Nstep_per_strain 10000000 -var shear_it 120000000 -var Nsave 500 -var seed3 3124 -var Nave 1000 -var rlxT1 60000000 -var rlxT2 120000000 -var rlxT3 240000000 -var rlxT4 720000000

cp -r info ..;
cd ..;
mv -f info data/storage/systemTotalFreePhi550T50damp1000cCL20NPart1500ShearRateRT1_60000RT2_120000RT3_240000RT4_720000Nexp1;
cd data/storage/systemTotalFreePhi550T50damp1000cCL20NPart1500ShearRateRT1_60000RT2_120000RT3_240000RT4_720000Nexp1/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;
