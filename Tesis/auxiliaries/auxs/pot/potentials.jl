"""
    Script to plot the potentials and the forces for the patchy-particle simulation
"""

using GLMakie

include("functions.jl")


# Parameters
N = 100;
M = 7;
rad_pat = 0.5;
rad_pac = 0.2;

sig_pat = 2*rad_pat;
sig_pac = 2*rad_pac;

eps_wca = 1;
eps_ij = 1;
eps_ik = 1;
eps_jk = 1;

w = 2;

# Distance domain
r_pat = (sig_pat/1000,sig_pat*2^(1/6));
r_pac = (sig_pac/1000,1.5*sig_pac);

# Evaluation of the functions and the forces
wca_eval = map(r->WCA(eps_wca,sig_pat,r),range(r_pat...,length=100));
wcaF_eval = map(r->-DiffWCAEval(eps_wca,sig_pat,r),range(r_pat...,length=100));

patch_eval = map(r->Upatch(eps_ij,sig_pac,r),range(r_pac...,length=100));
patchF_eval = map(r->-DiffUpatchEval(eps_ij,sig_pac,r),range(r_pac...,length=100));

swap_eval = map(r_ik->map(r_ij->SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik,1.5*sig_pac),range(r_pac...,length=100)),range(r_pac...,length=M));
swapF_eval = map(r_ik->map(r_ij->forceSwap(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik),range(r_pac...,length=100)),range(r_pac...,length=M));



fig=Figure(size=(1080,920));
ax_pot = Axis(fig[1:2,1:2],
            title = L"\mathrm{Potential~and~forces}",
            xlabel = L"\mathrm{Distance} i-j",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(r_pac...,-3,3)
            #xlims = r_pat,
            #ylims = (-10,10)
         )
ax_force = Axis(fig[3:4,1:2],
            title = L"\mathrm{Forces}",
            xlabel = L"\mathrm{Distance} i-j",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(r_pac...,-20,20)
            #xlims = r_pat,
            #ylims = (-10,10)
         )



#lines!(ax,range(r_pat...,length=100),wca_eval,label=L"\mathrm{WCA}(r)")
#lines!(ax,range(r_pat...,length=100),wcaF_eval,label=L"\partial_r\mathrm{WCA}(r)")
lines!(ax_pot,range(r_pac...,length=100),patch_eval,label=L"\mathrm{U}_{\mathrm{patch}}(r_{ij},r_{ik})")
lines!(ax_force,range(r_pac...,length=100),patchF_eval,label=L"\partial_r\mathrm{U}_{\mathrm{patch}}(r)")
series!(ax_pot,range(r_pac...,length=100),reduce(hcat,swap_eval)',
        labels=[L"\mathrm{U}_{\mathrm{patch}}(r_{ij},%$i) " for i in round.(range(r_pac...,length=M)./sig_pac,digits=3)]
       )
series!(ax_force,range(r_pac...,length=100),reduce(hcat,swapF_eval)',
        labels=[L"\partial_r\mathrm{U}_{\mathrm{patch}}(r_{ij},%$i) " for i in round.(range(r_pac...,length=M)./sig_pac,digits=3)]
       )



axislegend(ax_pot,position = :lb,orientation=:horizontal,nbanks=4,labelsize=20)
axislegend(ax_force,position = :lb,orientation=:horizontal,nbanks=4,labelsize=20)



