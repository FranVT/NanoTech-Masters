#!/bin/bash

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var L 3.21784 -var NCL 5 -var NMO 45 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 1500000 -var tstep 0.005 -var sstep 10000

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var tstep 0.001 -var sstep 10000 -var shear_rate 0.01 -var max_strain 12 -var Nstep_per_strain 100000 -var shear_it 1200000 -var Nsave 500 -var seed3 3124 -var Nave 1000 -var rlxT1 100000 -var rlxT2 200000 -var rlxT3 400000 -var rlxT4 800000

cp -r info ..;
cd ..;
mv -f info data/systemTotalFreePhi550CL5MO45ShearRate10RT1_100RT2_200RT3_400RT4_800;
