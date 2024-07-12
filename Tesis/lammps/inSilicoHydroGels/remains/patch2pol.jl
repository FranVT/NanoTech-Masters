"""
    Script that creates a polymer data file from a dump file

    The information is as follows
    id type mol-id xs ys zs cluster-id

"""

# Path to the file and file name
pathf = "assembly//";
filename = "data.test";

# Extract information
info = readlines(string(pathf,filename));

# Get number of atoms
N_atoms = parse(Int64,split(info[3]," ")[1]);

# Index with information
ind = 10:length(info);

# Get the information
data = stack(map(it->parse.(Float64,split(info[it+9]," ")),eachindex(ind)),dims=1);

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

atoms = N_atoms;
bonds = parse(Int64,split(info[5]," ")[1]);
atom_type = 2;
bond_type = 1;
box_size = info[8:10];
masses = info[14:15];
bond_coeffs = (30.0,1.5,0.0,1.0,0,0);


