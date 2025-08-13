<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# What are the typical potentials used in molecuar dynamics simulaitons to represent covalent bonds and non covalent bonds?

In molecular dynamics (MD) simulations, the interactions between atoms are modeled using potential functions, commonly known as force fields. These potentials describe both covalent bonds (bonded interactions) and non-covalent bonds (non-bonded interactions). Here's an overview of typical potentials used for each:

### Covalent Bonds (Bonded Potentials)

These potentials model the strong, directional interactions that keep atoms connected in molecules. Typical potential terms include:

- **Bond Stretching:** Usually represented by a harmonic potential similar to a spring:

$$
U_{\text{bond}} = \frac{1}{2} k_b (r - r_0)^2
$$

where $r$ is the bond length, $r_0$ is the equilibrium bond length, and $k_b$ is the bond stiffness constant.
- **Angle Bending:** Also modeled by harmonic potentials:

$$
U_{\text{angle}} = \frac{1}{2} k_\theta (\theta - \theta_0)^2
$$

where $\theta$ is the bond angle, $\theta_0$ is the equilibrium angle, and $k_\theta$ is the force constant.
- **Torsional (Dihedral) Potentials:** Often represented by periodic cosine functions to describe rotation about bonds:

$$
U_{\text{torsion}} = \sum_n \frac{1}{2} V_n [1 + \cos(n\phi - \gamma)]
$$

where $\phi$ is the dihedral angle, $V_n$ the barrier height, $n$ the periodicity, and $\gamma$ the phase.
- **Improper Torsions:** Sometimes used to maintain planarity or chirality.


### Non-Covalent Bonds (Non-bonded Potentials)

These include weaker, longer-range interactions such as van der Waals forces and electrostatics.

- **Van der Waals (vdW) Interactions:** Typically modeled using the Lennard-Jones 12-6 potential:

$$
U_{\text{vdW}} = 4\epsilon \left[ \left(\frac{\sigma}{r}\right)^{12} - \left(\frac{\sigma}{r}\right)^6 \right]
$$

where $r$ is the distance between atoms, $\epsilon$ is the depth of the potential well, and $\sigma$ is the distance at which the inter-particle potential is zero.
- **Electrostatic Interactions:** Modeled via Coulomb's law:

$$
U_{\text{elec}} = \frac{1}{4\pi\epsilon_0} \frac{q_i q_j}{r}
$$

where $q_i$ and $q_j$ are the charges on atoms $i$ and $j$, respectively.

Additional refined potentials and models can be used for specific cases, including polarizable force fields or reactive force fields that can model bond formation and breaking more realistically.

### Summary

| Interaction Type | Typical Potential Form | Description |
| :-- | :-- | :-- |
| Covalent bonds | Harmonic bond, angle potentials; torsional potentials (periodic cosine) | Strong interactions fixing molecular structure |
| Non-covalent bonds | Lennard-Jones 12-6 potential; Coulomb's law | Weak, long-range interactions such as vdW and electrostatics |

These potentials form the backbone of classical MD force fields such as AMBER, CHARMM, OPLS, and GROMOS. More advanced potentials like reactive force fields (e.g., AIREBO) may be used for simulating bond breaking/forming events and reactive chemistry.

This framework offers a practical balance between computational efficiency and accuracy for studying the molecular-level behavior of systems.[^1_1][^1_19][^1_20]

If you want, I can provide specific examples of popular force fields and their functional forms used in molecular dynamics simulations.

<div style="text-align: center">⁂</div>

[^1_1]: https://pubs.aip.org/adv/article/12/10/105223/2820060/Molecular-dynamics-study-on-the-thermal

[^1_2]: https://link.springer.com/10.1007/s00894-024-06222-6

[^1_3]: https://xlink.rsc.org/?DOI=D3CP03828A

[^1_4]: https://pubs.aip.org/jcp/article/159/16/164104/2918209/Quantum-mechanics-based-non-bonded-force-field

[^1_5]: https://pubs.acs.org/doi/10.1021/acsbiomaterials.5c00089

[^1_6]: https://www.mdpi.com/2076-3417/15/1/307

[^1_7]: https://onlinelibrary.wiley.com/doi/10.1002/er.8634

[^1_8]: https://xlink.rsc.org/?DOI=C9RA10218C

[^1_9]: https://www.mdpi.com/1420-3049/27/3/706

[^1_10]: https://www.mdpi.com/1422-0067/22/15/8033

[^1_11]: https://www.mdpi.com/2073-4352/7/7/212/pdf?version=1499851562

[^1_12]: https://pmc.ncbi.nlm.nih.gov/articles/PMC8003638/

[^1_13]: http://arxiv.org/pdf/1710.00941.pdf

[^1_14]: https://pmc.ncbi.nlm.nih.gov/articles/PMC10308531/

[^1_15]: https://www.mdpi.com/1420-3049/29/14/3258

[^1_16]: https://arxiv.org/pdf/1405.1771.pdf

[^1_17]: https://pmc.ncbi.nlm.nih.gov/articles/PMC6910608/

[^1_18]: https://www.mdpi.com/1420-3049/24/3/379/pdf

[^1_19]: https://pubs.aip.org/aip/jcp/article/151/15/154111/1019552/Accurate-non-bonded-potentials-based-on-periodic

[^1_20]: https://en.wikipedia.org/wiki/Molecular_dynamics

