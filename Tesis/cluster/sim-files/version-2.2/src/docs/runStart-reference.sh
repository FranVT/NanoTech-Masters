: '
    Script that runs the assembly procotol once per cross link concentration and the shear protocol Nexp times.
'

#!/bin/bash

# Main Directories
dir_home=$(pwd);
dir_data="$dir_home/data";

echo $dir_home;

# Clean the simulation directory from previus simulations
rm -f "$dir_home/sim/*.sge";

# Significant decimals
cs=6;

# General parameters
nodes=4;                    # CPU nodes for omp variable

damp=1;
T=0.05;
N_particles=10;

# Numeric parameters
dt=0.001;
steps_heat=5; # Steps for the heating process
steps_isot=8; # Steps for the percolation process 
Nsave=1;           # Steps for temporal average of the fix files
NsaveStress=2;
Ndump=1;           # Save each Ndump steps info of dump file

# Volume of the particles
Vol_MO1=4.49789;
Vol_CL1=4.80538;

# Files names of the data
            files_name=(
                        "data_system_assembly.fixf"             # 1 
                        "data_stress_assembly.fixf"             # 2
                        "data_clustP_assembly.dumpf"            # 3
                        "traj_assembly.*.dumpf"                 # 4
                        "data.hydrogel"                         # 5
                        "data_system_shear.fixf"                # 6
                        "data_stress_shear.fixf"                # 7
                        "data_clustP_shear.fixf"                # 8
                        "traj_shear.*.dumpf"                    # 9
                        "data.firstShear"                       # 10
                        );

