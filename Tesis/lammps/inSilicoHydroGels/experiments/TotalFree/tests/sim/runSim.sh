#!/bin/bash

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var L 9.99857 -var NCL 225 -var NMO 1275 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 2500000 -var tstep 0.001 -var sstep 10000

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var tstep 0.001 -var sstep 10000 -var shear_rate 0.02 -var max_strain 12 -var Nstep_per_strain 50000 -var shear_it 600000 -var Nsave 500 -var seed3 3124 -var Nave 1000 -var rlxT1 50000 -var rlxT2 100000 -var rlxT3 200000 -var rlxT4 400000

cp -r info ..;
cd ..;
mv -f info data/systemTotalFreePhi550CL225MO1275ShearRate20RT1_50RT2_100RT3_200RT4_400;
