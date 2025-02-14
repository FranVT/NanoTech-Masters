"""
    Simulate a Poisson process
"""

# Packages
using StatsBase
using Plots, LaTeXStrings
gr()

# Process parameters
"""
    t:      Time instant [s]
    λ:      Sucess probability [~]
    c:      Complement probability
    N:      Number of realizations
    tf:     Final time [s]
"""
t = 1e-2;
λ = 3*t;
c = 1-λ;
N = 1;
tf = 100;

# Computational parametrs 
"""
    Nt: Temporal nodes
"""
Nt = length(range(0,tf,step=t));

# Numerical experiment
state = [0 1];
probs = [c,λ];
test = sample(state,Weights(probs),(N,Nt));

# Events
events = cumsum(test,dims=2);

# Plots 
PPg = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Poisson~Process}",
    xlabel = L"\mathrm{time}~[s]",
    ylabel = L"\mathrm{Sucess}",
    #minorgrid = true;
    #minorgridalpha = 0.5,
    size = (1.5*480,480),
    #aspect_ratio = 2/4,
    gridalpha = 1,
    framestyle = :box,
    linewidth=2
)
plot!(range(0,tf,step=t),events',
label = L"\mathrm{Sucesses~over~time}")

savefig(PPg,"poissonProcess.pdf")