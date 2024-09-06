"""
    Script to create a bash script to run the deformation simulation
"""

## Auxiliary scripts
include("parameters.jl");

main_dir = pwd();

## Create the file
# Variables 
file_name = "deformationSimulation.sh";

file_intro = "#!/bin/bash\n\n # Run the deformation simulation\n\n";
file_stuff = "env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var tstep $tstep_defor -var sstep $sstep_defor -var shear_rate $shear_rate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var seed3 $seed3 -var Nave $Nave -var rlxT1 $relaxTime1 -var rlxT2 $relaxTime2 -var rlxT3 $relaxTime3 -var rlxT4 $relaxTime4";


# Actually create the file
touch(file_name);
open(file_name,"w") do f
    map(s->write(f,s),(file_intro,file_stuff))
end

