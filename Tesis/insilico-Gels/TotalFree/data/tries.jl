include("functions.jl")

# Create the file with the dirs names
run(`bash getDir.sh`)
# Store the dirs names
dirs_aux = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
    end

dirs=dirs_aux; #[2:end];

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

parameters=getParameters(dirs,file_name);

dir=dirs[1];
files=file_name;
parameters=parameters[1]

# Create the paths to retrieve the infomration
    paths=reduce(vcat,map(r->joinpath(dir,"info",r),files[2:end]));
   
    # Extract the data
    data=map(paths) do s
        getInfo(s)
    end

    # Re-organize the data
    temp_assembly=data[1][2,:];
    U_assembly=data[1][3,:];
    K_assembly=data[1][4,:];
    tempCM_assembly=data[1][5,:];
    wcaPair_assembly=data[2][2,:];
    patchPair_assembly=data[3][2,:];
    swapPair_assembly=data[4][2,:];
    displCl_assembly=data[5][2,:];
    displMo_assembly=data[5][3,:];
    stressXX_assembly=data[6][3,:];
    stressXY_assembly=data[6][6,:];

    temp_shear=data[7][2,:];
    U_shear=data[7][3,:];
    K_shear=data[7][4,:];
    tempCM_shear=data[7][5,:];
    wcaPair_shear=data[8][2,:];
    patchPair_shear=data[9][2,:];
    swapPair_shear=data[10][2,:];
    displCl_shear=data[11][2,:];
    displMo_shear=data[11][3,:];
    stressXX_shear=data[12][3,:];
    stressXY_shear=data[12][6,:];
 
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
                   temp_assembly,tempCM_assembly,
                   U_assembly,K_assembly,E_assembly,
                   wcaPair_assembly,patchPair_assembly,swapPair_assembly,
                   displCl_assembly,displMo_assembly,displCM_assembly,
                   stressXX_assembly,stressXY_assembly
                  );

    info_shear=(
                   temp_shear,tempCM_shear,
                   U_shear,K_shear,E_shear,
                   wcaPair_shear,patchPair_shear,swapPair_shear,
                   displCl_shear,displMo_shear,displCM_shear,
                   stressXX_shear,stressXY_shear
                  );
 
