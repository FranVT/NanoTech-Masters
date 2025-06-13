"""
    Script to plot the potentials and the forces for the patchy-particle simulation
"""

using GLMakie

include("functions.jl")


# Parameters
N = 100;
M = 8;
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
r_pat = (0.2,sig_pat*2^(1/6));
r_pac = (0.2,1.5*sig_pac);
r_pc2 = (0.4,0.6);

# Evaluation of the functions and the forces
wca_eval = map(r->WCA(eps_wca,sig_pat,r),range(r_pat...,length=100));
wcaF_eval = map(r->-DiffWCAEval(eps_wca,sig_pat,r),range(r_pat...,length=100));

patch_eval = map(r->Upatch(eps_ij,sig_pac,r),range(r_pac...,length=100));
patchF_eval = map(r->-DiffUpatchEval(eps_ij,sig_pac,r),range(r_pac...,length=100));

swap_eval = map(r_ik->map(r_ij->SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik,1.5*sig_pac),range(r_pac...,length=100)),range(r_pc2...,length=M));
swapF_eval = map(r_ik->map(r_ij->forceSwap(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik),range(r_pac...,length=100)),range(r_pc2...,length=M));

patch_total = map(s-> patch_eval .+ s, swap_eval);
patchF_total = map(s-> patchF_eval .+ s, swapF_eval);


clmap = :Dark2_8;

fig=Figure(size=(1080,920));
ax_pot1 = Axis(fig[1:2,1:2],
            title = L"\mathrm{Individual~Potentials}",
            xlabel = L"\mathrm{Distance}~i-j",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(r_pac...,-3,3)
         )
ax_pot2 = Axis(fig[1:2,3:4],
            title = L"\mathrm{Total~Potential}",
            xlabel = L"\mathrm{Distance}~i-j",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(r_pac...,-3,3)
         )


ax_force1 = Axis(fig[3:4,1:2],
            title = L"\mathrm{Individual~Forces}",
            xlabel = L"\mathrm{Distance}~i-j",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(r_pac...,-30,30)
         )
ax_force2 = Axis(fig[3:4,3:4],
            title = L"\mathrm{Total~Force}",
            xlabel = L"\mathrm{Distance}~i-j",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(r_pac...,-30,30)
         )


#lines!(ax,range(r_pat...,length=100),wca_eval,label=L"\mathrm{WCA}(r)")
#lines!(ax,range(r_pat...,length=100),wcaF_eval,label=L"\partial_r\mathrm{WCA}(r)")
lines!(ax_pot1,range(r_pac...,length=100),patch_eval,label=L"\mathrm{U}_{\mathrm{patch}}(r_{ij},r_{ik})")
series!(ax_pot1,range(r_pac...,length=100),reduce(hcat,swap_eval)',
        labels=[L"\mathrm{U}_{\mathrm{swap}}(r_{ij},%$i) " for i in round.(range(r_pc2...,length=M),digits=3)],
        color=clmap
       )
series!(ax_pot2,range(r_pac...,length=100),reduce(hcat,patch_total)',
        labels=[L"\mathrm{U}_{\mathrm{total}}(r_{ij},%$i) " for i in round.(range(r_pc2...,length=M),digits=3)],
        color=clmap
       )


lines!(ax_force1,range(r_pac...,length=100),patchF_eval,label=L"\partial_r\mathrm{U}_{\mathrm{patch}}(r)")
series!(ax_force1,range(r_pac...,length=100),reduce(hcat,swapF_eval)',
        labels=[L"\partial_r\mathrm{U}_{\mathrm{swap}}(r_{ij},%$i) " for i in round.(range(r_pc2...,length=M),digits=3)],
        color=clmap
       )
series!(ax_force2,range(r_pac...,length=100),reduce(hcat,patchF_total)',
        labels=[L"\partial_r\mathrm{U}_{\mathrm{total}}(r_{ij},%$i) " for i in round.(range(r_pc2...,length=M),digits=3)],
        color=clmap
       )




axislegend(ax_pot1,position = :lb,orientation=:horizontal,nbanks=3,labelsize=20)
axislegend(ax_pot2,position = :lb,orientation=:horizontal,nbanks=4,labelsize=20)

axislegend(ax_force1,position = :lb,orientation=:horizontal,nbanks=3,labelsize=20)
axislegend(ax_force2,position = :lb,orientation=:horizontal,nbanks=4,labelsize=20)




