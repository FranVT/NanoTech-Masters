#!/bin/bash

nodes=4;
mpirun -np ${nodes} lmp -in in.assembly 


