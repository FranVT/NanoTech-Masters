"""
    Script to create the Swap.3b file
"""

workdir = cd("/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/assembly/")
filename = "swapMech.3b";

# Create the permutation stuff
aux = vec(Iterators.product(Iterators.repeated(("PA ","PB "),3)...)|>collect);
parameters = "0.6 swapMechTab.table SEC1 linear 50\n";
info = join.(aux).*parameters;

"""
# Fco. Vazquez vazqueztfj@proton.me
#
# Potential file for Swap Mechanism parameters for hydrogel 
# Include this potential in LAMMPS input script as follows,
#     pair_tyle     threebody/table
#     pair_coeff    * * threebody/table swapMech.3b NULL NULL PA PB
#
# Particles type 1 and 2 are for CrossLinker and Monomer.
#
# LJ units
# format of a single entry (one or more lines):
#   element 1, element 2, element 3, 
#   cut(distance units) filename keyword style N
# style = linear, N = 4 (Atom types in the simulation)
# cut = 0 => No interaction is calculted for this element triplet
#
# Parameters for Patch - Patch interaction:
# Macromolecules2017, 50, 8777-8786 
#
#
# Allow interactions:
#    el1 el2 el3 cut filename kewyword style N

# Repulsion between CrossLinker Patches
PA PA PA 0.75 swapMechTab.table SEC1 linear 20
PA PA PB 0.75 swapMechTab.table SEC1 linear 20
PA PB PA 0.75 swapMechTab.table SEC1 linear 20

# Monomer - Monomer
PB PB PB 0.75 swapMechTab.table SEC1 linear 20

# CrossLinker - Monomer
PA PB PB 0.75 swapMechTab.table SEC1 linear 20

# Monomer - CrossLinker
PB PB PA 0.75 swapMechTab.table SEC1 linear 20
PB PA PB 0.75 swapMechTab.table SEC1 linear 20
PB PA PA 0.75 swapMechTab.table SEC1 linear 20
"""

# Start to write the data file
    touch(filename); # Create the file

    # Edit the file
    open(filename,"w") do f
        map(s->write(f,s),info)
    end

