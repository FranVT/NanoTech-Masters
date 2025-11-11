"""
    Figures for thesis
"""

using CairoMakie, LaTeXStrings

include("functions.jl")

rad_pat = 0.5;
rad_pac = 0.2;

eps_wca = 1;
eps_ij = 1;
eps_ik = 1;
eps_jk = 1;

w = 1;

# Distances domain
r=range(1e-10,1.5*(2*rad_pac),length=500);

# Distances between patches for 3 body potential
r_lm=0.45;
r_ln=0.47;


# Evaluation of potentials
Upatch_ij=map(s->Upatch(eps_ij,2*rad_pac,s),r);
Uwca=map(s->WCA(eps_wca,2*rad_pat,s),r);


UsPWell=map(s->SwapU(w,eps_ij,eps_ik,eps_jk,2*rad_pac,2*rad_pac,s,1.5*2*rad_pac),r);  
UsPoff=map(s->SwapU(w,eps_ij,eps_ik,eps_jk,2*rad_pac,2.5*rad_pac,s,1.5*2*rad_pac),r);  



#SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)


# 3 body of patch i
swap_w_i=map(s->SwapU(w,eps_ij,eps_ik,eps_jk,2*rad_pac,s,r_ln,1.5*2*rad_pac),r);
swap_2w_i=map(s->SwapU(2*w,eps_ij,eps_ik,eps_jk,2*rad_pac,s,r_ln,1.5*2*rad_pac),r);

# Figure

    # these are relative to 1 CSS px
    inch = 96
    pt = 4/3
    cm = inch / 2.54


fig_patch=Figure(size=(12cm,6cm),backgroundcolor = :transparent);
ax_pot = Axis(fig_patch[1:1,1:1],
            xlabel = L"\mathrm{Distance~between~patches}",
            ylabel = L"U_{\mathrm{patch}}(r)",
            titlesize = 24pt,
            xticklabelsize = 18pt,
            yticklabelsize = 18pt,
            xlabelsize = 20pt,
            ylabelsize = 20pt,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(rad_pac,last(r),-1.5*eps_ij,1.5*eps_ij),
            backgroundcolor = :transparent
         )

#lines!(ax_pot,r,Uwca, linewidth=0.1cm)
lines!(ax_pot,r,Upatch_ij)
lines!(ax_pot,r,UsPWell)
#lines!(ax_pot,r,UsPoff)



#lines!(ax_pot,r,Upatch_ij.+swap_w_i)
#lines!(ax_pot,r,Upatch_ij.+swap_2w_i)



