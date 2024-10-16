"""
    Script to create the README file and the bash script to move the data to the file directory
"""

include("parameters.jl")

## Create a directory to store the files
main_dir = pwd();
dir = string(main_dir,"/dataFiles/",dir_system);
rm(dir,force=true,recursive=true);
mkdir(dir);


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


# Create a bash file that moves the data files from info to dataFiles/system
file_name = "moveAux.sh"
datanames = filter(!=(" "),Iterators.flatten(files)|>collect); 

touch(file_name);
open(file_name,"w") do f
    write(f,"#!/bin/bash\n\n # Move data files to system directory\n\n")
    write(f,"cd sysFiles/auxs;\n")
    write(f,string("cp parameters.jl parameters_copy.jl; mv parameters_copy.jl ",dir,";\n"))
    write(f,string("cd ",dir,"; mv parameters_copy.jl parameters.jl;\n"))
    write(f,string("cd ",main_dir,";\n"))
    write(f,string("mv data.hydrogel ",dir,";\n"))
    write(f,"cd info;\n")
    map(s->write(f,string("mv ",s," ",dir,";\n")),datanames)
    write(f,string("mv patchyParticles_assembly.dumpf ",dir,";\n"))
    write(f,string("mv patchyParticles_shear.dumpf ",dir,";\n"))
    write(f,string("cd ",main_dir,";\n"))
    #map(s->write(f,s),(file_intro,file_stuff))
end

cd(main_dir)
