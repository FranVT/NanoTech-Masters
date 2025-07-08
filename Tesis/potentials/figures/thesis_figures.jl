"""
    Figures for thesis
"""

using GLMakie, LaTeXStrings

include("functions.jl")

rad_pat = 0.5;
rad_pac = 0.2;

eps_wca = 1;
eps_ij = 1;
eps_ik = 1;
eps_jk = 1;

w = 1;

# Distances domain
r=range(1e-10,1.5*(2*rad_pac),length=100);

# Distances between patches for 3 body potential
r_lm=0.45;
r_ln=0.47;


# Evaluation of potentials
Upatch_ij=map(s->Upatch(eps_ij,2*rad_pac,s),r);

# 3 body of patch i
swap_w_i=map(s->SwapU(w,eps_ij,eps_ik,eps_jk,2*rad_pac,s,r_ln,1.5*2*rad_pac),r);
swap_2w_i=map(s->SwapU(2*w,eps_ij,eps_ik,eps_jk,2*rad_pac,s,r_ln,1.5*2*rad_pac),r);

# Figure
fig_patch=Figure(size=(1080,920));
ax_pot = Axis(fig_patch[1:1,1:1],
            xlabel = L"\mathrm{Distance~between~patch}~l-m",
            ylabel = L"U(r)",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(rad_pac,last(r),-1.5*eps_ij,1.5*w)
         )
lines!(ax_pot,r,Upatch_ij)
lines!(ax_pot,r,Upatch_ij.+swap_w_i)
lines!(ax_pot,r,Upatch_ij.+swap_2w_i)



