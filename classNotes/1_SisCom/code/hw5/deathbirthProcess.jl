"""
    Simulate a death and birth process
"""

# Packages
using StatsBase
using Plots, LaTeXStrings
gr()

# Process parameters
"""
    t:      Time instant [s]
    β:      Birth probability [~]
    γ:      Death probability
    c:      Complement probability
    N:      Number of realizations
    tf:     Final time [s]
"""
t = 1e-2;
β = 3*t;
γ = 1*t;
c = 1-(β+γ);
N = 20000;
tf = 100;

# Computational parametrs 
"""
    Nt: Temporal nodes
"""
Nt = length(range(0,tf,step=t));

# Numerical experiment
state = [-1 0 1];
probs = [γ,c,β];
test = sample(state,Weights(probs),(N,Nt));

# population
events = cumsum(test,dims=2);

# Sucess at specific time
times = (0,25,50,75,100);
id = collect(Iterators.flatten(map(s->findall(x->x==s,range(0,tf,step=t)),times)));

info = map(s->events[:,id[s]],1:length(times));

# Graphics
HPPg = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Histograms~of~the~total~population~at~different~times}",
    xlabel = L"\mathrm{Number~of~persons}",
    ylabel = L"\mathrm{Counts}",
    size = (1.5*480,480),
    framestyle = :box,
    gridaplha = 1
)
map(s->histogram!(HPPg,info[s],label=latexstring("t=$(times[s])")),1:length(times))
display(HPPg)

savefig(HPPg,"bdProcessHistograms.pdf")

# Plotting the average and sigma squared
μ = mean(events,dims=1);
σ2 = mean(events.^2,dims=1).-μ.^2;

μσplot = plot(
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    title = L"\mathrm{Average~and~Variance}",
    xlabel = L"\mathrm{Time~}[s]",
    size = (1.5*480,480),
    framestyle = :box,
    gridaplha = 1
)
μσplot_twin = twinx(μσplot)

plot!(μσplot,range(0,tf,step=t),μ',
    ylabel=L"\langle n(t) \rangle",
    label = L"\langle n(t) \rangle",
    legend_position =:topleft,
    linestyle =:dash,
    linewidth = 3,
    linecolor = :purple,
    linealpha = 0.7,
    annotations = (15, 250, Plots.text(L"\langle n(100)\rangle=300.025",12))
)
plot!(μσplot_twin,range(0,tf,step=t),σ2',
    ylabel=L"\sigma^{2}(t)",
    label = L"\sigma^{2}(t)",
    legend_position =:bottomright,
    linestyle =:dashdotdot,
    linewidth = 3,
    linecolor = :darkorange,
    linealpha = 0.7
)

display(μσplot)

savefig(μσplot,"bdProcessAvergeVariance.pdf")
