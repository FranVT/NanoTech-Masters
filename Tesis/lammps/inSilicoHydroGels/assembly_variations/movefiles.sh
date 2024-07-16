#!/bin/bash

# Script to run lammps with with different values

set -e

files_names=("patchyParticles_assembly.dumpf" "newdata_assembly.dumpf" "voronoiSimple_assembly.dumpf" "vorHisto_assembly.fixf" "energy_assembly.fixf" "sizeCluster_assembly.fixf");
#sims=seq 5
#Nsims=${#sims[@]}
#valL=(10)
#auxarrayL=($(for i in ${valL[@]}; do for in ${sims[@]} do echo -n "$i ";done;done;))
#declare -p auxarrayL;
#seeds1=seq 4 1 Nsims;
#seeds2=seq 2 1 Nsims+4;

#for itt in ${sims[@]}
#do
#    echo 'itt = '${itt}
 #   echo 'Val L = '${auxarrayL[${itt}]}
    #env OMP_RUN_THREADS=2 mpirun -np 6 lmp -sf omp -in in.assembly.lmp -var L 10 -var NCL 50 -var NMO -var seed1 ${seeds1[${itt}]} -var seed2 ${seeds2[${itt}]} -var steps 50000
    #folder=sim${itt}
    #mkdir info/${folder}
    for itf in ${files_names[@]}; do
        mv $itf info
    done
    #cd info/${folder}
    #touch README.md
    #echo -e 'N = 50000\ndt = 0.005\nL = 10\n'${itt} > README.md
    #cd ..
    #cd ..
    #ls
#done

