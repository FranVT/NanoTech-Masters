: '
    Bash script that runs the simulation. Creates files and more stuff
'

#!/bin/bash

chmod +x load_parameters.sh
source ./load_parameters.sh parameters.txt

CL_con=$1
shear_rate=$2
dir_name=$3
Vol_Tot=$4
L=$5

# Create README file

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

# Create the data.dat file
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

