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
m=2^5;
rlim=3;
xdom=-rlim:rad_pat/m:rlim;
ydom=-rlim:rad_pat/m:rlim;

fig=Figure(size=(920,920));

# Patch potential
ax_pot = Axis(fig[1,1],
            title = L"\mathrm{Patch~potential}",
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

xp_1=sig_pat/2;
yp_1=0;
patch1_eval=reduce(hcat,map(y->map(x->Upatch(eps_ij,sig_pac,sqrt((x-xp_1)^2+(y-yp_1)^2)),xdom),ydom));

xp_2=-sig_pat/2;
yp_2=0;
patch2_eval=reduce(hcat,map(y->map(x->Upatch(eps_ij,sig_pac,sqrt((x-xp_2)^2+(y-yp_2)^2)),xdom),ydom));

xp_3=0;
yp_3=sig_pat/2;
patch3_eval=reduce(hcat,map(y->map(x->Upatch(eps_ij,sig_pac,sqrt((x-xp_3)^2+(y-yp_3)^2)),xdom),ydom));

tot=patch1_eval.+patch2_eval.+patch3_eval;
heatmap!(ax_pot,xdom,ydom,tot,colormap=clmap,colorrange=(-2,2))

Colorbar(fig[1,2],colormap=clmap,limits=(-2,2))


# Swap potential
fig_swap=Figure(size=(920,920));
ax_swap = Axis(fig_swap[1,1],
            title = L"\mathrm{Swap~potential}",
            xlabel = L"d_{ij}",
            ylabel = L"d_{ik}",
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
m=2^7;
rlim=3;

d_ij=0:sig_pac/m:2*sig_pac;
d_ik=0:sig_pac/m:2*sig_pac;

swap_eval = reduce(hcat,map(s->map(r->SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r,s,1.5*sig_pac),d_ij),d_ik));

heatmap!(ax_swap,d_ij,d_ik,swap_eval,colormap=clmap,colorrange=(-2,2))

Colorbar(fig_swap[1,2],colormap=clmap,limits=(-2,2))



# Try to analyze the swap potential
fig_3body=Figure(size=(920,920));
ax_3body = Axis(fig_3body[1,1],
            title = L"\mathrm{Swap~potential}",
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

th_1=0;
th_2=pi/3;
th_3=-pi/3;

patch_1=(0,0);
patch_2=(0.25,0.5);
patch_3=(0.5,0);


jsjs=[[rad_pac*cos(s) rad_pac*sin(s)] for s in 0:pi/32:2*pi]


# Patches
scatter!(ax_3body,patch_1, marker = Circle, markersize = 15)
lines!(ax_3body,first.(jsjs).+first(patch_1),last.(jsjs).+last(patch_1))

scatter!(ax_3body,patch_2, marker = Circle, markersize = 15)
lines!(ax_3body,first.(jsjs).+first(patch_2),last.(jsjs).+last(patch_2))

scatter!(ax_3body,patch_3, marker = Circle, markersize = 15)
lines!(ax_3body,first.(jsjs).+first(patch_3),last.(jsjs).+last(patch_3))

# Distances and stuff
bracket!(patch_1..., patch_2..., offset = 5, text = "Distance ij", style = :square)
bracket!(patch_1..., patch_3..., offset = 5, text = "Distance ik", style = :square)
bracket!(patch_2..., patch_3..., offset = 5, text = "Distance kj", style = :square)






function figureMonPot()

clmap = :berlin;

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
heatmap!(ax_pot,xdom,ydom,tot,colormap=clmap,colorrange=(-2,2))
#heatmap!(ax_pot,xdom,ydom,wca_eval)

Colorbar(fig[1,2],colormap=clmap,limits=(-2,2))

end



#=
wcaF_eval = map(r->-DiffWCAEval(eps_wca,sig_pat,r),range(r_pat...,length=100));

patch_eval = map(r->Upatch(eps_ij,sig_pac,r),range(r_pac...,length=100));
patchF_eval = map(r->-DiffUpatchEval(eps_ij,sig_pac,r),range(r_pac...,length=100));

swap_eval = map(r_ik->map(r_ij->SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik,1.5*sig_pac),range(r_pac...,length=100)),range(r_pc2...,length=M));
swapF_eval = map(r_ik->map(r_ij->forceSwap(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik),range(r_pac...,length=100)),range(r_pc2...,length=M));

patch_total = map(s-> patch_eval .+ s, swap_eval);
patchF_total = map(s-> patchF_eval .+ s, swapF_eval);
=#


