#!/bin/bash

# Script to run lammps with with different values

set -e

for itt in 1 3 5
do
    echo 'itt = '${itt}
    folder=nb${itt}
    mkdir ${folder}
done

