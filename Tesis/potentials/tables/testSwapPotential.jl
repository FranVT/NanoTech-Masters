"""
    Script to analyses the swap potential
"""

using Plots, LaTeXStrings

## Tabuling for plots

# My functions
function U3Fran(eps_pair,eps_3,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < sig_p 
        return 1.0
    elseif r >= 1.5*sig_p
        return 0.0 
    else 
        return -( 2*eps_pair*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2) )./eps_3
    end
end


function SwapUFran(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    Potential for the swap mechanism
"""
    return round(w.*eps_jk.*U3Fran(eps_ij,eps_jk,sig_p,r_ij).*U3Fran(eps_ik,eps_jk,sig_p,r_ik),digits=2^7)
end

function ForceFranij(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    -d/drij SwapU
"""
    if r_ij > rc || r_ij < sig_p
        return 0.0 
    else 
        t1 = (sig_p/(r_ij-r_c)^2)*(1/r_ij^5)*(4*r_c^2*sig_p^3+sig_p^3*(sig_p-8*r_c)*r_ij-2*r_ij^5+4*r_ij^2*sig_p^3);
        t2 = (sig_p/r_ik)^4-2;
        t3 = exp(sig_p*(1/(r_ij-r_c)+1/(r_ik-r_c))+4);
        return round(w*eps_jk*t1*t2*t3,digits=2^7)
    end
end

function ForceFranik(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    -d/drik SwapU
"""
    if r_ik > rc || r_ik < sig_p
        return 0.0 
    else 
        t1 = (sig_p/(r_ik-r_c)^2)*(1/r_ik^5)*(4*r_c^2*sig_p^3+sig_p^3*(sig_p-8*r_c)*r_ik-2*r_ik^5+4*r_ik^2*sig_p^3);
        t2 = (sig_p/r_ij)^4-2;
        t3 = exp(sig_p*(1/(r_ij-r_c)+1/(r_ik-r_c))+4);
        return round(w*eps_jk*t1*t2*t3,digits=2^7)
    end
end

function centralDifferences(ran,dom)
"""
    Get the central finite difference given the range and domain.
"""
    dh=step(ran);
    return (1/(2*dh)).*(dom[2:end].-dom[1:end-1]);
end

function centralDiffEval(dh,w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    Get the central finite difference given the value of the position and the function.
"""
    dh=1e-6;
    fo=SwapUFran(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij+dh,r_ik,r_c)
    ff=SwapUFran(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij-dh,r_ik,r_c)
    return (1/(2*dh))*( fo - ff );
end


# Parameters
N = 250;
M = 2*N*N*N;

eps_ij = 1.0;
eps_ik = 1.0;
eps_jk = 1.0;
sig = 0.4;
rc = 1.5*sig;
rmin = sig/1000;
rmax = 2*sig;
thi = 180/(4*N)
thf = 180 - thi;
w=1;

# Create the domains of evaluation according filename nessetities
th_dom = range(thi,thf,2*N);
r_dom = range(rmin,rmax,N);

## Evaluate the tables and create the figure
doms=reduce(vcat,Iterators.product(r_dom,r_dom));

eval_swapUFran=Iterators.partition(map(s->SwapUFran(w,eps_ij,eps_ik,eps_jk,sig,s...,rc),doms),div(length(doms),N))|>collect;

#eval_ForceFranij=map(s->-centralDifferences(r_dom,s),eval_swapUFran);
#Iterators.partition(map(s->-centralDifferences(r_dom,s),eval_swapUFran),div(length(doms),N))|>collect;

#eval_ForceFranik=Iterators.partition(map(s->ForceFranik(w,eps_ij,eps_ik,eps_jk,sig,s...,rc),doms),div(length(doms),N))|>collect;

dh=step(r_dom);
eval_ForceFranij=Iterators.partition(map(s->-centralDiffEval(dh,w,eps_ij,eps_ik,eps_jk,sig,s...,rc),doms),div(length(doms),N))|>collect;
eval_ForceFranik=Iterators.partition(map(s->-centralDiffEval(dh,w,eps_ij,eps_ik,eps_jk,sig,reverse(s)...,rc),doms),div(length(doms),N))|>collect;

# Some modifications
doms=Iterators.partition(doms,div(length(doms),N))|>collect;

ind_aux=range(1,N,step=div(N,10));
lbl=round.(reshape(last.(last.(doms[ind_aux])),1,length(ind_aux)),digits=6);

# Graphic of the potential
fig_FranPot=plot(
                  title=L"\mathrm{Swap~Potential~Fran}",
                  xlabel=L"r_{ij}",
                  ylabel=L"U(w,\epsilon_{ij},\epsilon_{ik},\epsilon_{jk},\sigma;~r_{ij},r_{ik})"#,
                 #palette=:batlow
                )
plot!(fig_FranPot,r_dom,reduce(hcat,eval_swapUFran[ind_aux]),label=false,color=:black)
scatter!(fig_FranPot,r_dom,eval_swapUFran[ind_aux],leg_title=L"r_{ik}",label=lbl)

# Graph for the force.
fig_FranForce=plot(
                  title=L"\mathrm{Swap~Force~Fran}",
                  xlabel=L"r_{ij}",
                  ylabel=L"F_{ij}(w,\epsilon_{ij},\epsilon_{ik},\epsilon_{jk},\sigma;~r_{ij},r_{ik})",
                  xlims=(sig/2,rmax),
                  ylims=(0,10)
                  #,palette=:batlow
                )
plot!(fig_FranForce,r_dom,reduce(hcat,eval_swapUFran[ind_aux]),label=false)
#plot!(fig_FranForce,r_dom[1:end-1],reduce(hcat,eval_ForceFranij[ind_aux]),label=false,color=:black)
#scatter!(fig_FranForce,r_dom[1:end-1],eval_ForceFranij[ind_aux],leg_title=L"r_{ik}",label=lbl)
scatter!(fig_FranForce,r_dom,eval_ForceFranij[ind_aux],leg_title=L"r2_{ik}",label=lbl)
scatter!(fig_FranForce,r_dom,eval_ForceFranik[ind_aux],leg_title=L"r2_{ik}",label=lbl)

#=
# Graph Normalize force
max_auxs=maximum.(map(s->abs.(s),eval_ForceFranij));
norm_ForceFranij=eval_ForceFranij./max_auxs;

fig_FranForceNorm=plot(
                  title=L"\mathrm{Normalize~Swap~Force~Fran}",
                  xlabel=L"r_{ij}",
                  ylabel=L"F_{ij}(w,\epsilon_{ij},\epsilon_{ik},\epsilon_{jk},\sigma;~r_{ij},r_{ik})",
                  ylims=(-1.5,1.5)
                  #,palette=:batlow
                )
plot!(fig_FranForceNorm,r_dom,reduce(hcat,eval_swapUFran[ind_aux]),label=false)
plot!(fig_FranForceNorm,r_dom,reduce(hcat,norm_ForceFranij[ind_aux]),label=false,color=:black)
scatter!(fig_FranForceNorm,r_dom,norm_ForceFranij[ind_aux],leg_title=L"r_{ik}",label=lbl)

=#



