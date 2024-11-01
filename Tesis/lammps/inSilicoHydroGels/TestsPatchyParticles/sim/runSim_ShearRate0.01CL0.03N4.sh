#!/bin/bash

mkdir infoPhi600NPart10damp100T50cCL500ShearRate10-Nexp4;
mkdir dumpPhi600NPart10damp100T50cCL500ShearRate10-Nexp4;
cd dumpPhi600NPart10damp100T50cCL500ShearRate10-Nexp4; mkdir assembly; mkdir shear; cd ..;

env OMP_RUN_THREADS=1 mpirun -np 4 lmp -sf omp -in in.assembly.lmp -var temp 0.05 -var damp 0.1 -var L 1.828022 -var NCL 5 -var NMO 5 -var seed1 1238 -var seed2 4325 -var seed3 3128  -var tstep 0.001 -var Nsave 10 -var NsaveStress 1000 -var Ndump 100 -var Dir infoPhi600NPart10damp100T50cCL500ShearRate10-Nexp4 -var dumpDir dumpPhi600NPart10damp100T50cCL500ShearRate10-Nexp4 -var steps 1000000


mv infoPhi600NPart10damp100T50cCL500ShearRate10-Nexp4 ..; mv dumpPhi600NPart10damp100T50cCL500ShearRate10-Nexp4 ..;
cd ..;
mv -f infoPhi600NPart10damp100T50cCL500ShearRate10-Nexp4 data/storage/systemTotalFreePhi600NPart10damp100T50cCL500ShearRate10-Nexp4/info;
mv -f dumpPhi600NPart10damp100T50cCL500ShearRate10-Nexp4 data/storage/dumps;
