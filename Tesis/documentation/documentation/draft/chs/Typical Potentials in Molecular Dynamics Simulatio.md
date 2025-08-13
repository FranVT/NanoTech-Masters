<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# Typical Potentials in Molecular Dynamics Simulations

The forces in classical molecular dynamics (MD) are derived from a **potential energy function** (force field) that is decomposed into *covalent* (bonded) and *non-covalent* (nonbonded) terms. Below is an overview of the most commonly used functional forms for each.

## 1. Covalent (Bonded) Potentials

Bonded interactions maintain the molecular geometry and include bond stretching, angle bending, and torsional rotations.

1. Bond Stretching
    - **Harmonic potential**
\$ U_{bond}(r) = \tfrac{1}{2}k_b (r - r_0)^2 \$
where $r$ is the instantaneous bond length, $r_0$ the equilibrium bond length, and $k_b$ the force constant.
    - **Morse potential** (less common, captures anharmonicity)
\$ U_{Morse}(r) = D_e \bigl(1 - e^{-a(r - r_0)}\bigr)^2 \$
where $D_e$ is the bond dissociation energy and $a$ controls the width of the potential well.
2. Angle Bending
    - **Harmonic potential**
\$ U_{angle}(\theta) = \tfrac{1}{2}k_\theta (\theta - \theta_0)^2 \$
with $\theta$ the bond angle, $\theta_0$ its equilibrium value, and $k_\theta$ the corresponding force constant.
3. Dihedral (Torsional) Rotations
    - **Fourier series (periodic) potential**
\$ U_{dihedral}(\phi) = \sum_{n} \tfrac{1}{2}V_n \bigl[1 + \cos(n\phi - \gamma_n)\bigr] \$
where $\phi$ is the dihedral angle, $V_n$ the barrier amplitude for periodicity $n$, and $\gamma_n$ the phase shift.
4. Improper Torsions / Urey–Bradley Terms
    - Often included to maintain planarity or chirality:
\$ U_{improper}(\xi) = \tfrac{1}{2}k_\xi (\xi - \xi_0)^2 \$
or a 4-atom Urey–Bradley harmonic term connecting 1–3 atoms.

## 2. Non-Covalent (Nonbonded) Potentials

Nonbonded terms capture dispersion, repulsion, and electrostatic interactions between all atom pairs beyond a specified covalent cutoff (usually >1–4 interactions).

1. Van der Waals Interactions
    - **Lennard-Jones 12–6 potential**
\$ U_{LJ}(r_{ij}) = 4\varepsilon_{ij}\Bigl[\bigl(\tfrac{\sigma_{ij}}{r_{ij}}\bigr)^{12} - \bigl(\tfrac{\sigma_{ij}}{r_{ij}}\bigr)^{6}\Bigr] \$
where $r_{ij}$ is the interatomic distance, $\varepsilon_{ij}$ the depth of the potential well, and $\sigma_{ij}$ the finite distance at which the potential is zero.
    - **Buckingham (exp-6) potential**
\$ U_{Buck}(r_{ij}) = A e^{-B r_{ij}} - \tfrac{C}{r_{ij}^6} \$
sometimes used for more accurate short-range repulsion.
2. Electrostatic (Coulomb) Interactions
    - **Coulomb’s law**
\$ U_{elec}(r_{ij}) = \dfrac{1}{4\pi\varepsilon_0} \dfrac{q_i q_j}{r_{ij}} \$
with $q_i, q_j$ partial charges and $\varepsilon_0$ the vacuum permittivity.
    - **Ewald summation / Particle Mesh Ewald (PME)**
Algorithms that efficiently handle long-range electrostatics in periodic systems by splitting into real-space and reciprocal-space contributions.

## 3. Composite Force Fields

Widely used biomolecular force fields (e.g., AMBER, CHARMM, OPLS-AA, GROMOS) combine the above terms with empirically or quantum-mechanically derived parameters:


| Force Field | Bond Stretching | Angle Bending | Dihedral/Torsion | Nonbonded (vdW + Electrostatics) |
| :-- | :-- | :-- | :-- | :-- |
| AMBER | Harmonic | Harmonic | Fourier series (periodic) | LJ 12–6 + PME Coulomb |
| CHARMM | Harmonic | Harmonic | Fourier series + impropers | LJ 12–6 or modified 12–6 + PME Coulomb |
| OPLS-AA | Harmonic | Harmonic | Fourier series (four-term) | LJ 12–6 + PME Coulomb |
| GROMOS | Harmonic | Harmonic | Ryckaert–Bellemans (cosine series) | LJ 12–6 + reaction-field Coulomb |

