echo "Running the shear.sh file"

# Recieve outer parameters
dir_sim=$1
dir_src=$2
dir_system=$3
dir_shear=$4
id=$5
var_shearRate=$6
var_N=$7

dir_sim=$dir_src/sim

# Wait until the assembly protocol finished

dir_file="$dir_system/data.hydrogel"

# Continuously check if the file exists
while [ ! -e "$dir_file" ]; do
    echo "Waiting for $dir_file to be created..."
    sleep 30  # Wait for 30 second before checking again to reduce CPU usage
done

# Exit the loop once the file exists
echo "$dir_file found! Exiting."

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters 

# Load the config file for shear
source $dir_src/docs/load_parameters.sh $dir_src/docs/shear$id-$var_shearRate.parameters

# Create the seed for the langevin thermostat
seed3=$(date +%F%H%M%S | tr -d '-' | sed 's/./&+/g; s/+$//' | bc)
seed3=$(( $seed3 + $var_N ))

dir_saveinfo="$dir_shear/Exp$var_N"

echo "Saving info in $dir_saveinfo"

echo "Finished loading parameters and confi files."

# Simulation of shear
cd $dir_sim

echo "Start the shear simulation"

env OMP_RUN_THREADS=1 mpirun -np 4 lmp -sf omp -in in.shear.lmp -var temp $T -var damp $damp -var tstep $dt -var shear_rate $var_shearRate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var seed3 $seed3 -var rlxT1 $relaxTime1 -var rlxT2 $relaxTime2 -var rlxT3 $relaxTime3 -var Dir $dir_saveinfo -var dataDir $dir_system -var file6_name ${files_name[5]} -var file7_name ${files_name[6]} -var file8_name ${files_name[7]} -var file9_name ${files_name[8]} -var file10_name ${files_name[9]}
