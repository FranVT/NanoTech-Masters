"""
    Sandbox script to test functions and stuff
"""

# Create the file with the directories names in the directory
    run(`bash getDir.sh`);

    # Store the directories names
    dirs_aux = open("dirs.txt") do f
        reduce(vcat,map(s->split(s," "),readlines(f)))
    end

    # Get the data.dat file of each directory
    joinpath

