: '
    Bash script that runs the simulation. Creates files and more stuff
'

#!/bin/bash

dir_system=$1
dir_src=$2
var_ccL=$3

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters

# Go to the directory in which the files are going to be created 
cd $dir_system;

# Create README file

# Inside the experiment directory
# README.md
file_name="README.md";

touch $file_name;
echo -e "# Parameters of the simulation\n" >> $file_name;
echo -e "## System parameters \n" >> $file_name;
echo -e ""- Packing fraction: "${phi}" >> $file_name;
echo -e ""- Cross-Linker Concentration: "${var_ccL}" >> $file_name;
echo -e ""- Number of particles: "${N_particles}" >> $file_name;
echo -e ""- Temperature: "${T}" >> $file_name;
echo -e ""- Damp: "${damp}" >> $file_name;
echo -e ""- Max deformation per cycle: "${max_strain}" >> $file_name;
echo -e "\n ## Numeric parameters \n" >> $file_name;
echo -e ""- Time step: "${dt}" [tau]"" >> $file_name;
echo -e ""- Number of time steps in heating process: "${steps_heat}" >> $file_name;
echo -e ""- Number of time steps in isothermal  process: "${steps_isot}" >> $file_name;


