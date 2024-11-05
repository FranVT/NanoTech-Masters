: '
    Parameters for assembly and shear simualtions
'

#!/bin/bash


# clean the directory from previus simulations
cd sim;
rm -f runSim*;
rm -rf info*;
cd ..; 

## Start the for loop
for var_cCL in 0.03; #0.06 0.1;
do 
for Nexp in 1000; #$(seq 1 15);
do

# Cifras significativas
cs=6;

# Seed for random numbers
seed1=$((1234 + $Nexp)); # Position of CL and MO
seed2=$((4321 + $Nexp)); # Position of Cl and MO
seed3=4321;#$((3124 + $Nexp)); # Langevin Thermostat

# Parameters of the model
# Radii of the main and patch particles
r_Parti=0.5;
r_Patch=0.2;

# Main parameters of the simulation
phi=0.5;
CL_concentration=$var_cCL; #0.1;
N_particles=500;
damp=0.0028; #0.002; #0.05;
T=0.05;

# Number of monomers and cross-linkers given concentration an total amount of patchy particles
N_CL=$(echo "scale=0; $CL_concentration * $N_particles" | bc);
N_CL=${N_CL%.*};
N_MO=$(( $N_particles - $N_CL ));

# Compute the size of the box to get he given packing fraction

# Pi
pi=$(echo "scale=$cs; 4*a(1)" | bc -l);
# Ratio of volume 
f_scl=$(echo "scale=$cs; 4/3" | bc);
# Ghost radius to ensure allocation in the box
r_ghost=$(echo "scale=$cs; $r_Parti + $(echo "scale=$cs; $r_Patch / 2" | bc)" | bc);
r_aux=$(echo "scale=$cs; $r_ghost * $r_ghost * $r_ghost" | bc);

# Compute the volume necesary for all the partilces
Vol_ghost=$(echo "scale=$cs; $f_scl * $pi * $r_ghost" | bc);
Vol_CLg=$(echo "scale=$cs; $Vol_ghost * $N_CL" | bc);
Vol_MOg=$(echo "scale=$cs; $Vol_ghost * $N_MO" | bc);
Vol_Totg=$(echo "scale=$cs; $Vol_CLg + $Vol_MOg" | bc);

# Get the total volume needed taking into account the packing fraction
Vol_Tot=$(echo "scale=$cs; $Vol_Totg / $phi" | bc);
# Translate the volume into length of a box
L_real=$(echo "scale=$cs; e( l($Vol_Tot)/3 )" | bc -l );
# Input parameter for LAMMPS script
L=$(echo "scale=$cs; $L_real / 2" | bc);

# Numerical parameters for LAMMPS simulation
steps=1000000;
tstep=0.001;

## Variables for shear deformation simulation
tstep_defor=0.001;
sstep_defor=10000;

shear_rate=0.01;
max_strain=3;
Nstep_per_strain=$(echo "scale=$cs; $(echo "scale=$cs; 1 / $shear_rate" | bc) * $(echo "scale=$cs; 1 / $tstep_defor" | bc)" | bc) ;
Nstep_per_strain=${Nstep_per_strain%.*};

shear_it=$(( $max_strain * $Nstep_per_strain));

relaxTime1=$(( $max_strain * $Nstep_per_strain ));
relaxTime2=$(( 2 * $relaxTime1)); 
relaxTime3=$(( 2 * $relaxTime2));
relaxTime4=$(( 1 * $Nstep_per_strain));

# Parameters for fix and dumps files
Nsave=10; # Temporal average for fix files
NsaveStress=$(echo "scale=$cs; 1 / $tstep_defor" | bc); # Tmeporal average for stress fix files
NsaveStress=${NsaveStress%.*};
Ndump=100; # Every Ndump time steps save the particles positions.

: '
    Creation of directory for the simulation data
'

