#=
    Script to create figures of the potentials with different parameters
=#

using GLMakie, LaTeXStrings

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

# Try to analyze the swap potential
fig_3body=Figure(size=(920,920));

# Position of the patches and color code
patch_1=(0,0);
patch_2=(-0.3,0.35);
patch_3=(0.3,0.35);

cl_1=Makie.wong_colors()[1];
cl_2=Makie.wong_colors()[2];
cl_3=Makie.wong_colors()[3];

cl_12=Makie.wong_colors()[4];
cl_13=Makie.wong_colors()[5];
cl_23=Makie.wong_colors()[6];

# Distances between the patches
r_ij=dist(patch_1,patch_2);
r_ik=dist(patch_1,patch_3);
r_jk=dist(patch_2,patch_3);


# Compute the patch potential
Upatch_ij=Upatch(eps_ij,sig_pac,r_ij);
Upatch_ik=Upatch(eps_ij,sig_pac,r_ik);
Upatch_jk=Upatch(eps_jk,sig_pac,r_jk);

# Swap potential
Uswap_i=SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik,1.5*sig_pac);
Uswap_j=SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r_jk,r_ij,1.5*sig_pac);
Uswap_k=SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r_jk,r_ik,1.5*sig_pac);

Utotal_i=Upatch_ij+Upatch_ik+Uswap_i;
Utotal_j=Upatch_ij+Upatch_jk+Uswap_j;
Utotal_k=Upatch_jk+Upatch_ik+Uswap_k;


# All patch potential
dom=sig_pac/2:sig_pac/100:2*sig_pac;
Upatch_all=map(r->Upatch(eps_ij,sig_pac,r),dom);

# All force 
Fpatch_all=map(r->-DiffUpatchEval(eps_ij,sig_pac,r),dom);

# Compute forces in each patch 
Fpatch_ij=-DiffUpatchEval(eps_ij,sig_pac,r_ij);
Fpatch_ik=-DiffUpatchEval(eps_ij,sig_pac,r_ik);
Fpatch_jk=-DiffUpatchEval(eps_jk,sig_pac,r_jk);

Fswap_i=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik);
Fswap_j=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_pac,r_jk,r_ij);
Fswap_k=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_pac,r_jk,r_ik);

# Patch i
Fpatchvec_ij=vectorForce(Fpatch_ij,patch_1,patch_2)
Fpatchvec_ik=vectorForce(Fpatch_ik,patch_1,patch_3)
Fswapvec_i=forceSwapvector(w,eps_ij,eps_ik,eps_jk,sig_pac,patch_1,patch_2,patch_3)

# Patch j
Fpatchvec_ji=(-1).*Fpatchvec_ij;
Fpatchvec_jk=vectorForce(Fpatch_jk,patch_2,patch_3)
Fswapvec_j=forceSwapvector(w,eps_ij,eps_ik,eps_jk,sig_pac,patch_2,patch_1,patch_3)


# Patch k
Fpatchvec_ki=(-1).*F_ik;
Fpatchvec_kj=(-1).*F_jk;
Fswapvec_k=forceSwapvector(w,eps_ij,eps_ik,eps_jk,sig_pac,patch_3,patch_1,patch_2)

# Total magnitude force
Ftotal_i=Fpatch_ij .+ Fpatch_ik .+ Fswap_i;
Ftotal_j=Fpatch_ij .+ Fpatch_jk .+ Fswap_j;
Ftotal_k=Fpatch_ik .+ Fpatch_jk .+ Fswap_k;

# Total force
Ftotalvec_i=Fpatchvec_ij .+ Fpatchvec_ik .+ Fswapvec_i;
Ftotalvec_j=Fpatchvec_ji .+ Fpatchvec_jk .+ Fswapvec_j;
Ftotalvec_k=Fpatchvec_ki .+ Fpatchvec_kj .+ Fswapvec_k;


# Plot the position of the patches
ax_pos = Axis(fig_3body[1:3,1:2],
            title = L"\mathrm{Position~of~the~patches}",
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
            aspect = AxisAspect(4/4),
            limits=(-3/4,3/4,-3/4,3/4)
         )

# Circle for the scatter
jsjs=[[rad_pac*cos(s) rad_pac*sin(s)] for s in 0:pi/32:2*pi]

# Patches
scatter!(ax_pos,patch_1, marker = Circle, markersize = 15, color = cl_1)
lines!(ax_pos,first.(jsjs).+first(patch_1),last.(jsjs).+last(patch_1), color = cl_1)

