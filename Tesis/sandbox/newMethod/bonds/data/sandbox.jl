"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
using Plots

include("functions.jl")

function extractInfo(df)
"""
    Function that reads the files and extract all the information
    file0 -> data_system_assembly
    file1 -> data_stress_assembly
    file2 -> data_clustP_assembly
    file3 -> traj_assembly
    file4 -> data.hydrogel
    file5 -> data_system_shear
    file6 -> data_stress_shear
    file7 -> data_clustP_shear
    file8 -> traj_shear
    file9 -> data.FirstShear
"""
    data_path=joinpath.(df_new."main-directory",df_new."file0");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","Temp","wca","patch","swap","V","K","Etot","ec","eC","p","eB","eA","eM","H"]; #aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_assembly=DataFrame(aux_info',aux_head);

    data_path=joinpath.(df_new."main-directory",df_new."file5");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","Temp","wca","patch","swap","V","K","Etot","ec","eC","p","eB","eA","eM","H"];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_shear=DataFrame(aux_info',aux_head);

    data_path=joinpath.(df_new."main-directory",df_new."file1");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","xx","yy","zz","xy","xz","yz"];#aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_stressA=DataFrame(aux_info',aux_head);
    
    data_path=joinpath.(df_new."main-directory",df_new."file6");
    aux=split.(readlines(data_path[1])," ");
    aux_head=["TimeStep","xx","yy","zz","xy","xz","yz"];#aux[2][2:end];
    aux_info=reduce(hcat,map(s->parse.(Float64,s),aux[3:end]))
    df_stressS=DataFrame(aux_info',aux_head);

    return (df_assembly, df_shear, df_stressA, df_stressS) 
end




# Get a data frame with all the data.dat files information
df = getDF();

# Desire parameters 
gamma_dot=0.1;
cl_con=0.01;

# New data frame
df_new = filter([:"Shear-rate",:"CL-Con"] => (f1,f2) -> f1==gamma_dot && f2==cl_con,df);

# Create the directories
 (df_assembly, df_shear, df_stressA, df_stressS) = extractInfo(df_new);






