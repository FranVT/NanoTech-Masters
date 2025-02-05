: '
   Script to run the simulation
'

#!/bin/bash

# Seed for random numbers
seed1=1234; # Position of CL and MO
seed2=4321; # Position of Cl and MO
seed3=10; # Langevin Thermostat

damp=0.5;
T=0.05;

L=6;
N_CL=5;
N_MO=5;

tstep=0.001;
Nsave=10;
NsaveStress=100;
Ndump=10;

steps=500000;
stepsheat=1000000;

info_name=""infoSysNCL"${N_CL}"NMO"${N_MO}";
dump_name=""dumpSysNCL"${N_CL}"NMO"${N_MO}";

dir_name=""debugSysNCL"${N_CL}"NMO"${N_MO}"Nexp7"";

nodes=4;

## Create the directory
cd data/storage;
rm -rf ${dir_name}; 
mkdir -p ${dir_name};

: '
    Create README file and parameters files 
'

cd ${dir_name};
mkdir imgs;

## Create the README.md file
file_name="README.md";

touch $file_name;
echo -e "# Parameters of the simulation\n\n" >> $file_name;
echo -e "## Model and System parameters\n" >> $file_name;
echo -e ""- Number of Cross-Linkers: "${N_CL}" >> $file_name;
echo -e ""- Number of Monomers: "${N_MO}" >> $file_name;
echo -e ""- Half length of the box: "${L}" [sigma]"" >> $file_name;
echo -e ""- Temperature: "${T}" >> $file_name;
echo -e ""- Damp: "${damp}" >> $file_name;
echo -e "\n ## Assembly System values \n" >> $file_name;
echo -e ""- Time step: "${tstep}" [tau]"" >> $file_name;
echo -e ""- Number of time steps in heating process: "${stepsheat}" >> $file_name;
echo -e ""- Number of time steps in isothermal  process: "${steps}" >> $file_name;
echo -e ""- Save every "${Ndump}" time steps for dumps files"" >> $file_name;
echo -e ""- Save every "${Nsave}" time steps for fix files"" >> $file_name;
echo -e ""- Save every "${NsaveStress}" time steps for Stress fix files"" >> $file_name;


file_name="parameters";

touch $file_name;
echo -e "${N_CL}" >> $file_name;
echo -e "${N_MO}" >> $file_name;
echo -e "${L}" >> $file_name;
echo -e "${T}" >> $file_name;
echo -e "${damp}" >> $file_name;
echo -e "${tstep}" >> $file_name;
echo -e "${stepsheat}" >> $file_name;
echo -e "${steps}" >> $file_name;
echo -e "${Ndump}" >> $file_name;
echo -e "${Nsave}" >> $file_name;
echo -e "${NsaveStress}" >> $file_name;

cd ..; cd ..; cd ..;

echo $(pwd)

cd sim;

mkdir ${info_name}
mkdir ${dump_name}

cd ${dump_name}; mkdir assembly; cd ..;

echo $(pwd)

env OMP_RUN_THREADS=1 mpirun -np ${nodes} lmp -sf omp -in in.assembly -var temp $T -var damp $damp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3  -var tstep $tstep -var Nsave $Nsave -var NsaveStress $NsaveStress -var Ndump $Ndump -var Dir $info_name -var dumpDir $dump_name -var steps $steps -var stepsheat $stepsheat;

mv ${info_name} ..;
mv ${dump_name} ..;
mv data.* ..;
cd ..; 

mv ${info_name} data/storage/$dir_name/info;
mv ${dump_name} data/storage/$dir_name/dumps;
mv data.* data/storage/$dir_name/info;



