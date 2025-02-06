"""
    Script to plot the potentials and the forces for the patchy-particle simulation
"""

using GLMakie

include("functions.jl")


# Parameters
N = 100;
rad_pat = 0.5;
rad_pac = 0.2;

sig_pat = 2*rad_pat;
sig_pac = 2*rad_pac;

eps_wca = 1;
eps_ij = 1;
eps_ik = 1;
eps_jk = 1;

# Distance domain
r_pat = (sig_pat/1000,sig_pat*2^(1/6));
r_pac = (sig_pac/1000,1.5*sig_pac);

# Evaluation of the functions and the forces
wca_eval = map(r->WCA(eps_wca,sig_pat,r),range(r_pat...,length=100));
wcaF_eval = map(r->-DiffWCAEval(eps_wca,sig_pat,r),range(r_pat...,length=100));

_eval = map(r->WCA(eps_wca,sig_pat,r),range(r_pat...,length=100));
F_eval = map(r->-DiffWCAEval(eps_wca,sig_pat,r),range(r_pat...,length=100));




fig=Figure(size=(1080,920));
ax = Axis(fig[1:2,1:2],
            title = L"\mathrm{WCA~potential}",
            xlabel = L"\mathrm{Distance}",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(r_pat...,-10,10)
            #xlims = r_pat,
            #ylims = (-10,10)
         )
lines!(ax,range(r_pat...,length=100),wca_eval,label=L"\mathrm{WCA}(r)")
lines!(ax,range(r_pat...,length=100),wcaF_eval,label=L"\partial_r\mathrm{WCA}(r)")
axislegend(ax,position = :lb,orientation=:horizontal)


