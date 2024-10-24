# Nanotechonolgy Masters degree homeworks and othre stuff

Hello, this repository is created for my Master's Degree project and miscellaneous content like notes or homeworks.
The "main" directory of the repository is "Tesis" where you can find files and documentations that I have been developing for the Thesis project.
The rest of directories will be focused for class notes or homeworks or other stuff.



# Tesis

The main goal of the project is to explore the mechanical response of soft matter under shear deformations.
Whereas it is known that is complicated to find funding for experimental set ups in Mexico, the exploration is performed by means of computer simulations.

The soft matter system is based on a model for hydro-gels[^1] using patchy particles and the main numeric tool is LAMMPS [[2]](#2).
This model utilizes implicit liquid phase, via langevin thermostat, and the patchy particles are the solid phase of the gel.
Our main interest is how the networks structures of the gels affect the mechanical response.

The goals of the simulations are,
- Retrieve a yield stress graph. (Stress vs shear rate).
- Explore mechanical response with different networks structures. (We change the network structure by changing the Cross-Linker concentration).
- Use 3 different models for the gel.
   - The first model allows free re-configuration of pair-wise interactions between all patchy particles.
   - The second model allows only free re-configuration of pair-wise interactions for Cross-Linker with Monomers.
   - The third model does not allow free re-configuration of pair-wise interactions.




---

# People in the project

- Advisors:
   - Antonio Ortiz
   - Claudia Ferreiro
- Students
   - Fco. Vazquez
   - Felipe Benavides (Help with the yield stress behaviour and development of the LAMMPS scripts.)

---

# Bibliography

<a id="2">[2]</a>
LAMMPS - a flexible simulation tool for particle-based materials modeling at the atomic, meso, and continuum scales, A. P. Thompson, H. M. Aktulga, R. Berger, D. S. Bolintineanu, W. M. Brown, P. S. Crozier, P. J. in 't Veld, A. Kohlmeyer, S. G. Moore, T. D. Nguyen, R. Shan, M. J. Stevens, J. Tranchida, C. Trott, S. J. Plimpton, Comp Phys Comm, 271 (2022) 10817.

--- 

# Folders:
1. 1_SisCom
    - code
        - hw1: A gas in a Lennard-Jones box
        - hw2: Periodic Boundary Conditions
        - hw3: A binay mixture
        - hw4: Polymer chains
        - hw5: Poisson and Birth-Death Processes
        - hw6: Monter Carlo Methods
        - hw7: Metropolis Algorithm and Ising Model
        - hw8: Diffusion and Wave Propagation
        - hw9: Finite Element Method
    - data
        - data n
2. Tesis
    - lammps

---

# Footnotes

[^1]: So...  technically, this simulations are not modeling Hydro-gels because there is no swelling mechanism added.
However, it does simulate a gel.

 
