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

            # Derived parameters
            N_CL=$(echo "scale=0; $CL_con * $N_particles" | bc);
            N_CL=${N_CL%.*};
            N_MO=$(( $N_particles - $N_CL ));
            Vol_MO=$(echo "scale=$cs; 4.624581 * $N_MO" | bc);         # Vol of N f=2 patchy particles
            Vol_CL=$(echo "scale=$cs; 5.060372 * $N_CL" | bc);          # Vol of N f=4 patchy particles 
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




        done
    done
done
