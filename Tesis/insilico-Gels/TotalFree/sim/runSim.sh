#!/bin/bash

rm -f -r info;
mkdir info;
cd info; mkdir dumps; cd dumps;
mkdir assembly; mkdir shear; cd ..; cd ..;

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var Temp 0.05 -var damp 0.1 -var L 9.998647 -var NCL 270 -var NMO 1230 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 6000000 -var tstep 0.001 -var sstep 10000 -var Nave 1000

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var Temp 0.05 -var damp 0.1 -var tstep 0.001 -var sstep 10000 -var shear_rate 0.02 -var max_strain 12 -var Nstep_per_strain 50000 -var shear_it 600000 -var Nsave 500 -var seed3 3124 -var Nave 1000 -var rlxT1 300000 -var rlxT2 600000 -var rlxT3 1200000 -var rlxT4 2400000

cp -r info ..;
cd ..;
mv -f info data/storage/systemTotalFreePhi550T50damp100cCL180NPart1500ShearRate20RT1_300RT2_600RT3_1200RT4_2400;
cd data/storage/systemTotalFreePhi550T50damp100cCL180NPart1500ShearRate20RT1_300RT2_600RT3_1200RT4_2400/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;