## Adapting the variables to be in the directories name
scl=10000;
shear_aux=$(echo "scale=$cs; $scl*$shear_rate" | bc);
shear_aux=${shear_aux%.*};
phi_aux=$(echo "scale=$cs; $scl*$phi" | bc);
phi_aux=${phi_aux%.*};
CL_con=$(echo "scale=$cs; $scl*$CL_concentration" | bc);
CL_con=${CL_con%.*};
damp_aux=$(echo "scale=$cs; $scl*$damp" | bc);
damp_aux=${damp_aux%.*};
T_aux=$(echo "scale=$cs; $scl*$T" | bc);
T_aux=${T_aux%.*};

dir_name=""systemTotalFreePhi"${phi_aux}"NPart"${N_particles}"damp"${damp_aux}"T"${T_aux}"cCL"${CL_con}"ShearRate"${shear_aux}"-Nexp"${Nexp}";


## Create the directory
cd data/storage;
mkdir -p ${dir_name};

: '
    Create README file and parameters files 
'

cd ${dir_name};

## Create the README.md file
file_name="README.md";

touch $file_name;
echo -e "# Parameters of the simulation\n\n" >> $file_name;
echo -e "## Model and System parameters\n" >> $file_name;
echo -e ""- Packing fraction: "${phi}" >> $file_name;
echo -e ""- Number of particles: "${N_particles}" >> $file_name;
echo -e ""- Number of Cross-Linkers: "${N_CL}" >> $file_name;
echo -e ""- Number of Monomers: "${N_MO}" >> $file_name;
echo -e ""- Cross-Linker Concentration: "${CL_concentration}" >> $file_name;
echo -e ""- Box Volume: "${Vol_Tot}" [sigma^3]"" >> $file_name;
echo -e ""- Half length of the box: "${L}" [sigma]"" >> $file_name;
echo -e ""- Temperature: "${T}" >> $file_name;
echo -e ""- Damp: "${damp}" >> $file_name;
echo -e "\n ## Assembly System values \n" >> $file_name;
echo -e ""- Time step: "${tstep}" [tau]"" >> $file_name;
echo -e ""- Number of time steps in heating process: "${steps}" >> $file_name;
echo -e ""- Number of time steps in isothermal  process: "${steps}" >> $file_name;
echo -e ""- Save every "${Ndump}" time steps for dumps files"" >> $file_name;
echo -e ""- Save every "${Nsave}" time steps for fix files"" >> $file_name;
echo -e "\n ## Shear Deformation System values \n" >> $file_name;
echo -e ""- Time step: "${tstep_defor}" [tau]"" >> $file_name;
echo -e ""- Shear rate: "${shear_rate}" [1/tau]"" >> $file_name;
echo -e ""- Max deformation per cycle: "${max_strain}" >> $file_name;
echo -e ""- Number of time steps per deformation: "${Nstep_per_strain}" >> $file_name;
echo -e ""- Number of time steps for Relax steps 1: "${relaxTime1}" >> $file_name;
echo -e ""- Number of time steps for Relax steps 2: "${relaxTime2}" >> $file_name;
echo -e ""- Number of time steps for Relax steps 3: "${relaxTime3}" >> $file_name;
echo -e ""- Number of time steps for Relax steps 4: "${relaxTime4}" >> $file_name;
echo -e ""- Save every "${Ndump}" time steps for dumps files"" >> $file_name;
echo -e ""- Save every "${Nsave}" time steps for fix files"" >> $file_name;
echo -e ""- Save every "${NsaveStress}" time steps for Stress fix files"" >> $file_name;

file_name="parameters";

