"""
   Script with auxiliary functions to get the information 
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
auxs_indNexp=Iterators.flatten(map(s->findall(r->r==s, last.(aux_dirs_ind)), selc_Nexp))|>collect;

# Get the idixes that meet the criteria
auxs_ind=intersect(auxs_indPhi,auxs_indNPart,auxs_indDamp,auxs_indT,auxs_indcCL,auxs_indShearRate,auxs_indNexp);

# Select the number of experiments
#auxs_ind=auxs_ind;
#dirs=dirs_aux[auxs_ind];
return dirs_aux[auxs_ind]
end