scatter!(ax_pos,patch_2, marker = Circle, markersize = 15, color = cl_2)
lines!(ax_pos,first.(jsjs).+first(patch_2),last.(jsjs).+last(patch_2), color = cl_2)

scatter!(ax_pos,patch_3, marker = Circle, markersize = 15, color = cl_3)
lines!(ax_pos,first.(jsjs).+first(patch_3),last.(jsjs).+last(patch_3), color = cl_3)

# Force of patch i
#arrows!(ax_pos,[first(patch_1)],[last(patch_1)],[first(F_ij)],[last(F_ij)], color = cl_1,linewidth=3,normalize=true,lengthscale=0.25)
#arrows!(ax_pos,[first(patch_1)],[last(patch_1)],[first(F_ik)],[last(F_ik)], color = cl_1,linewidth=3,normalize=true,lengthscale=0.25)
arrows!(ax_pos,[first(patch_1)],[last(patch_1)],[first(Fswapvec_i)],[last(Fswapvec_i)], color = (cl_1,0.5),linewidth=3,normalize=true,lengthscale=0.25)
arrows!(ax_pos,[first(patch_1)],[last(patch_1)],[first(Ftotalvec_i)],[last(Ftotalvec_i)], color = cl_1,linewidth=3,normalize=true,lengthscale=0.25)


# Force of patch j
#arrows!(ax_pos,[first(patch_2)],[last(patch_2)],[first(F_ji)],[last(F_ji)], color = cl_2,linewidth=3,normalize=true,lengthscale=0.25)
#arrows!(ax_pos,[first(patch_2)],[last(patch_2)],[first(F_jk)],[last(F_jk)], color = cl_2,linewidth=3,normalize=true,lengthscale=0.25)
arrows!(ax_pos,[first(patch_2)],[last(patch_2)],[first(Fswapvec_j)],[last(Fswapvec_j)], color = (cl_2,0.5),linewidth=3,normalize=true,lengthscale=0.25)
arrows!(ax_pos,[first(patch_2)],[last(patch_2)],[first(Ftotalvec_j)],[last(Ftotalvec_j)], color = cl_2,linewidth=3,normalize=true,lengthscale=0.25)

# Force of patch k
#arrows!(ax_pos,[first(patch_3)],[last(patch_3)],[first(F_ki)],[last(F_ki)], color = cl_3,linewidth=3,normalize=true,lengthscale=0.25)
#arrows!(ax_pos,[first(patch_3)],[last(patch_3)],[first(F_kj)],[last(F_kj)], color = cl_3,linewidth=3,normalize=true,lengthscale=0.25)
arrows!(ax_pos,[first(patch_3)],[last(patch_3)],[first(Fswapvec_k)],[last(Fswapvec_k)], color = (cl_3,0.5),linewidth=3,normalize=true,lengthscale=0.25)
arrows!(ax_pos,[first(patch_3)],[last(patch_3)],[first(Ftotalvec_k)],[last(Ftotalvec_k)], color = cl_3,linewidth=3,normalize=true,lengthscale=0.25)



# Distances and stuff
bracket!(patch_1..., patch_2..., offset = 5, text = latexstring("r_{ij}=",round(r_ij,digits=3)), fontsize = 30 , style = :square)
bracket!(patch_1..., patch_3..., offset = 5, text = latexstring("r_{ij}=",round(r_ik,digits=3)), fontsize = 30 , style = :square)
bracket!(patch_2..., patch_3..., offset = 5, text = latexstring("r_{ij}=",round(r_jk,digits=3)), fontsize = 30 , style = :square)


# Plot the potential of the patches
ax_pot = Axis(fig_3body[1:2,3:4],
            title = L"\mathrm{Potential}",
#            xlabel = L"\mathrm{Distance~between~patches}",
            ylabel = L"U(r)",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(first(dom),last(dom),-1.5*eps_ij,1.5*w)
         )
lines!(ax_pot,dom,Upatch_all,color=:black)
stem!(ax_pot,r_ij,Upatch_ij, color = cl_12,markersize=15)
stem!(ax_pot,r_ik,Upatch_ik, color = cl_13,markersize=15)
stem!(ax_pot,r_jk,Upatch_jk, color = cl_23,markersize=15)

