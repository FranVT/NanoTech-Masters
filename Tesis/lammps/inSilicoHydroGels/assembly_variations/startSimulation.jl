"""
    Script to run lammps in file
"""

using Random

include("scripts/parameters.jl")

prng = MersenneTwister(1234);

files_names=("patchyParticles_assembly.dumpf", "newdata_assembly.dumpf", "voronoiSimple_assembly.dumpf", "vorHisto_assembly.fixf", "energy_assembly.fixf", "sizeCluster_assembly.fixf");

# Parameters
L = 8;
N_CL = 50;
N_MO = 450;

Nsim = 50;
seeds_1 = rand(prng,collect(1000:1:9000),Nsim);
seeds_2 = reverse(seeds_1);


file = "in.assembly.lmp";

for it in eachindex(seeds_1)
    s1 = seeds_1[it];
    s2 = seeds_2[it];
    cmd = `env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assembly.lmp -var L $L -var NCL $N_CL -var NMO $N_MO -var seed1 $s1 -var seed2 $s2 -var steps 10000000`;
    run(cmd)

    println("\n\n")

    # Create directory
    folder = string("sim",it);
    cmd_dir = `mkdir info/$folder`;
    run(cmd_dir)
    
    # Move the dumps and fixes to the new directory
    map(s->run(`mv $s info/$folder`),files_names)

    # Create a README with parameters of the simulation
    touch("README.md");
    info =string("N = 10000000\ndt = 0.005\nL = ",L,"\nNCL = ",N_CL,"\nNMO = ",N_MO,"\nseed1 = ",s1,"\ndt = ",t_step,"\nDump every: ",N_saves," steps");
    open("README.md","w") do f
        write(f,info)
    end
    run(`mv README.md info/$folder`)
    println("Fin de una simulación\n\n")
end

