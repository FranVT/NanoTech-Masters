"""
    Script to create a bash script to run the deformation simulation
"""

## Auxiliary scripts
include("parameters.jl");

## Create a directory to store the files
main_dir = pwd();
dir = string(main_dir,"/info/",dir_system);
rm(dir,force=true,recursive=true)
mkdir(dir);

println(string("createBashDeformation.jl Main directory: ",main_dir))

## Create the file
# Variables 
file_name = "deformationSimulation.sh";

file_intro = "#!/bin/bash\n\n # Run the deformation simulation\n\n";
file_stuff = "env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var tstep $tstep_defor -var sstep $sstep_defor -var shear_rate $shear_rate -var max_strain $max_strain -var Nstep_per_strain $Nstep_per_strain -var shear_it $shear_it -var Nsave $Nsave -var seed3 $seed3 -var Nave $Nave";


# Actually create the file
touch(file_name);
open(file_name,"w") do f
    map(s->write(f,s),(file_intro,file_stuff))
end

## Create the README file for the deformation simulation
cd(dir)

file_name = "README.md"

touch(file_name);
open(file_name,"w") do f
    write(f,"# Parameters of the simulation\n\n")
    write(f,"## Theoretical values\n")
    write(f,string("- Packing fraction: ",phi,"\n"))
    write(f,string("- Cross-Linker Concentration: ",CL_concentration,"\n"))
    write(f,string("- Central particle radius [sigma]: ",r_Parti,"\n"))
    write(f,string("- Patch particle radius [sigma]: ",r_Patch,"\n"))
    write(f,"\n")
    write(f,"## Computed Values\n")
    write(f,string("- Box Volume [sigma^3]: ",Vol_box,"\n"))
    write(f,string("- Cross-Linker Volume [sigma^3]: ",Vol_CL,"\n"))
    write(f,string("- Monomer Volume [sigma^3]: ",Vol_MO,"\n"))
    write(f,string("- Total volume of patchy particles [sigma^3]: ",Vol_Ptot,"\n"))
    write(f,"\n")
    write(f,string("## Values for the simulation\n"))
    write(f,string("- Time step [tau]: ",tstep_defor,"\n"))
    write(f,string("- Total number of Patchy Particles: ",N_particles,"\n"))
    write(f,string("- Number of Cross-Linkers: ",N_CL,"\n"))
    write(f,string("- Number of Monomers: ",N_MO,"\n"))
    write(f,string("- Shear rate [1/tau]: ",shear_rate,"\n"))
    write(f,string("- Max deformation per cycle: ",max_strain,"\n"))
    write(f,"### Derive values\n")
    write(f,string("- Numerical Cross-Linker Concentration: ",N_CL/N_particles,"\n"))
    write(f,string("- Numerical Packing fraction: ",phi_N,"\n" ))
end

cd(main_dir)
