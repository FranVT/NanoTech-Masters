: '
    Script that runs a set of simulations given parameters
'

#!/bin/bash

# Significant decimals
cs=6;

## Loops of parameters
for var_shearRate in 0.01;
do
    for var_ccL in 0.1;
    do
        for Nexp in 2;
        do
            # Parameters for the simulation
            seed1=$((1234 + Nexp));     # MO positions
            seed2=$((4321 + Nexp));     # CL positions
            seed3=10;                   # Langevin thermostat

            # System parameters
            phi=0.5;
            CL_con=$var_ccL;
            N_particles=500;
            shear_rate=$var_shearRate;
            damp=0.5;
            T=0.05;
            max_strain=1;

            # Numeric parameters
            dt=0.001;
            steps_heat=1000000; # Steps for the heating process
            steps_isot=9000000; # Steps for the percolation process 
            Nsave=10;           # Steps for temporal average of the fix files
            Ndump=10;           # Save each Ndump steps info of dump file
            relaxTime1=2500000; # Relax time steps for the first period.
            relaxTime2=2500000;
            relaxTime3=2500000;
            Vol_MO1=4.624581;
            Vol_CL1=5.060372;

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
            dir_name="$(date +%F)-phi-${phi}-CLcon-${CL_con}-Part-${N_particles}-shear-${shear_rate}-Nexp-${Nexp}" ;


            # Create the directory in the sim directory with README.md file with parameters and .dat file
            cd sim; mkdir ${dir_name}; cd ${dir_name}; mkdir imgs;

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
            





        done
    done
done
