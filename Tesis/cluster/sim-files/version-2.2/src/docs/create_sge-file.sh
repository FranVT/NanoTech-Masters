: '
    Script that creates the sge file given ALL parameters
    Code created by Deepseek.
    SGe file content created by Fco. Vazquez
'

#!/bin/bash

# Check if a filename is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <new_script_name.sh>"
    exit 1
fi

NEW_SCRIPT="$1"

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
#$ -pe mpich ${nodes}
#
# Job name
# -N Experiment_tries
#
# Send an email after the job has finished
# -m e
# -M vazqueztf@proton.me
#
# Modules needed
. /etc/profile.d/modules.sh
#
# Add modules that you might require:
module load python37/3.7.6;
module load gcc/10.2.0;
module load openmpi/gcc/64/1.10.1;

# Get the parameters from the parameter file
chmod +x load_parameters.sh
source ./load_parameters.sh parameters.txt

    # Assembly parameters
    CL_con=$var_ccL; # The $var_ccL come from the loop'that generates this script.
 
    # Derived parameters
    N_CL=$(echo "scale=0; $CL_con * $N_particles" | bc);
    N_CL=${N_CL%.*};
    N_MO=$(( $N_particles - $N_CL ));
    Vol_MO=$(echo "scale=$cs; $Vol_MO1 * $N_MO" | bc);         # Vol of N f=2 patchy particles
    Vol_CL=$(echo "scale=$cs; $Vol_CL1 * $N_CL" | bc);          # Vol of N f=4 patchy particles 
    Vol_Totg=$(echo "scale=$cs; $Vol_MO + $Vol_CL" | bc);       # Total volume of a mixture of N f=2 and M f=4 patchy particles
    Vol_Tot=$(echo "scale=$cs; $Vol_Totg / $phi" | bc);
    L_real=$(echo "scale=$cs; e( (1/3) * l($Vol_Tot) )" | bc -l );
    L=$(echo "scale=$cs; $L_real / 2" | bc);

    aux=$(echo "scale=0; $CL_con * $N_particles" | bc); aux=${aux%.*};

    # Seed for the langevin thermostat and initial positions
    seed1=$((1234 + aux));     # MO positions
    seed2=$((4321 + aux));     # CL positions
    seed3=$((10 + aux));       # Langevin thermostat

    # Directory configuration
    sys_dir="${id}-phi-${phi}-CLcon-${CL_con}-Part-${N_particles}";

    # Create the directory in the sim directory with README.md file with parameters and .dat file
    mkdir "$dir_data/$sys_dir"; mkdir "$dir_data/$sys_dir/traj";

    # Run the assembly protocol
    cd "$dir_home/sim";
    log_name="log-assembly-$(date +%H%M%S-%F).lammps";


# Run the assembly
/mnt/MD1200A/cferreiro/fvazquez/mylammps/src/lmp_serial -in in.assembly.lmp -log $log_name -var temp $T -var damp $damp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3  -var tstep $dt -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var steps $steps_isot -var stepsheat $steps_heat -var Dir "$dir_data/$sys_dir" -var file1_name ${files_name[0]} -var file2_name ${files_name[1]} -var file3_name ${files_name[2]} -var file4_name ${files_name[3]} -var file5_name ${files_name[4]};

    for var_shearRate in $(seq $dgamma_o $dgamma_d $dgamma_f);
do
        
        # Derive numeric parameters
        Nstep_per_strain=$(echo "scale=$cs; $(echo "scale=$cs; 1 / $var_shearRate" | bc) * $(echo "scale=$cs; 1 / $dt" | bc)" | bc) ;
        Nstep_per_strain=${Nstep_per_strain%.*};    # Number of steps to deform 1 strain.
        shear_it=$(( $max_strain * $Nstep_per_strain)); # Total number of steps to achive the max strain parameter.

        shear_dir="$(date +%F-%H%M%S)-shear-${$var_shearRate}";
        cd ${dir_home};
        mkdir "$dir_data/$sys_dir/$shear_dir";
        cd "$dir_data/$sys_dir/$shear_dir";

    # Create the README and data.dat file in the shear data directry
    bash create_files.sh

        for Nexp in $(seq $Nexp);
        do
            seed3=$((seed3 + Nexp));       # Langevin thermostat

            # Directory stuff
            exp_dir="Nexp-${Nexp}";
            final_dir="$dir_data/$sys_dir/$shear_dir/$exp_dir";

            # Create the directory in the data directory
            cd $dir_home; 
            mkdir "$dir_data/$sys_dir/$shear_dir/$exp_dir";
            mkdir "$dir_data/$sys_dir/$shear_dir/$exp_dir/traj";
            
            log_name="log-shear-Nexp-${Nexp}.lammps";
            cd "$dir_home/sim";
       
            # Run the shear deformatio simulation
            /mnt/MD1200A/cferreiro/fvazquez/mylammps/src/lmp_serial -in in.shear.lmp -var logname $log_name -var temp $T -var damp $damp -var tstep $dt -var shear_rate $var_shearRate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var seed3 $seed3 -var rlxT1 $relaxTime1 -var rlxT2 $relaxTime2 -var rlxT3 $relaxTime3 -var Dir $final_dir -var dataDir $dir_data/$sys_dir -var file6_name ${files_name[5]} -var file7_name ${files_name[6]} -var file8_name ${files_name[7]} -var file9_name ${files_name[8]} -var file10_name ${files_name[9]};
            
            # Move the cluster files to the directory of the shear simulation
            mv $log_name $final_dir;
            mv $file_name.po* $final_dir;
            file_name.o* $final_dir;
        done
done
EOF

# Make the new script executable
chmod +x "$NEW_SCRIPT"

echo "Successfully created executable script: $NEW_SCRIPT"
