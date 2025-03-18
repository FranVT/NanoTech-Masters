"""
    Script to declare usefull functions to analyse data
"""

function getDF()
"""
   Function that gives the data file of all directories
"""

    # Create the file with the directories names in the directory
    run(`bash getDir.sh`);

    # Store the directories names
    dirs_aux = open("dirs.txt") do f
        reduce(vcat,map(s->split(s," "),readlines(f)))
    end

    # Create DataFrames from the data.dat file of each directory
    df = DataFrame.(CSV.File.(joinpath.(dirs_aux,"data.dat")));

    return vcat(df...)

end
