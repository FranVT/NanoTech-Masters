echo "Running the system.sh file"

# Recieve the outer parameters
dir_sim=$1
dir_src=$2
dir_system=$3
id=$4
var_ccL=$5

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters 

# Load the config file for assembly
source $dir_src/docs/load_parameters.sh $dir_src/docs/assembly$id-$var_ccL.parameters

# Run the assembly
cd $dir_sim
env OMP_RUN_THREADS=1 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var bin_y $bin_y -var temp $T -var damp $damp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3 -var tstep $dt -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var steps $steps_isot -var stepsheat $steps_heat -var Dir $dir_system -var file1_name ${files_name[0]} -var file2_name ${files_name[1]} -var file3_name ${files_name[2]} -var file4_name ${files_name[3]} -var file5_name ${files_name[4]} -var file6_name ${files_name[5]};