touch $file_name;
echo -e "${phi}" >> $file_name;
echo -e "${N_particles}" >> $file_name;
echo -e "${N_CL}" >> $file_name;
echo -e "${N_MO}" >> $file_name;
echo -e "${CL_concentration}" >> $file_name;
echo -e "${Vol_Tot}" >> $file_name;
echo -e "${L}" >> $file_name;
echo -e "${T}" >> $file_name;
echo -e "${damp}" >> $file_name;
echo -e "${tstep}" >> $file_name;
echo -e "${steps}" >> $file_name;
echo -e "${steps}" >> $file_name;
echo -e "${Ndump}" >> $file_name;
echo -e "${Nsave}" >> $file_name;
echo -e "${tstep_defor}" >> $file_name;
echo -e "${shear_rate}" >> $file_name;
echo -e "${max_strain}" >> $file_name;
echo -e "${Nstep_per_strain}" >> $file_name;
echo -e "${relaxTime1}" >> $file_name;
echo -e "${relaxTime2}" >> $file_name;
echo -e "${relaxTime3}" >> $file_name;
echo -e "${relaxTime4}" >> $file_name;
echo -e "${Ndump}" >> $file_name;
echo -e "${Nsave}" >> $file_name;
echo -e "${NsaveStress}" >> $file_name;

cd ..; cd ..; cd ..;

: '
    Create bash file to run simulation and move info directory to the directory of data/storage
'

cd sim;

# Create the execute bash script
file_name=""runSim_ShearRate"${shear_rate}"CL"${var_cCL}"N"${Nexp}".sh"";
info_name=""infoPhi"${phi_aux}"NPart"${N_particles}"damp"${damp_aux}"T"${T_aux}"cCL"${CL_con}"ShearRate"${shear_aux}"-Nexp"${Nexp}";
dump_name=""dumpPhi"${phi_aux}"NPart"${N_particles}"damp"${damp_aux}"T"${T_aux}"cCL"${CL_con}"ShearRate"${shear_aux}"-Nexp"${Nexp}";

nodes=8;

touch $file_name;
echo -e "#!/bin/bash" >> $file_name;
echo -e "" >> $file_name;
echo -e "mkdir $info_name;" >> $file_name;
echo -e "mkdir $dump_name;" >> $file_name;
#echo -e "cd $info_name; mkdir dumps; cd dumps;" >> $file_name;
echo -e "cd $dump_name; mkdir assembly; mkdir shear; cd ..;" >> $file_name;
echo -e "" >> $file_name;
echo -e "env OMP_RUN_THREADS=1 mpirun -np ${nodes} lmp -sf omp -in in.assembly.lmp -var temp $T -var damp $damp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3  -var tstep $tstep -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var Dir $info_name -var dumpDir $dump_name" -var steps $steps >> $file_name;
echo -e "" >> $file_name;
echo -e "env OMP_RUN_THREADS=1 mpirun -np ${nodes} lmp -sf omp -in in.shear.lmp -var temp $T -var damp $damp -var tstep $tstep_defor -var shear_rate $shear_rate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var seed3 $seed3  -var rlxT1 $relaxTime1 -var rlxT2 $relaxTime2 -var rlxT3 $relaxTime3 -var rlxT4 $relaxTime4 -var Dir $info_name -var dumpDir $dump_name" >> $file_name;
echo -e "" >> $file_name;
echo -e "mv $info_name ..; mv $dump_name ..;" >> $file_name;
echo -e "cd ..;" >> $file_name;
echo -e "mv -f $info_name data/storage/$dir_name/info;" >> $file_name;
echo -e "mv -f $dump_name data/storage/dumps;" >> $file_name;

#echo -e "cd data/storage/$dir_name/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;" >> $file_name;

bash $file_name

cd ..;

echo "Working directory: $(pwd)"
echo "$dir_name"
echo "$T"
echo "$damp"
echo "$N_CL"
echo "$N_MO"
echo "$pi"
echo "$f_scl"
echo "$Vol_ghost"
echo "$Vol_CLg"
echo "$Vol_MOg"
echo "$Vol_Totg"
echo "$Vol_Tot"
echo "$L"
echo "$Nstep_per_strain"
echo "$shear_it"
echo "$Nave"
echo "$relaxTime1"
echo "$relaxTime2"
echo "$relaxTime3"
echo "$relaxTime4"

done
done
