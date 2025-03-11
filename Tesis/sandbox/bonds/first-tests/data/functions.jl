"""
   Script with function to analyses the system
"""

function getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp)
"""
   Function that gives the names of the directories with the system required
"""

# Create the file with the directories names in the directory
run(`bash getDir.sh`);

# Store the directories names
dirs_aux = open("dirs.txt") do f
    reduce(vcat,map(s->split(s," "),readlines(f)))
end


aux_dirs_ind=split.(last.(split.(dirs_aux,"Phi")),"NPart");
auxs_indPhi=findall(r->r==selc_phi, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"damp");
auxs_indNPart=findall(r->r==selc_Npart, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"T");
auxs_indDamp=findall(r->r==selc_damp, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"cCL");
auxs_indT=findall(r->r==selc_T, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"ShearRate");
auxs_indcCL=findall(r->r==selc_cCL, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"-");
auxs_indShearRate=findall(r->r==selc_ShearRate, first.(aux_dirs_ind) );

aux_dirs_ind=split.(last.(aux_dirs_ind),"Nexp");
auxs_indNexp=findall(r->r==selc_Nexp, last.(aux_dirs_ind));

# Get the idixes that meet the criteria
auxs_ind=intersect(auxs_indPhi,auxs_indNPart,auxs_indDamp,auxs_indT,auxs_indcCL,auxs_indShearRate,auxs_indNexp);

# Select the number of experiments

return dirs_aux[auxs_ind]
end

function getParameters(dir,files_names)
"""
   Function that return a tuple with the parameters
"""
    file_dir =joinpath(first(dir),files_names.parm); 

    aux = open(file_dir) do f
                    map(s->parse(Float64,s),readlines(f))
                 end

    parameters = (
                  phi    = aux[1],
                  N_part = aux[2],
                  N_cl   = aux[3],
                  N_mo   = aux[4],
                  C_cl   = aux[5],
                  vol    = aux[6],
                  l_half = aux[7],
                  temp   = aux[8],
                  damp   = aux[9],
                  dt     = aux[10],
                  N_heat = aux[11],
                  N_iso  = aux[12],
                  save_d = aux[13],
                  save_f = aux[14],
                  sh_rt  = aux[16],
                  mx_def = aux[17],
                  N_def  = aux[18],
                  N_rlx1 = aux[19],
                  N_rlx2 = aux[20],
                  N_rlx3 = aux[21],
                  save_s = aux[24]
                 )

    return parameters
end


function extractInfo(file_dir)
"""
   Function that reads the files and extract all the information
"""
    return reduce(hcat,map(s->parse.(Float64,s),split.(readlines(file_dir)," ")[3:end]))
end


