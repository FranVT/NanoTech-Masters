#!/bin/bash
# Use current working directory
#$ -cwd
#
# Join stdout and stderr
#$ -j yes
#
# Run job through bash shell
#$ -S /bin/bash
# 
# Set the number of nodes for parallel computation
#$ -pe mpich 8
# 
# Job name
# -N Experiment_tries
# 
# Send an email after the job has finished
# -m e
# -M vazqueztf@proton.me
# 
# Modules neede
. /etc/profile.d/modules.sh
# 
# Add modules that you might require:
module load python37/3.7.6 
module load gcc/10.2.0
module load openmpi/gcc/64/1.10.1

/mnt/MD1200B/cferreiro/fbenavides/lammps-2Aug2023/src/lmp_serial -in in.assembly.lmp -var temp 0.05 -var damp 0.5 -var L 11.917153 -var NCL 75 -var NMO 1425 -var seed1 1235 -var seed2 4322 -var seed3 10  -var tstep 0.001 -var Nsave 100 -var NsaveStress 1000 -var Ndump 1000 -var steps 8000000 -var stepsheat 500000 -var Dir 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1 -var file1_name data_system_assembly.fixf -var file2_name data_stress_assembly.fixf -var file3_name data_clustP_assembly.dumpf -var file4_name traj_assembly.*.dumpf -var file5_name data.hydrogel

mv log.lammps 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1/log_assembly.lammps
/mnt/MD1200B/cferreiro/fbenavides/lammps-2Aug2023/src/lmp_serial -in in.shear.lmp -var temp 0.05 -var damp 0.5 -var tstep 0.001 -var shear_rate 0.01 -var max_strain 5 -var Nstep_per_strain 100000 -var shear_it 500000 -var Nsave 100 -var NsaveStress 1000 -var Ndump 1000 -var seed3 10 -var rlxT1 1000000 -var rlxT2 1000000 -var rlxT3 1000000 -var Dir 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1 -var file6_name data_system_shear.fixf -var file7_name data_stress_shear.fixf -var file8_name data_clustP_shear.fixf -var file9_name traj_shear.*.dumpf -var file10_name data.firstShear

mv log.lammps 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1/log_shear.lammps
mv *.sge 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1
mv *.po* 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1
mv *.o* 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1
mv sim-124548-2025-03-27.sh 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1
mv 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1 ..; cd ..;
mv 2025-03-27-124548-phi-0.5-CLcon-0.05-Part-1500-shear-0.01-Nexp-1 data;
