#!/bin/bash

rm -f -r info;
mkdir info;
cd info; mkdir dumps; cd dumps;
mkdir assembly; mkdir shear; cd ..; cd ..;

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var temp 0.05 -var damp 0.05 -var L 9.998647 -var NCL 90 -var NMO 1410 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 6000000 -var tstep 0.001 -var sstep 10000 -var Nave 1000

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var temp 0.05 -var damp 0.05 -var tstep 0.001 -var sstep 10000 -var shear_rate 0.02 -var max_strain 12 -var Nstep_per_strain 50000 -var shear_it 600000 -var Nsave 500 -var seed3 3124 -var Nave 1000 -var rlxT1 150000 -var rlxT2 300000 -var rlxT3 600000 -var rlxT4 1200000

cp -r info ..;
cd ..;
mv -f info data/storage/systemTotalFreePhi550T50damp50cCL60NPart1500ShearRate20RT1_150RT2_300RT3_600RT4_1200;
cd data/storage/systemTotalFreePhi550T50damp50cCL60NPart1500ShearRate20RT1_150RT2_300RT3_600RT4_1200/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;
