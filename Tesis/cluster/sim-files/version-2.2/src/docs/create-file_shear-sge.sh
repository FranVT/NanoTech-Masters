: '
    Script that create the sge file to perform a shear deformation simulation
'

#!/bin/bash

# Check if a filename is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <new_script_name.sh>"
    exit 1
fi

dir_home=$1
dir_src=$2
dir_sim=$3
dir_data=$4
id=$5
shearRate=$6
N-exp=$7

dir_system="system-$id-CL$cl_con"
filename="system-$id-CL$cl_con.sge"

# Create directory to save the simulation data
mkdir $dir_data/$dir_system

# Create the new script with a template
cat > "$NEW_SCRIPT" << 'EOF'
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

# HERE CREATE THE CONFIG FILE for assembly
bash $dir_src/docs/create-file_config-assembly.sh $dir_home $dir_src $dir_sim $dir_data $id $var_ccL

# Load the parameters file
chmod +x $dir_src/docs/load_parameters.sh
source $dir_src/docs/load_parameters.sh system.parameters 

# Load the config file for assembly
chmod +x $dir_src/docs/load_parameters.sh
source $dir_src/docs/load_parameters.sh assembly$id.parameters

EOF