## Loops of parameters
for var_ccL in 0.5;
do

    # Assembly parameters
    phi=0.5;
    CL_con=$var_ccL;
    
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

    sys_dir="$(date +%F-%H%M%S)-phi-${phi}-CLcon-${CL_con}-Part-${N_particles}";

    # Create the directory in the sim directory with README.md file with parameters and .dat file
    mkdir "$dir_data/$sys_dir"; mkdir "$dir_data/$sys_dir/traj";

    # Run the assembly protocol
    cd "$dir_home/sim";
    log_name="log-assembly-$(date +%H%M%S-%F).lammps";
    /mnt/MD1200A/cferreiro/fvazquez/mylammps/src/lmp_serial -in in.assembly.lmp -log $log_name -var temp $T -var damp $damp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3  -var tstep $dt -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var steps $steps_isot -var stepsheat $steps_heat -var Dir "$dir_data/$sys_dir" -var file1_name ${files_name[0]} -var file2_name ${files_name[1]} -var file3_name ${files_name[2]} -var file4_name ${files_name[3]} -var file5_name ${files_name[4]};

    mv $log_name $sys_dir;

    for var_shearRate in 1;
    do
        
        # Shear parameters
        shear_rate=$var_shearRate;
        max_strain=1;
        relaxTime1=1; # Relax time steps for the first period.
        relaxTime2=1;
        relaxTime3=1;

        # Derive numeric parameters
        Nstep_per_strain=$(echo "scale=$cs; $(echo "scale=$cs; 1 / $shear_rate" | bc) * $(echo "scale=$cs; 1 / $dt" | bc)" | bc) ;
        Nstep_per_strain=${Nstep_per_strain%.*};    # Number of steps to deform 1 strain.
        shear_it=$(( $max_strain * $Nstep_per_strain)); # Total number of steps to achive the max strain parameter.

        shear_dir="$(date +%F-%H%M%S)-shear-${shear_rate}";
        cd ${dir_home};
        mkdir "$dir_data/$sys_dir/$shear_dir";
        cd "$dir_data/$sys_dir/$shear_dir";
      
        # Inside the experiment directory
        # README.md
            file_name="README.md";

            touch $file_name;
            echo -e "# Parameters of the simulation\n" >> $file_name;
            echo -e "## System parameters \n" >> $file_name;
            echo -e ""- Packing fraction: "${phi}" >> $file_name;
            echo -e ""- Cross-Linker Concentration: "${CL_con}" >> $file_name;
            echo -e ""- Number of particles: "${N_particles}" >> $file_name;
            echo -e ""- Shear rate: "${shear_rate}" [1/tau]"" >> $file_name;
            echo -e ""- Temperature: "${T}" >> $file_name;
            echo -e ""- Damp: "${damp}" >> $file_name;
            echo -e ""- Max deformation per cycle: "${max_strain}" >> $file_name;
            echo -e "\n ## Numeric parameters \n" >> $file_name; 
            echo -e ""- Time step: "${dt}" [tau]"" >> $file_name;
            echo -e ""- Number of time steps in heating process: "${steps_heat}" >> $file_name;
            echo -e ""- Number of time steps in isothermal  process: "${steps_isot}" >> $file_name;
            echo -e ""- Number of time steps per deformation: "${Nstep_per_strain}" >> $file_name;
            echo -e ""- Number of time steps for Relax steps 1: "${relaxTime1}" >> $file_name;
            echo -e ""- Number of time steps for Relax steps 2: "${relaxTime2}" >> $file_name;
            echo -e ""- Number of time steps for Relax steps 3: "${relaxTime3}" >> $file_name;
            echo -e "\n ## Derived values from parameters \n" >> $file_name;
            echo -e ""- Number of Cross-Linkers: "${N_CL}" >> $file_name;
            echo -e ""- Number of Monomers: "${N_MO}" >> $file_name;
            echo -e ""- Volume of Cross-Linker: "${Vol_CL1}" [sigma^3]"" >> $file_name; 
            echo -e ""- Volume of Monomer: "${Vol_MO1}" [sigma^3]"" >> $file_name;
            echo -e ""- Box Volume: "${Vol_Tot}" [sigma^3]"" >> $file_name;
            echo -e ""- Half length of the box: "${L}" [sigma]"" >> $file_name;
            echo -e "\n ## Save parameters \n" >> $file_name;
            echo -e ""- Save every "${Ndump}" time steps for dumps files"" >> $file_name;
            echo -e ""- Save every "${Nsave}" time steps for fix files"" >> $file_name;
            echo -e ""- Save every "${NsaveStress}" time steps for Stress fix files"" >> $file_name;
            
            # .dat file
            file_name="data.dat";

            # Initialize arrays to hold headers and values
            headers=()
            values=()

            # Populate headers and values arrays
            headers+=("date")
            values+=("$(date +%F-%H%M%S)")

            headers+=("main-directory")
            values+=("${dir_name}")

            headers+=("states-dir")
            values+=("traj")

            headers+=("imgs-dir")
            values+=("imgs")

            headers+=("log-of-assembly")
            values+=("log_assembly.lammps")

            headers+=("log-of-assembly")
            values+=("log_assembly.lammps")

            for i in "${!files_name[@]}"; do
                headers+=("file$i")
                values+=("${files_name[$i]}")
            done

            headers+=("phi")
            values+=("${phi}")

            headers+=("CL-Con")
            values+=("${CL_con}")

            headers+=("Npart")
            values+=("${N_particles}")

            headers+=("Shear-rate")
            values+=("${shear_rate}")

            headers+=("Temperature")
            values+=("${T}")

            headers+=("damp")
            values+=("${damp}")

            headers+=("Max-strain")
            values+=("${max_strain}")

            headers+=("time-step")
            values+=("${dt}")

            headers+=("N_heat")
            values+=("${steps_heat}")

            headers+=("N_isot")
            values+=("${steps_isot}")

            headers+=("N_def")
            values+=("${Nstep_per_strain}")

            headers+=("N_rlx1")
            values+=("${relaxTime1}")

            headers+=("N_rlx2")
            values+=("${relaxTime2}")

            headers+=("N_rlx3")
            values+=("${relaxTime3}")

            headers+=("N_CL")
            values+=("${N_CL}")

            headers+=("N_MO")
            values+=("${N_MO}")

            headers+=("Vol_CL")
            values+=("${Vol_CL1}")

            headers+=("Vol_MO")
            values+=("${Vol_MO1}")

            headers+=("Vol_box")
            values+=("${Vol_Tot}")

            headers+=("L")
            values+=("${L}")

            headers+=("save-dump")
            values+=("${Ndump}")

            headers+=("save-fix")
            values+=("${Nsave}")

            headers+=("save-stress")
            values+=("${NsaveStress}")

            # Write headers and values to the file
            echo "$(IFS=,; echo "${headers[*]}")" > "$file_name"
            echo "$(IFS=,; echo "${values[*]}")" >> "$file_name"

        for Nexp in $(seq 5);
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
            
            file_name="sim-${shear_dir}-${exp_dir}.sge";
            touch $file_name;
            echo -e "#!/bin/bash" >> $file_name;
            echo -e "# Use current working directory" >> $file_name;
            echo -e "#$ -cwd" >> $file_name;
            echo -e "#" >> $file_name;
            echo -e "# Join stdout and stderr" >> $file_name;
            echo -e "#$ -j yes" >> $file_name;
            echo -e "#" >> $file_name;
            echo -e "# Run job through bash shell" >> $file_name;
            echo -e "#$ -S /bin/bash" >> $file_name;
            echo -e "# " >> $file_name;
            echo -e "# Set the number of nodes for parallel computation" >> $file_name;
            echo -e "#$ -pe mpich ${nodes}" >> $file_name;
            echo -e "# " >> $file_name;
            echo -e "# Job name" >> $file_name;
            echo -e "# -N Experiment_tries" >> $file_name;
            echo -e "# " >> $file_name;
            echo -e "# Send an email after the job has finished" >> $file_name;
            echo -e "# -m e" >> $file_name;
            echo -e "# -M vazqueztf@proton.me" >> $file_name;
            echo -e "# " >> $file_name;
            echo -e "# Modules needed" >> $file_name;
            echo -e ". /etc/profile.d/modules.sh" >> $file_name;
            echo -e "# " >> $file_name;
            echo -e "# Add modules that you might require:" >> $file_name;
            echo -e "module load python37/3.7.6;" >> $file_name;
            echo -e "module load gcc/10.2.0;" >> $file_name;
            echo -e "module load openmpi/gcc/64/1.10.1;" >> $file_name;
            echo -e "" >> $file_name;
            echo -e "/mnt/MD1200A/cferreiro/fvazquez/mylammps/src/lmp_serial -in in.shear.lmp -var logname $log_name -var temp $T -var damp $damp -var tstep $dt -var shear_rate $shear_rate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var seed3 $seed3 -var rlxT1 $relaxTime1 -var rlxT2 $relaxTime2 -var rlxT3 $relaxTime3 -var Dir $final_dir -var dataDir $dir_data/$sys_dir -var file6_name ${files_name[5]} -var file7_name ${files_name[6]} -var file8_name ${files_name[7]} -var file9_name ${files_name[8]} -var file10_name ${files_name[9]};" >> $file_name;
            echo -e "mv $log_name $final_dir;" >> $file_name;
            echo -e "mv $file_name.po* $final_dir;" >> $file_name; 
            echo -e "mv $file_name.o* $final_dir;" >> $file_name;
            echo -e "Fin de un experimento de Shear\n"

            qsub $file_name;
            sleep 2;
        done
        
    done

        cd $dir_home; # Go to the general directory, such that in we can go into sim directory in line 79

done

