: '
    Bash script that runs the simulation. Creates files and more stuff
'

#!/bin/bash

dir_src=$1
dir_shear=$2
id=$3
var_ccL=$4
var_shearRate=$5

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters

# Load the assembly config file
source $dir_src/docs/load_parameters.sh $dir_src/docs/assembly$id-$var_ccL.parameters

# Load the shear config file
source $dir_src/docs/load_parameters.sh $dir_src/docs/shear$id-$var_shearRate.parameters

# Go to the directory in which the files are going to be created 
cd $dir_shear;

# Create README file

# Inside the experiment directory
# README.md
file_name="README.md";

touch $file_name;
echo -e "# Parameters of the simulation\n" >> $file_name;
echo -e "## System parameters \n" >> $file_name;
echo -e ""- Packing fraction: "${phi}" >> $file_name;
echo -e ""- Cross-Linker Concentration: "${var_ccL}" >> $file_name;
echo -e ""- Number of particles: "${N_particles}" >> $file_name;
echo -e ""- Shear rate: "${var_shearRate}" [1/tau]"" >> $file_name;
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
headers+=("id")
values+=("${id}")

headers+=("data-directory")
values+=("${dir_data}")

headers+=("shear-directory")
values+=("${dir_shear}")

headers+=("states-dir")
values+=("traj")

headers+=("imgs-dir")
values+=("imgs")

for i in "${!files_name[@]}"; do
    headers+=("file$i")
    values+=("${files_name[$i]}")
done

headers+=("phi")
values+=("${phi}")

headers+=("CL-Con")
values+=("${var_ccL}")

headers+=("Npart")
values+=("${N_particles}")

headers+=("Shear-rate")
values+=("${var_shearRate}")

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

