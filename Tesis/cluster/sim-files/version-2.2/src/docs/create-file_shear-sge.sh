: '
    Script that create the sge file to perform a shear deformation simulation
'

#!/bin/bash

echo "In the shear se file!!"

dir_home=$1
dir_src=$2
dir_sim=$3
dir_data=$4
dir_system=$5
id=$6
cl_con=$7
shearRate=$8
Nexp=$9

dir_shear=$dir_system/"shear-$id-shearRate$shearRate-Nexp$Nexp"
filename="shear-$id-shearRate$shearRate-exp$Nexp.sge"

# Create directory to save the simulation data
mkdir $dir_shear

# Create the new script with a template
cat > "$filename" << 'EOF'
# SGE script as a reference

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
#$ -pe mpich 1
#
# Job name
# -N experiment
#
# Modules needed
. /etc/profile.d/modules.sh
#
# Add modules that you might require:
module load python37/3.7.6;
module load gcc/10.2.0;
module load openmpi/gcc/64/1.10.1;

echo "Running the shear.sge file"

# Recieve outer parameters
dir_home=$1
dir_src=$2
dir_sim=$3
dir_data=$4
dir_system=$5
dir_shear=$6
id=$7
cl_con=$8
shearRate=$9
Nexp=$10


# HERE CREATE THE CONFIG FILE for shear 
bash $dir_src/docs/create-file_config-shear.sh $dir_home $dir_src $dir_sim $dir_data $id $shearRate $Nexp

# CREATE README and DATA.DAT file
bash $dir_src/docs/create-file_reference.sh $dir_home $dir_src $dir_sim $dir_data $id $cl_con $shearRate $Nexp

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters 

# Load the config file for shear
source $dir_src/docs/load_parameters.sh $dir_src/docs/shear$id-$shearRate-$Nexp.parameters

echo "Finished loading parameters and confi files."

# Simulation of shear
cd $dir_sim

echo "Start the assembly simulation"

/mnt/MD1200A/cferreiro/fvazquez/mylammps/src/lmp_serial -in in.shear.lmp -var logname $log_name -var temp $T -var damp $damp -var tstep $dt -var shear_rate $var_shearRate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var seed3 $seed3 -var rlxT1 $relaxTime1 -var rlxT2 $relaxTime2 -var rlxT3 $relaxTime3 -var Dir $dir_shear -var dataDir $dir_system -var file6_name ${files_name[5]} -var file7_name ${files_name[6]} -var file8_name ${files_name[7]} -var file9_name ${files_name[8]} -var file10_name ${files_name[9]}
EOF

qsub $filename $dir_home $dir_src $dir_sim $dir_data $dir_system $dir_shear $id $cl_con $shearRate $Nexp

