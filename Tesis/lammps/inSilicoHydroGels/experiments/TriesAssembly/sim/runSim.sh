#!/bin/bash

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var L 9.99857 -var NCL 45 -var NMO 1455 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 3500000 -var tstep 0.001 -var sstep 10000


cp -r info ..;
cd ..;
mv -f info data/systemTotalFreePhi550NPart1500cCL30ShearRate20RT1_50RT2_100RT3_200RT4_400;
