"""
    Script that creates a polymer data file from a dump file

    The information is as follows
    id type mol-id xs ys zs cluster-id

"""

# Path to the file and file name
pathf = "assembly\\";
filename = "newdata_assembly.dumpf";

# Extract information
info = readlines(string(pathf,filename));

# Get number of atoms
N_atoms = parse(Int64,info[4]);

# Index with information
ind = 10:length(info);

# Get the information
data = stack(map(it->parse.(Float64,split(info[it+9]," ")),eachindex(ind)),dims=1);

# Delete the patchy particles
del_inds = sort(collect(Iterators.flatmap(s->findall(x->x==s,Int64.(data[:,2])),3:4)));
data = stack(map(s->deleteat!(data[:,s],del_inds),1:7),dims=2)


# Classify the info given the cluster id
c_ids = unique(data[:,end]);
c_inds = map(s->findall(x->x==s,data[:,end]),c_ids);
c_ids = Float64.(eachindex(c_ids));

# Rename and clean
mol_id = copy(data[:,end]);
map(s->mol_id[c_inds[s]].=s,eachindex(c_inds));
data = reduce(hcat,[data[:,2],data[:,4:6],mol_id]);

# Position of the particles per polymer
mol_data = reduce(vcat,map(s->data[c_inds[s],:][:,:],eachindex(c_inds)));

# Update stuff
c_ids = unique(mol_data[:,end]);
c_inds = map(s->findall(x->x==s,mol_data[:,end]),c_ids);

function distMols(mol)
"""
    Function that retuns the distance between each molecule
"""
    return map(s->sqrt(sum((mol[1,:].-mol[s,:]).^2)), 1:length(mol[:,1]) )
end

function ordMols(mol)
"""
    Function that arrange the molecules un ascending order
"""
    if length(mol[:,1]) == 1
        return mol
    elseif length(mol[:,1]) == 2
        return mol
    else
        new_mol_info = copy(mol);
        inds = sortperm(distMols(mol[:,2:4]));
        return new_mol_info[inds,:]
    end
end

mol_info = reduce(vcat,map(s->ordMols( mol_data[c_inds[s],:] ),eachindex(c_inds)));

"""
    Part of the script that creates the read data file: https://docs.lammps.org/2001/data_format.html

    atoms bonds
    atom-types bond-types 
    box size
    Masses
    Bond Coeffs Section (FENE/nm style -> K Ro Eo ro n m)
    Atoms Section (bond style -> atom-Id molecule-ID atom-type x y z)
    Bonds Section (ID bond-type ID-atom1 ID-atom2)

"""

atoms = length(data[:,1]);
bonds = sum(length.(c_inds).-1);
atom_type = 2;
bond_type = 1;
box_size = parse.(Float64,split(info[6]," "));
masses = (1.0,1.0);
bond_coeffs = (30,1.5,0,0,1,0);


# Auxiliry for the Masse section
aux_Masses = map(s-> string("    ",s," ",masses[s],"\n"),1:atom_type);

# Auxiliaries for Atoms and Bonds section
aux_Atoms = map(t->string("    ",t," ",Int64(mol_info[t,end])," ",Int64(mol_info[t,1])," ",rstrip(join(map(s->s*" ",string.(mol_info[t,2:end-1])))),"\n"),eachindex(mol_info[:,1]));

aux_Bonds = reduce(vcat,map(t-> map(s-> (s,s+1), first(c_inds[t]):last(c_inds[t])-1 ),eachindex(c_inds) ));
aux_Bonds = map(it->  string("    ",it," ",bond_type," ",rstrip(join(map(s->s*" ",string.(aux_Bonds[it])))))*"\n" ,eachindex(aux_Bonds));

# Start to write the data file
filename = "data.polymer";
touch(filename); # Create the file

# Edit the file
open(filename,"w") do f
    write(f,"\n\n")
    write(f,string(atoms," atoms\n"))
    write(f,string(bonds," bonds\n"))
    write(f,"\n")
    write(f,string(atom_type," atom types\n"))
    write(f,string(bond_type," bond types\n"))
    write(f,"\n")
    write(f,string(box_size[1]," ",box_size[2]," xlo xhi\n"))
    write(f,string(box_size[1]," ",box_size[2]," ylo yhi\n"))
    write(f,string(box_size[1]," ",box_size[2]," zlo zhi\n"))
    write(f,"\n")
    write(f,"Masses\n\n")
    map(s->write(f,s),aux_Masses)
    write(f,"\n")
    write(f,"Bond Coeffs\n\n")
    write(f,string("  ",1," ",rstrip(join(map(s->s*" ",string.(bond_coeffs))))*"\n\n"))
    write(f,"Atoms\n\n")
    map(s->write(f,s),aux_Atoms)
    write(f,"\n")
    write(f,"Bonds\n\n")
    map(s->write(f,s),aux_Bonds)
    write(f,"\n")

end

