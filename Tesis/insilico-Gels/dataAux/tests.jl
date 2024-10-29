using FileIO
using GLMakie

include("functions.jl")

# Create the file with the dirs names
run(`bash getDir.sh`)
# Store the dirs names
dirs_aux = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
    end

#dirs=dirs_aux;

#aux_indx=map(s->split(dirs_aux[1],"Nexp")[1] == split(dirs_aux[s],"Nexp")[1],eachindex(dirs_aux));
"""
   Start of the classification process.
"""
auxs_ind=findall(r->r==1, map(s->split(dirs_aux[1],"Nexp")[1] == split(dirs_aux[s],"Nexp")[1],eachindex(dirs_aux)) );
dirs=dirs_aux[auxs_ind];

# File names 
file_name = (
             "parameters",
             "energy_assembly.fixf",
             "wcaPair_assembly.fixf",
             "patchPair_assembly.fixf",
             "swapPair_assembly.fixf",
             "cmdisplacement_assembly.fixf",
             "stressVirial_assembly.fixf",
             "energy_shear.fixf",
             "wcaPair_shear.fixf",
             "patchPair_shear.fixf",
             "swapPair_shear.fixf",
             "cmdisplacement_shear.fixf",
             "stressVirial_shear.fixf"
            );

files=file_name;

parameters=getParameters(dirs,file_name);



function getAvgData(dirs,files,parameters)
"""
   dirs is a vector with the name of the directories: system
   Function that averages the information of N experiments. 
      1.-  Temperature
      2.-  Temperature of central particles
      3.-  Potential energy
      4.-  Kinetic energy
      5.-  Total energy
      6.-  wca Potential energy
      7.-  patch Potential energy
      8.-  swap Potential energy
      9.-  Mean displacement of CrossLinker
      10.- Mean displacement of Monomer
      11.- Mean displacement of central particles
      12.- XX component of stress tensor
      13.- XY component of stress tensor
"""
    N_ass=Int64(2*parameters[1][10]/10);
    
  
    # Get the data from each experiment
    #data=map(s->getData2(dirs[s],files,parameters[s]),eachindex(dirs));
    
    # Split the data into assembly and shear simulations
    data_assembly=first.(data);
    data_shear=last.(data);
    
    # Make sure that all information has the same length
    aux_lng=length.(map(s->data_assembly[s][1],eachindex(dirs)));
    auxs_ind=findall(s->s==N_ass,aux_lng);
    
    # Take the averages of the parameters
    temp_assembly=sum(reduce(hcat,map(s->data_assembly[s][1],auxs_ind)),dims=2)./length(auxs_ind);


    datavg_assembly=map(eachindex(file_name[2:end])) do itf
        sum(reduce(hcat,map(s->data_assembly[s][itf],auxs_ind)),dims=2)./length(auxs_ind);
    end

    datavg_shear=map(eachindex(file_name[2:end])) do itf
        sum(reduce(hcat,map(s->data_shear[s][itf],auxs_ind)),dims=2)./length(auxs_ind);
    end

    return (datavg_assembly,datavg_shear)

    # Create the paths to retrieve the infomration
    #paths=reduce(vcat,map(r->joinpath(dir,"info",r),files[2:end]));
   
   #return (info_assembly,info_shear)

end
