: '
    Script that create the sge file to perform a shear deformation simulation
'

#!/bin/bash

echo "In the shear se file!!"

dir_shear=$1
filename=$2

# Create directory to save the simulation data
mkdir $dir_shear
mkdir $dir_shear/traj

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
dir_data=$2
dir_system=$3
dir_shear=$4
id=$5
cl_con=$6
shearRate=$7
Nexp=$8

dir_src=$dir_home/src
dir_sim=$dir_src/sim

# HERE CREATE THE CONFIG FILE for shear 
bash $dir_src/docs/create-file_config-shear.sh $dir_home $dir_src $dir_sim $dir_data $dir_shear $id $shearRate $Nexp

# CREATE README and DATA.DAT file
bash $dir_src/docs/create-file_reference.sh $dir_home $dir_src $dir_sim $dir_data $id $cl_con $shearRate $Nexp

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters 

# Load the config file for shear
source $dir_src/docs/load_parameters.sh $dir_src/docs/shear$id-$shearRate-$Nexp.parameters

echo "Finished loading parameters and confi files."

# Simulation of shear
cd $dir_sim

# Wait until the assembly protocol finished

dir_file="$dir_system/data.hydrogel"

# Continuously check if the file exists
while [ ! -e "$dir_file" ]; do
    echo "Waiting for $dir_file to be created..."
    sleep 30  # Wait for 30 second before checking again to reduce CPU usage
done

# Exit the loop once the file exists
echo "$dir_file found! Exiting."

echo "Start the assembly simulation"

/mnt/MD1200A/cferreiro/fvazquez/mylammps/src/lmp_serial -in in.shear.lmp -var temp $T -var damp $damp -var tstep $dt -var shear_rate $var_shearRate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var seed3 $seed3 -var rlxT1 $relaxTime1 -var rlxT2 $relaxTime2 -var rlxT3 $relaxTime3 -var Dir $dir_shear -var dataDir $dir_system -var file6_name ${files_name[5]} -var file7_name ${files_name[6]} -var file8_name ${files_name[7]} -var file9_name ${files_name[8]} -var file10_name ${files_name[9]}
EOF

