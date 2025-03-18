: '
    Script that runs a set of simulations given parameters
'

#!/bin/bash

# Significant decimals
cs=6;

## Loops of parameters
for var_shearRate in 0.1;
do
    for var_ccL in 0.01;
    do
        for Nexp in 1;
        do
            # Parameters for the simulation
            seed1=$((1234 + Nexp));     # MO positions
            seed2=$((4321 + Nexp));     # CL positions
            seed3=10;                   # Langevin thermostat
            nodes=8;                    # CPU nodes for omp variable

            # System parameters
            phi=0.5;
            CL_con=$var_ccL;
            N_particles=150;
            shear_rate=$var_shearRate;
            damp=0.5;
            T=0.05;
            max_strain=1;

            # Numeric parameters
            dt=0.001;
            steps_heat=500000; # Steps for the heating process
            steps_isot=8000000; # Steps for the percolation process 
            Nsave=100;           # Steps for temporal average of the fix files
            Ndump=1000;           # Save each Ndump steps info of dump file
            relaxTime1=1000000; # Relax time steps for the first period.
            relaxTime2=1000000;
            relaxTime3=1000000;
            Vol_MO1=4.49789;
            Vol_CL1=4.80538;

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

            # Derive numeric parameters
            NsaveStress=$(echo "scale=$cs; 1 / $dt" | bc); 
            NsaveStress=${NsaveStress%.*};  # Steps for temporal average if the fix file for stress (Virial Stress)
            Nstep_per_strain=$(echo "scale=$cs; $(echo "scale=$cs; 1 / $shear_rate" | bc) * $(echo "scale=$cs; 1 / $dt" | bc)" | bc) ;
            Nstep_per_strain=${Nstep_per_strain%.*};    # Number of steps to deform 1 strain.
            shear_it=$(( $max_strain * $Nstep_per_strain)); # Total number of steps to achive the max strain parameter.

            # Directory stuff
            dir_name="$(date +%F-%H%M%S)-phi-${phi}-CLcon-${CL_con}-Part-${N_particles}-shear-${shear_rate}-Nexp-${Nexp}" ;
            files_name=(
                        "data_system_assembly.fixf" 
                        "data_stress_assembly.fixf"
                        "data_clustP_assembly.dumpf"
                        "traj_assembly.*.dumpf"
                        "data.hydrogel"
                        "data_system_shear.fixf" 
                        "data_stress_shear.fixf"
                        "data_clustP_shear.fixf"
                        "traj_shear.*.dumpf"
                        "data.firstShear"
                        );


            # Create the directory in the sim directory with README.md file with parameters and .dat file
            cd sim; mkdir ${dir_name}; cd ${dir_name}; mkdir imgs; mkdir traj;

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

            touch $file_name;
            echo -e "main-directory,"${dir_name}"" >> $file_name;
            echo -e "states-dir,traj" >> $file_name;
            echo -e "imgs-dir,imgs" >> $file_name;
            echo -e "log-of-assembly,log_assembly.lammps" >> $file_name;
            echo -e "log-of-assembly,log_assembly.lammps" >> $file_name;
            for i in "${!files_name[@]}"; do
                echo -e "file"$i","${files_name[$i]}"" >> $file_name;
            done
            echo -e "phi,"${phi}"" >> $file_name;
            echo -e "CL-Con,"${CL_con}"" >> $file_name;
            echo -e "Npart,"${N_particles}"" >> $file_name;
            echo -e "Shear-rate,"${shear_rate}"" >> $file_name;
            echo -e "Temperature,"${T}"" >> $file_name;
            echo -e "damp,"${damp}"" >> $file_name;
            echo -e "Max-strain,"${max_strain}"" >> $file_name;
            echo -e "time-step,"${dt}"" >> $file_name;
            echo -e "N_heat,"${steps_heat}"" >> $file_name;
            echo -e "N_isot,"${steps_isot}"" >> $file_name;
            echo -e "N_def,"${Nstep_per_strain}"" >> $file_name;
            echo -e "N_rlx1,"${relaxTime1}"" >> $file_name;
            echo -e "N_rlx2,"${relaxTime2}"" >> $file_name;
            echo -e "N_rlx3,"${relaxTime3}"" >> $file_name;
            echo -e "N_CL,"${N_CL}"" >> $file_name;
            echo -e "N_MO,"${N_MO}"" >> $file_name;
            echo -e "Vol_CL,"${Vol_CL1}"" >> $file_name;
            echo -e "Vol_MO,"${Vol_MO1}"" >> $file_name;
            echo -e "Vol_box,"${Vol_Tot}"" >> $file_name;
            echo -e "L,"${L}"" >> $file_name;
            echo -e "save-dump,"${Ndump}"" >> $file_name;
            echo -e "save-fix,"${Nsave}"" >> $file_name;
            echo -e "save-stress,"${NsaveStress}"" >> $file_name;
            
            # Bash script for the simulation
            cd ..;

            file_name="sim.sh";
            rm -f $file_name;
            touch $file_name;
            echo -e "#!/bin/bash" >> $file_name;
            echo -e "" >> $file_name;
            echo -e "env OMP_RUN_THREADS=1 mpirun -np ${nodes} lmp -sf omp -in in.assembly.lmp -var temp $T -var damp $damp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3  -var tstep $dt -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var steps $steps_isot -var stepsheat $steps_heat -var Dir $dir_name -var file1_name ${files_name[0]} -var file2_name ${files_name[1]} -var file3_name ${files_name[2]} -var file4_name ${files_name[3]} -var file5_name ${files_name[4]}" >> $file_name;
            echo -e "" >> $file_name;
            echo -e "mv log.lammps $dir_name/log_assembly.lammps" >> $file_name;
            echo -e "env OMP_RUN_THREADS=1 mpirun -np ${nodes} lmp -sf omp -in in.shear.lmp -var temp $T -var damp $damp -var tstep $dt -var shear_rate $shear_rate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var seed3 $seed3 -var rlxT1 $relaxTime1 -var rlxT2 $relaxTime2 -var rlxT3 $relaxTime3 -var Dir $dir_name -var file6_name ${files_name[5]} -var file7_name ${files_name[6]} -var file8_name ${files_name[7]} -var file9_name ${files_name[8]} -var file10_name ${files_name[9]}" >> $file_name;
            echo -e "" >> $file_name;
            echo -e "mv log.lammps $dir_name/log_shear.lammps" >> $file_name;
            echo -e "mv $dir_name ..; cd ..;" >> $file_name;
            echo -e "mv $dir_name data" >> $file_name;

            bash $file_name;

            cd ..;

            echo "Work directory: $(pwd)"
            echo "Data directory: $dir_name"
            echo "$(pwd)/$dir_name"

        done
    done
done
