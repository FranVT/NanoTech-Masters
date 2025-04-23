: '
    Create a sge file that runs a assembly protocol and creates a shear sge file.
'

#!/bin/bash

dir_home=$1
dir_src=$2
dir_sim=$3
dir_data=$4
id=$5
cl_con=$6

# Directories
dir_system="$dir_data/system-$id-CL$cl_con"
# Create directory to save the simulation data
mkdir $dir_system

# Create the sge file for the numerical simulation
filename="system-$id-CL$cl_con.sge"

# Create the new script with a template
cat > "$filename" << 'EOF'
# SGE file to run the assembly and create sge files for the shear simulations

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

# Recieve the outer parameters
dir_home=$1
dir_src=$2
dir_sim=$3
dir_data=$4
dir_system=$5
id=$6
cl_con=$7

# HERE CREATE THE CONFIG FILE for assembly
bash $dir_src/docs/create-file_config-assembly.sh $dir_home $dir_src $dir_sim $dir_data $id $var_ccL

# Load the parameters file
chmod +x $dir_src/docs/load_parameters.sh
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters 

# Load the config file for assembly
chmod +x $dir_src/docs/load_parameters.sh
source $dir_src/docs/load_parameters.sh $dir_src/docs/assembly$id-$cl_con.parameters

# Run the assembly
cd $dir_sim
/mnt/MD1200A/cferreiro/fvazquez/mylammps/src/lmp_serial -in in.assembly.lmp -var temp $T -var damp $damp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3  -var tstep $dt -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var steps $steps_isot -var stepsheat $steps_heat -var Dir "$dir_system" -var file1_name ${files_name[0]} -var file2_name ${files_name[1]} -var file3_name ${files_name[2]} -var file4_name ${files_name[3]} -var file5_name ${files_name[4]};

cd $dir_src/docs
# Create the sge file to run the deformation simulations
for var_shearRate in $(seq $dgamma_o $dgamma_d $dgamma_f);
do
    for N-exp in $seq( $Nexp)
    do
        bash $dir_src/docs/create-file_shear-sge.sh $dir_home $dir_src $dir_sim $dir_data $id $cl_con $var_shearRate $N-exp
        qsub system-$var_ccL.sge
    done
done

EOF

qsub $filename $dir_home $dir_src $dir_sim $dir_data $dir_system $id $var_ccL