#stem!(ax_pot,r_ij,Uswap_i, color = cl_1, marker=:rect,markersize=15)
#stem!(ax_pot,r_ik,Uswap_j, color = cl_2, marker=:rect,markersize=15)
#stem!(ax_pot,r_jk,Uswap_k, color = cl_3, marker=:rect,markersize=15)

hlines!(ax_pot,Uswap_i, color = (cl_1,0.5), linestyle=:dash)
hlines!(ax_pot,Uswap_j, color = (cl_2,0.5), linestyle=:dash)
hlines!(ax_pot,Uswap_k, color = (cl_3,0.5), linestyle=:dash)

hlines!(ax_pot,Utotal_i, color = (cl_1,1), linestyle=:solid)
hlines!(ax_pot,Utotal_j, color = (cl_2,1), linestyle=:solid)
hlines!(ax_pot,Utotal_k, color = (cl_3,1), linestyle=:solid)

ax_for = Axis(fig_3body[3:4,3:4],
            title = L"\mathrm{Force}",
            xlabel = L"\mathrm{Distance~between~patches}",
            ylabel = L"F(r)",
            titlesize = 24.0f0,
            xticklabelsize = 18.0f0,
            yticklabelsize = 18.0f0,
            xlabelsize = 20.0f0,
            ylabelsize = 20.0f0,
            xminorticksvisible = true, 
            xminorgridvisible = true,
            xminorticks = IntervalsBetween(5),
            limits=(first(dom),last(dom),-15*eps_ij,15*w)
         )
lines!(ax_for,dom,Fpatch_all,color=:black)
stem!(ax_for,r_ij,Fpatch_ij, color = cl_12,markersize=15)
stem!(ax_for,r_ik,Fpatch_ik, color = cl_13,markersize=15)
stem!(ax_for,r_jk,Fpatch_jk, color = cl_23,markersize=15)

hlines!(ax_for,r_ij,Fswap_i, color = (cl_1,0.5), linestyle=:dash)
hlines!(ax_for,r_ik,Fswap_j, color = (cl_2,0.5), linestyle=:dash)
hlines!(ax_for,r_jk,Fswap_k, color = (cl_3,0.5), linestyle=:dash)


hlines!(ax_for,Ftotal_i, color = cl_1)
hlines!(ax_for,Ftotal_j, color = cl_2)
hlines!(ax_for,Ftotal_k, color = cl_3)


linkxaxes!(ax_pot, ax_for)

elem_1 = [LineElement(color = :red, linestyle = nothing),
          MarkerElement(color = :blue, marker = 'x', markersize = 15,
          strokecolor = :black)]

elem_2 = [PolyElement(color = :red, strokecolor = :blue, strokewidth = 1),
          LineElement(color = :black, linestyle = :dash)]

elem_3 = LineElement(color = :green, linestyle = nothing,
        points = Point2f[(0, 0), (0, 1), (1, 0), (1, 1)])

elem_4 = MarkerElement(color = :blue, marker = 'π', markersize = 15,
        points = Point2f[(0.2, 0.2), (0.5, 0.8), (0.8, 0.2)])

elem_5 = PolyElement(color = :green, strokecolor = :black, strokewidth = 2,
        points = Point2f[(0, 0), (1, 0), (0, 1)])

Legend(fig_3body[4,1:2],
    [elem_1, elem_2, elem_3, elem_4, elem_5],
    ["Line & Marker", "Poly & Line", "Line", "Marker", "Poly"],
    patchsize = (35, 35), rowgap = 10,
    nbanks=2
   )



#=

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

=#

#=
wcaF_eval = map(r->-DiffWCAEval(eps_wca,sig_pat,r),range(r_pat...,length=100));

patch_eval = map(r->Upatch(eps_ij,sig_pac,r),range(r_pac...,length=100));
patchF_eval = map(r->-DiffUpatchEval(eps_ij,sig_pac,r),range(r_pac...,length=100));

swap_eval = map(r_ik->map(r_ij->SwapU(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik,1.5*sig_pac),range(r_pac...,length=100)),range(r_pc2...,length=M));
swapF_eval = map(r_ik->map(r_ij->forceSwap(w,eps_ij,eps_ik,eps_jk,sig_pac,r_ij,r_ik),range(r_pac...,length=100)),range(r_pc2...,length=M));

patch_total = map(s-> patch_eval .+ s, swap_eval);
patchF_total = map(s-> patchF_eval .+ s, swapF_eval);
=#


