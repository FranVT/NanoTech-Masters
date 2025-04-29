# Version 2.2

Now we gave a nested qsub.

The first qsub is to run the assembly simulation and the create sge files for each deformation simulation.
The second qsub is to run the deformation simulation.

The data directory is where the data of each simulaiton it si stored.
The src directory has tho sub-directories, src, where all the bash scripts needed to create all the needed files are stored and the sim directory, where all the lammps files are located.
