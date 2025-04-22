cells=$1 #Read the number of cells the hydrogel is replicated
#sigma=$2 We can read sigma from the average calculated of the pore
perc=$2 #Reads the how big will be the insertions with respect to the size of the pore


di=$(pwd)
nodes=4
while read beads; do #Reads from a file how many beads the chains have
  while read phi; do #Reads the packing fraction of the insertions CHECK if it is total or not
    mkdir -p $di/ncells_${cells}/b_${beads}/phi_${phi}/perc_${perc}/ #Creates the directory for running
    cd $di/ncells_${cells}/b_${beads}/phi_${phi}/perc_${perc}/
    cp ${di}/in.insertion .
    cp /mnt/MD1200B/cferreiro/cferreiro/hydrogels/CONFIGS/${cells}_cells/init_hydro_${beads}b.dat .
    cp init_hydro_${beads}b.dat init_SMA.dat
    cp /mnt/MD1200B/cferreiro/cferreiro/hydrogels/Minimize_hydrogel/ncells_${cells}/b_${beads}/hgel.restart.1000000 . #Copy the minimized hydrogel
    sigma=`cat /mnt/MD1200B/cferreiro/cferreiro/hydrogels/CONFIGS/${cells}_cells/ave_${beads}b.dat | awk '{print $1*2}'` #Reads the average size of the pore from the distributions
    echo Sigma $sigma
    echo ave sigma $sigma > data_simulation.dat 
    sigma22=`echo $sigma $perc | awk '{print $1*$2}'` #Calculates the size of the inclusions according to the percentage of the pore
    echo sigma 22 $sigma22 >> data_simulation.dat
    sigma12=`echo $sigma22 | awk '{print ($1+1)/2}'` #Calulates sigma12 insetion/hydrogel beads
    echo sigma 12 $sigma12 >> data_simulation.dat 
    vol=`grep xlo init_hydro* | awk '{print $2^3}'` #Gets the volume occupied by the hydrogel
    natom=`grep atoms init_hydro_* | sed 's/init_hydro_//' | sed 's/b.dat//' | sed 's/:/ /' | sed 's/atoms//'` #gets the number of atoms of the hydrogel
    echo NATOM $natom >> data_simulation.dat
    eta=`echo $natom $vol | awk '{print $1*3.1416/6/($2)}'` #Calculates the packing fraction of the hydrogel
    echo Vol $vol >> data_simulation.dat
    echo eta $eta >> data_simulation.dat
    ncol=`echo $vol $phi $eta $sigma22 | awk '{ printf("%.0f\n", 6*$1*($2-$3)/(3.1416*$4^3)); }'` #Calculates the number of insertions according to their calculated size and the packing fraction we defined
    echo ncol $ncol >> data_simulation.dat
    co12=`echo 'e(l(2)*(1.0/6.0))*'$sigma12''| bc -l` #Calculated the cut-off of the WCA for the insertions by calculating 2^1/6*sigma22
    co22=`echo 'e(l(2)*(1.0/6.0))*'$sigma22''| bc -l` #Calculated the cut-off for the interaction hydrogel/insertion

    echo "#!/bin/bash">> launch.sh
    echo "#$ -S /bin/bash">> launch.sh
    echo "#$ -N NB_${beads}_eta${phi}" >> launch.sh
    echo "#$ -pe mpich ${nodes}" >> launch.sh
    echo "#$ -cwd" >> launch.sh
    echo "#$ -j yes" >> launch.sh
    echo "" >> launch.sh
    echo ". /etc/profile.d/modules.sh">> launch.sh
    echo "module load gcc/8.3.0" >> launch.sh
    echo "module load openmpi/gcc/64/1.10.1" >> launch.sh
    echo "module load lammps/gcc/4may22" >> launch.sh
    echo "" >> launch.sh
    echo "mpirun -n ${nodes} lmp -in in.insertion -var sigma12 ${sigma12} -var sigma22 ${sigma22} -var co12 ${co12} -var co22 ${co22} -var ncol ${ncol}" >> launch.sh
    qsub launch.sh
    sleep 2
  done < $di/phi.dat
done < $di/beads.dat
