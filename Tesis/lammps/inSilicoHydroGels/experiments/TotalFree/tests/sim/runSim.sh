#!/bin/bash

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var L 9.99857 -var NCL 105 -var NMO 1395 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 5000000 -var tstep 0.0005 -var sstep 10000

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var tstep 0.0005 -var sstep 10000 -var shear_rate 0.02 -var max_strain 12 -var Nstep_per_strain 100000 -var shear_it 1200000 -var Nsave 500 -var seed3 3124 -var Nave 2000 -var rlxT1 100000 -var rlxT2 200000 -var rlxT3 400000 -var rlxT4 800000

cp -r info ..;
cd ..;
mv -f info data/systemTotalFreePhi550CL105MO1395ShearRate20RT1_50RT2_100RT3_200RT4_400;