## 4. Summary

- **Covalent bonds**: typically modeled as harmonic springs (occasionally Morse for bond breaking) plus harmonic angle and periodic dihedral terms.
- **Non-covalent interactions**: dominated by Lennard-Jones 12–6 (or Buckingham) for van der Waals and Coulomb’s law (handled via Ewald/PME) for electrostatics.

These functional forms strike a balance between computational efficiency and the ability to reproduce experimentally observed structures, dynamics, and thermodynamics.

---

# References

Cornell, W. D.; Cieplak, P.; Bayly, C. I.; Gould, I. R.; Merz, K. M.; Ferguson, D. M.; Spellmeyer, D. C.; Fox, T.; Caldwell, J. W.; Kollman, P. A. A Second Generation Force Field for the Simulation of Proteins, Nucleic Acids, and Organic Molecules. *J. Am. Chem. Soc.* **1995**, *117*, 5179–5197.

MacKerell, A. D. Jr.; Bashford, D.; Bellott, M.; Dunbrack, R. L. Jr.; Evanseck, J. D.; Field, M. J.; Fischer, S.; Gao, J.; Guo, H.; Ha, S.; Joseph-McCarthy, D.; Kuchnir, L.; Kuczera, K.; Lau, F. T. K.; Mattos, C.; Michnick, S.; Ngo, T.; Nguyen, D. T.; Prodhom, B.; Reiher, W. E. III; Roux, B.; Schlenkrich, M.; Smith, J. C.; Stote, R.; Straub, J.; Watanabe, M.; Wiorkiewicz-Kuczera, J.; Yin, D.; Karplus, M. All-Atom Empirical Potential for Molecular Modeling and Dynamics Studies of Proteins. *J. Phys. Chem. B* **1998**, *102*, 3586–3616.

Jorgensen, W. L.; Maxwell, D. S.; Tirado-Rives, J. Development and Testing of the OPLS All-Atom Force Field on Conformational Energetics and Properties of Organic Liquids. *J. Am. Chem. Soc.* **1996**, *118*, 11225–11236.

Scott, W. R. P.; Hünenberger, P. H.; Tironi, I. G.; Mark, A. E.; Billeter, S. R.; Fennen, J.; Torda, A. E.; Huber, T.; Krüger, P.; van Gunsteren, W. F. The GROMOS Biomolecular Simulation Program Package. *J. Phys. Chem. A* **1999**, *103*, 3596–3607.

Darden, T.; York, D.; Pedersen, L. Particle Mesh Ewald: An N·log(N) Method for Ewald Sums in Large Systems. *J. Chem. Phys.* **1993**, *98*, 10089–10092.

Lennard-Jones, J. E. On the Determination of Molecular Fields. I. From the Variation of the Viscosity of a Gas with Temperature. *Proc. R. Soc. London, Ser. A* **1924**, *106*, 441–462.

Morse, P. M. Diatomic Molecules According to the Wave Mechanics. II. Vibrational Levels. *Phys. Rev.* **1929**, *34*, 57–64.

Buckingham, R. A. The Classical Equation of State of Gaseous Helium, Neon and Argon. *Proc. R. Soc. London, Ser. A* **1938**, *168*, 264–283.

Urey, H. C.; Bradley, L. M. The Relative Temperature Coefficients of the Vibrational Frequencies of Isotopic Molecules. *J. Chem. Phys.* **1934**, *2*, 375.

Ryckaert, J.-P.; Ciccotti, G.; Berendsen, H. J. C. Numerical Integration of the Cartesian Equations of Motion of a System with Constraints: Molecular Dynamics of n-Alkanes. *J. Comput. Phys.* **1977**, *23*, 327–341.

Allen, M. P.; Tildesley, D. J. *Computer Simulation of Liquids*; Clarendon Press: Oxford, 1987.

Frenkel, D.; Smit, B. *Understanding Molecular Simulation: From Algorithms to Applications*, 2nd ed.; Academic Press: San Diego, CA, 2002.

