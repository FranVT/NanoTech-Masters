"""
    Script to run analysis from lammps simulation data
"""

using FileIO

# Create the file with the dirs names
run(`bash getDir.sh`)
# Store the dirs names
dirs = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
    end




