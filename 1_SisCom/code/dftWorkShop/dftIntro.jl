"""
    Script of the DFT workshop
"""

# Pakages
using ASEconvert
using AtomsIO
using AtomsIOPython
using AtomsView
using DFTK
using Molly
using PlutoUI
using GLMakie
using LinearAlgebra
using Unitful
using UnitfulAtomic

# Build an Silice atom
silicon_ase = ase.build.bulk("Si", cubic=true) * pytuple((4, 1, 1))
silicon_supercell = pyconvert(AbstractSystem, silicon_ase)

# REad and visualize
silicon_loaded = load_system("Si.extxyz")

HTML(AtomsView.visualize_structure(silicon_loaded, MIME("text/html")))


# Calculation with DFTK (Note: loaded already has pseudos attached)
model = model_PBE(silicon_loaded)
@show model.atoms
basis = PlaneWaveBasis(model; Ecut=15, kgrid=(4, 4, 4))
self_consistent_field(basis).energies.total

# Dont Knwon
n_atoms = 50
atom_mass = 10.0u"u"
atoms = [Molly.Atom(mass=atom_mass, σ=0.3u"nm", ϵ=0.2u"kJ * mol^-1") for i in 1:n_atoms]
boundary = CubicBoundary(2.0u"nm")  # Periodic boundary; 2 nm cube
coords   = place_atoms(n_atoms, boundary; min_dist=0.3u"nm")  # Random placement

temp = 100.0u"K"
velocities = [random_velocity(atom_mass, temp) for i in 1:n_atoms]

pairwise_inters = (LennardJones(), )  # LJ interactions

# Log every 10 steps
loggers = (; temp=TemperatureLogger(10), coords=CoordinateLogger(10))

sys = System(; atoms, coords, boundary, velocities, pairwise_inters, loggers)

# Compute stuff
simulator = VelocityVerlet(
    dt = 0.002u"ps",
    coupling = AndersenThermostat(temp, 1.0u"ps"),
);

simulate!(sys, simulator, 1_000);

visualize(sys.loggers.coords, boundary, "sim_lj.mp4")
LocalResource("sim_lj.mp4")
