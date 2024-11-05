"""
    Script with functions
"""

function getParameters(dirs,file_name,inds)
    """
        Function that return an array with the parameters of a simulation.
        dirs is an array of directories
        file_name is an array of file names
    """
    if length(inds)==1 
        file_dir=[joinpath(dirs[1],first(file_name))];
        parameters=map(eachindex(file_dir)) do r
            open(file_dir[r]) do f
                map(s->parse(Float64,s),readlines(f))
            end
        end
        return parameters   
    else
        file_dir=reduce(vcat,map(s->joinpath(dirs[s],first(file_name)),eachindex(dirs)));
        parameters=map(eachindex(dirs)) do r
            open(file_dir[r]) do f
                map(s->parse(Float64,s),readlines(f))
            end
        end
        return parameters
    end
end

function getInfo(filename)
"""
    Function that return a matrix with the following information:
        TimeStep Temperature Potential Kinetic
    (According to the output file in lammps)
"""
	Nlines = open(filename) do f
	    linecounter = 0
	    for l in eachline(f)
	        linecounter += 1
	    end
	    (linecounter)
	end


    # Allocate memory
    aux = ["" for it ∈ 1:Nlines];
    info = [[] for it ∈ 3:Nlines];

    aux = open(filename) do file
        line = 1;
        for ln in eachline(file)
            aux[line] = "$(ln)" #parse.(Float64,split("$(ln)"," "))
            line += 1
        end
        (aux)
    end

    # Convert the information
    for it in eachindex(info)
        info[it] = parse.(Float64,split(aux[it+2]," "))
    end

    println(filename)

    # Reshape the information
    return Float64.(reduce(hcat,info))
end

function getData(dirs,file_dir)
    """
        Function that retrieve all the data from the fix files
    """
    # Get info from the directories
    file_dir=map(dirs) do s
        reduce(vcat,map(r->joinpath(s,"info",r),file_name[2:end]))
    end

    info = map(file_dir) do s
        map(r->getInfo(r),s)
    end
    return info
end

function getData2(dir,files,parameters)
"""
   Function that retrieves the data from fixs files per experiment:
      Temperature
      Temperature of central particles
      Kinetic energy
      Potential energy
      wca Potential energy
      patch Potential energy
      swap Potential energy
      Mean displacement of CrossLinker
      Mean displacement of Monomer
      Mean displacement of central particles
      XX component of stress tensor
      XY component of stress tensor
"""
   
    # Create the paths to retrieve the infomration
    paths=reduce(vcat,map(r->joinpath(dir,"info",r),files[2:end]));
   
    # Extract the data
    data=map(paths) do s
        getInfo(s)
    end

    # Re-organize the data
    time_assembly=data[1][1,:];
    time_assemblyStress=data[6][1,:];
    temp_assembly=data[1][2,:];
    U_assembly=data[1][3,:];
    K_assembly=data[1][4,:];
    tempCM_assembly=data[1][5,:];
    pressure_assembly=data[1][6,:];
    wcaPair_assembly=data[2][2,:];
    patchPair_assembly=data[3][2,:];
    swapPair_assembly=data[4][2,:];
    displCl_assembly=data[5][2,:];
    displMo_assembly=data[5][3,:];
    stressXX_assembly=-data[6][2,:];
    stressXY_assembly=-data[6][5,:];

    time_shear=data[7][1,:];
    time_shearStress=data[12][1,:];
    temp_shear=data[7][2,:];
    U_shear=data[7][3,:];
    K_shear=data[7][4,:];
    tempCM_shear=data[7][5,:];
    pressure_shear=data[7][6,:];
    wcaPair_shear=data[8][2,:];
    patchPair_shear=data[9][2,:];
    swapPair_shear=data[10][2,:];
    displCl_shear=data[11][2,:];
    displMo_shear=data[11][3,:];
    stressXX_shear=-data[12][2,:];
    stressXY_shear=-data[12][5,:];
 
    # Compute data
    ## Total energy of the system (Internal Energy)
    E_assembly=U_assembly.+K_assembly;
    E_shear=U_shear.+K_shear;
    
    ## Mean displacement of Cl, Mo and central particles
    displCl_assembly=displCl_assembly./Int64(parameters[4]);
    displMo_assembly=displMo_assembly./Int64(parameters[4]);
    displCM_assembly=displCl_assembly.+displMo_assembly;
 
    displCl_shear=displCl_shear./Int64(parameters[4]);
    displMo_shear=displMo_shear./Int64(parameters[4]);
    displCM_shear=displCl_shear.+displMo_shear;

    # Create tuple with data
    info_assembly=(
                   time_assembly,time_assemblyStress,
                   temp_assembly,tempCM_assembly,pressure_assembly,
                   U_assembly,K_assembly,E_assembly,
                   wcaPair_assembly,patchPair_assembly,swapPair_assembly,
                   displCl_assembly,displMo_assembly,displCM_assembly,
                   stressXX_assembly,stressXY_assembly
                  );

    info_shear=(
                   time_shear,time_shearStress,
                   temp_shear,tempCM_shear,pressure_shear,
                   U_shear,K_shear,E_shear,
                   wcaPair_shear,patchPair_shear,swapPair_shear,
                   displCl_shear,displMo_shear,displCM_shear,
                   stressXX_shear,stressXY_shear
                  ); 
                  #info_shear=nothing;
    return (info_assembly,info_shear)

end


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
  
    # Get the data from each experiment
    data=Iterators.flatten(map(s->getData2(s,files,parameters),dirs));
    
    # Split the data into assembly and shear simulations
    data_assembly=map(s->first.(s),data);
    data_shear=map(s->last.(s),data);

    # Take the averages of the parameters
    temp_assembly=sum(reduce(hcat,map(s->data_assembly[s][1],eachindex(dirs))),dims=2)./length(dirs);


    # Create the paths to retrieve the infomration
    paths=reduce(vcat,map(r->joinpath(dir,"info",r),files[2:end]));
   
   return (info_assembly,info_shear)

end

# Average the result of a set of simulations
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
    data=map(s->getData2(dirs[s],files,parameters[s]),eachindex(dirs));
    
    # Split the data into assembly and shear simulations
    data_assembly=first.(data);
    data_shear=last.(data);
    
    # Make sure that all information has the same length
    aux_lng=length.(map(s->data_assembly[s][1],eachindex(dirs)));
    auxs_ind=findall(s->s==N_ass,aux_lng);
    
    # Take the averages of the data 
    datavg_assembly=map(eachindex(file_name[2:end])) do itf
        sum(reduce(hcat,map(s->data_assembly[s][itf],auxs_ind)),dims=2)./length(auxs_ind);
    end

    datavg_shear=map(eachindex(file_name[2:end])) do itf
        sum(reduce(hcat,map(s->data_shear[s][itf],auxs_ind)),dims=2)./length(auxs_ind);
    end

    return (datavg_assembly,datavg_shear)

end
