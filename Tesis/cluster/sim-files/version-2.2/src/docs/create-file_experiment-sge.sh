: '
    Create a sge file that runs a assembly protocol and creates a shear sge file.
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
cl_con=$6

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

# Run the assembly
/mnt/MD1200A/cferreiro/fvazquez/mylammps/src/lmp_serial -in in.assembly.lmp -var temp $T -var damp $damp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3  -var tstep $dt -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var steps $steps_isot -var stepsheat $steps_heat -var Dir "$dir_system" -var file1_name ${files_name[0]} -var file2_name ${files_name[1]} -var file3_name ${files_name[2]} -var file4_name ${files_name[3]} -var file5_name ${files_name[4]};

# Create the sge file to run the deformation simulations
for var_shearRate in $(seq $dgamma_o $dgamma_d $dgamma_f);
do
    for N-exp in $seq( $Nexp)
    do
        bash $dir_src/docs/create-file_shear-sge.sh $dir_home $dir_src $dir_sim $dir_data $id $var_shearRate $N-exp
        #qsub system-$var_ccL.sge
    done
done

EOF

# qsub $filename $dir_home $dir_src $dir_sim $dir_data $dir_system $id $var_ccL