function getData(parm,files_dir)
"""
    Function that retrieves all the data from the experiment
"""

    # Indixes to facilitate further analysis or create graphs
    ind_heat = Int64.(1:1:div(parm.N_heat,parm.save_f));
    ind_iso  = Int64.(1:1:div(parm.N_iso,parm.save_f)) .+ last(ind_heat);
    ind_def1 = Int64.(1:1:div(parm.mx_def*parm.N_def,parm.save_f)) .+ last(ind_iso);
    ind_rlx1 = Int64.(1:1:div(parm.N_rlx1,parm.save_f)) .+ last(ind_def1);
    ind_def2 = Int64.(1:1:div(parm.mx_def*parm.N_def,parm.save_f)) .+ last(ind_rlx1);
    ind_rlx2 = Int64.(1:1:div(parm.N_rlx2,parm.save_f)) .+ last(ind_def2);
    ind_def3 = Int64.(1:1:div(parm.mx_def*parm.N_def,parm.save_f)) .+ last(ind_rlx2);
    ind_rlx3 = Int64.(1:1:div(parm.N_rlx3,parm.save_f)) .+ last(ind_def3);

    # Indixes for the stress files
    ind_sheat = Int64.(1:1:div(parm.N_heat,parm.save_s));
    ind_siso  = Int64.(1:1:div(parm.N_iso,parm.save_s)) .+ last(ind_sheat);
    ind_sdef1 = Int64.(1:1:div(parm.mx_def*parm.N_def,parm.save_s)) .+ last(ind_siso);
    ind_srlx1 = Int64.(1:1:div(parm.N_rlx1,parm.save_s)) .+ last(ind_sdef1);
    ind_sdef2 = Int64.(1:1:div(parm.mx_def*parm.N_def,parm.save_s)) .+ last(ind_srlx1);
    ind_srlx2 = Int64.(1:1:div(parm.N_rlx2,parm.save_s)) .+ last(ind_sdef2);
    ind_sdef3 = Int64.(1:1:div(parm.mx_def*parm.N_def,parm.save_s)) .+ last(ind_srlx2);
    ind_srlx3 = Int64.(1:1:div(parm.N_rlx3,parm.save_s)) .+ last(ind_sdef3);

    # Make it easier to access
    inds=(
          heat=ind_heat,
          iso=ind_iso,
          assembly=reduce(vcat,[ind_heat,ind_iso]),
          def1=ind_def1,
          rlx1=ind_rlx1,
          def2=ind_def2,
          rlx2=ind_rlx2,
          def3=ind_def3,
          rlx3=ind_rlx3,
          shear=reduce(vcat,[ind_def1,ind_rlx1,ind_def2,ind_rlx2,ind_def3,ind_rlx3]),
          heats=ind_sheat,
          isos=ind_siso,
          assemblys=reduce(vcat,[ind_sheat,ind_siso]),
          def1s=ind_sdef1,
          rlx1s=ind_srlx1,
          def2s=ind_sdef2,
          rlx2s=ind_srlx2,
          def3s=ind_sdef3,
          rlx3s=ind_srlx3,
          shears=reduce(vcat,[ind_sdef1,ind_srlx1,ind_sdef2,ind_srlx2,ind_sdef3,ind_srlx3]),
         );


    # Get the information from the energy.fixf
    aux_ass = extractInfo(files_dir.engAss);
    aux_def = extractInfo(files_dir.engDef);
    
    # Order the information
    temp_ass  = aux_ass[2,:];
    ep_ass    = aux_ass[3,:];
    ek_ass    = aux_ass[4,:];
    p_ass     = aux_ass[5,:];
    ecple_ass = aux_ass[6,:];
    ecrve_ass = aux_ass[7,:];
    etot_ass  = aux_ass[8,:];
    ebond_ass = aux_ass[9,:];
    eang_ass  = aux_ass[10,:];
    emol_ass  = aux_ass[12,:];
    enth_ass  = aux_ass[11,:];
    temp_def  = aux_def[2,:];
    ep_def    = aux_def[3,:];
    ek_def    = aux_def[4,:];
    p_def     = aux_def[5,:];
    temp_df   = aux_def[6,:];
    ecple_def = aux_def[7,:];
    ecrve_def = aux_def[8,:];
    etot_def  = aux_def[9,:];
    ebond_def = aux_def[10,:];
    eang_def  = aux_def[11,:];
    emol_def  = aux_def[13,:];
    enth_def  = aux_def[12,:];

    # Get the information from the wca.fixf
    aux_ass = extractInfo(files_dir.wcaAss);
    aux_def = extractInfo(files_dir.wcaDef);

    # Order the information
    wca_ass = aux_ass[2,:];
    wca_def = aux_def[2,:];
 
    # Get the information from the patch.fixf
    aux_ass = extractInfo(files_dir.patchAss);
    aux_def = extractInfo(files_dir.patchDef);
 
    # Order the information
    patch_ass = aux_ass[2,:]; 
    patch_def = aux_def[2,:]; 
 
    # Get the information from the swap.fixf
    aux_ass = extractInfo(files_dir.swapAss);
    aux_def = extractInfo(files_dir.swapDef);
 
    # Order the information
    swap_ass = aux_ass[2,:]; 
    swap_def = aux_def[2,:]; 
    
    # Get the information from the stress.fixf
    aux_ass = extractInfo(files_dir.stressAss);
    aux_def = extractInfo(files_dir.stressDef);
 
    # Makes some computes
    stress_ass = sqrt.(aux_ass[2,:].^2 .+ aux_ass[3,:].^2 .+ aux_ass[4,:].^2 .+ (2) .*(aux_ass[5,:].^2 .+ aux_ass[6,:].^2 .+ aux_ass[7,:].^2 )) ; 
    stress_def = sqrt.(aux_def[2,:].^2 .+ aux_def[3,:].^2 .+ aux_def[4,:].^2 .+ (2) .*(aux_def[5,:].^2 .+ aux_def[6,:].^2 .+ aux_def[7,:].^2 )) ; 

    presss_ass = (1/3) .* (aux_ass[2,:] .+ aux_ass[3,:] .+ aux_ass[4,:]);
    presss_def = (1/3) .* (aux_def[2,:] .+ aux_def[3,:] .+ aux_def[4,:]);

    sigXX_ass = aux_ass[2,:];
    sigXY_ass = aux_ass[5,:];
    
    sigXX_def = aux_def[5,:];
    sigXY_def = aux_def[2,:];

    energy_ass = ep_ass .+ ek_ass;
    energy_def = ep_def .+ ek_def;

    system = (
              temp   = reduce(vcat,[temp_ass,temp_def]),
              tmp_df = temp_df,
              ep     = reduce(vcat,[ep_ass,ep_def]),
              ek     = reduce(vcat,[ek_ass,ek_def]),
              p      = reduce(vcat,[p_ass,p_def]),
              ecple  = reduce(vcat,[ecple_ass,ecple_def]),
              ecrve  = reduce(vcat,[ecrve_ass,ecrve_def]),
              wca    = reduce(vcat,[wca_ass,wca_def]),
              patch  = reduce(vcat,[patch_ass,patch_def]),
              swap   = reduce(vcat,[swap_ass,swap_def]),
              stress = reduce(vcat,[stress_ass,stress_def]),
              sig_XX = reduce(vcat,[sigXX_ass,sigXX_def]),
              sig_XY = reduce(vcat,[sigXY_ass,sigXY_def]),
              presss = reduce(vcat,[presss_ass,presss_def]),
              energy = reduce(vcat,[energy_ass,energy_def])
             )

    return (inds,system)

end



function ram()

"""

"""

fig=Figure(size=(1920,1080));
ax_leg=Axis(fig[1:2,2],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_total=Axis(fig[1,1:2],
               title=L"\mathrm{~of~the~system}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
ax_assembly=Axis(fig[2,1],
               title=L"\mathrm{~of~the~system~during~Assembly}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               )
ax_shear=Axis(fig[2,2],
               title=L"\mathrm{~of~the~system~during~Shear}",
               xlabel=L"\mathrm{Time~steps~}",
               ylabel=L"\mathrm{}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
              )
lines!(ax_total,system)
lines!(ax_assembly,system[inds.assembly])
lines!(ax_shear,system[inds.shear])

save(joinpath(dirs[1],".png"),fig)

end


