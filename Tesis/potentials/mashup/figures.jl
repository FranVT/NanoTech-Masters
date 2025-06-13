#=
    Script to create figures of the potentials with different parameters
=#

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
r_pat = range(sig_pac,sig_pat*2^(1/6),length=N);
r_pac = (sig_pac,1.5*sig_pac);
r_pc2 = (sig_pac,1.5*sig_pac);

# Evaluation of the functions and the forces
#wca_eval = map(r->WCA(eps_wca,sig_pat,r),r_pat);


clmap = :Dark2_8;

fig=Figure(size=(920,920));
ax_pot = Axis(fig[1,1],
            title = L"\mathrm{Monomer~potential}",
            xlabel = L"x",
            ylabel = L"y",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            #limits=(r_pac...,-3,3)
         )

n=2;
m=2^5;
rlim=3;
xdom=-rlim:rad_pat/m:rlim;
ydom=-rlim:rad_pat/m:rlim;

wca_eval=reduce(hcat,map(y->map(x->WCA(eps_wca,sig_pat,sqrt(x^2+y^2)),xdom),ydom));

xp=sig_pat;
yp=0;
patch1_eval=reduce(hcat,map(y->map(x->Upatch(eps_ij,sig_pac,sqrt((x-xp)^2+(y-yp)^2)),xdom),ydom));
xp=-sig_pat;
yp=0;
patch2_eval=reduce(hcat,map(y->map(x->Upatch(eps_ij,sig_pac,sqrt((x-xp)^2+(y-yp)^2)),xdom),ydom));


tot=wca_eval.+patch1_eval.+patch2_eval;
heatmap!(ax_pot,xdom,ydom,tot,colormap=:berlin,colorrange=(-2,2))
#heatmap!(ax_pot,xdom,ydom,wca_eval)

Colorbar(fig[1,2],colormap=:berlin,limits=(-2,2))


patch_eval = map(r->Upatch(eps_ij,sig_pac,r),abs.(xdom));


#=
wcaF_eval = map(r->-DiffWCAEval(eps_wca,sig_pat,r),range(r_pat...,length=100));

patch_eval = map(r->Upatch(eps_ij,sig_pac,r),range(r_pac...,length=100));
patchF_eval = map(r->-DiffUpatchEval(eps_ij,sig_pac,r),range(r_pac...,length=100));

swap_eval = map(r_ik->map(r_ij->SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik,1.5*sig_pac),range(r_pac...,length=100)),range(r_pc2...,length=M));
swapF_eval = map(r_ik->map(r_ij->forceSwap(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik),range(r_pac...,length=100)),range(r_pc2...,length=M));

patch_total = map(s-> patch_eval .+ s, swap_eval);
patchF_total = map(s-> patchF_eval .+ s, swapF_eval);
=#


