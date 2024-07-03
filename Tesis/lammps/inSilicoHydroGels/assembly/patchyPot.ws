# Fco. Vazquez vazqueztfj@proton.me
#
# Stilinger-Weber (sw) parameters for hydrogel 
# Include this potential in LAMMPS input script as follows,
#     pair_tyle     sw
#     pair_coeff    3 4 patchyPot.ws NULL NULL PA PB
#
# Particles type 1 and 2 are for CrossLinker and Monomer.
#
# LJ units
# format of a single entry (one or more lines):
#   element 1, element 2, element 3, 
#   epsilon, sigma, a, lambda, gamma, costheta0, A, B, p, q, tol

# Parameters for Patch - Patch interaction:
# Macromolecules2017, 50, 8777-8786
# For epsilon, sigma and a, A, B, p, q
#
# Parameters lambda, gamma, costheta0 are propose
#
# Allow interactions:
#    epsilon, sigma, a, lambda, gamma, costheta0, A, B, p, q, tol

# No interaction between CrossLinker Patches
PA PA PA 0.0  0.5  1.5  0.0  0.0  0.0  2.0  1.0  4.0  0.0  0.0
PA PA PB 0.0  0.5  1.5  0.0  0.0  0.0  2.0  1.0  4.0  0.0  0.0
PA PB PA 0.0  0.5  1.5  0.0  0.0  0.0  2.0  1.0  4.0  0.0  0.0

# Monomer - Monomer
PB PB PB 7.5  0.5  1.5  0.0  0.0  0.0  2.0  1.0  4.0  0.0  0.0

# CrossLinker - Monomer
PA PB PB 7.5  0.5  1.5  0.0  0.0  0.0  2.0  1.0  4.0  0.0  0.0

# Monomer - CrossLinker
PB PB PA 7.5  0.5  1.5  0.0  0.0  0.0  2.0  1.0  4.0  0.0  0.0
PB PA PB 7.5  0.5  1.5  0.0  0.0  0.0  2.0  1.0  4.0  0.0  0.0
PB PA PA 7.5  0.5  1.5  0.0  0.0  0.0  2.0  1.0  4.0  0.0  0.0
