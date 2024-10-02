"""
    Script to create a bash script to run the assembly simulation
"""

## Auxiliary scripts
include("parameters.jl");

## Create the file
# Variables 
file_name = "assemblySimulation.sh";

file_intro = "#!/bin/bash\n\n # Run the assembly simulation\n\n";
file_stuff = "env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $seed1 -var seed2 $seed2 -var seed3 $seed3 -var steps $steps -var tstep $tstep -var sstep $sstep";


# Actually create the file
touch(file_name);
open(file_name,"w") do f
    map(s->write(f,s),(file_intro,file_stuff))
end
