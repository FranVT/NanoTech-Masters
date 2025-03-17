"""
    Script to declare usefull functions to analyse data
"""

function getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp)
"""
   Function that gives the data file of all directories
"""

    # Create the file with the directories names in the directory
    run(`bash getDir.sh`);

    # Store the directories names
    dirs_aux = open("dirs.txt") do f
        reduce(vcat,map(s->split(s," "),readlines(f)))
    end

    # Get the data.dat file of each directory
    joinpath

end
