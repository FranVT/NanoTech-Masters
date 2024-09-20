"""
    Script for correction in the potentials
"""

using GLMakie

# Create the functions
function Upatch(eps_pair,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < 1.5*sig_p 
        return 2*eps_pair*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2) 
    else
        return 0.0
    end
end

# Create the functions
function U3(eps_pair,eps_3,sig_p,r)
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

function SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    Potential for the swap mechanism
"""
    return w.*eps_jk.*U3(eps_ij,eps_jk,sig_p,r_ij).*U3(eps_ik,eps_jk,sig_p,r_ik)
end


# Parameters
N = 150;
sig = 0.4;
eps = 1.0;
rmin = 0.000001;
rmax = 2*sig;
w=10;
r_dom = range(rmin,rmax,length=N);

Ueval = map(s->Upatch(eps,sig,s),r_dom);
U3eval = map(s->U3(eps,eps,sig,s),r_dom);
USwapeval = map(s->SwapU(w,eps,eps,eps,sig,s,s),r_dom);
USwapfam = reduce(hcat,map(r->map(s->SwapU(w,eps,eps,eps,sig,s,r),r_dom),r_dom));

Utot = reduce(hcat,map(s->Ueval.+USwapfam[:,s],1:150));

figPot = Figure(size=(1280,720))
axPot = Axis(figPot[1,1],
               title=L"\mathrm{Potentials}",
               xlabel=L"\mathrm{Distance}~[\sigma]",
               ylabel=L"U(r)",
               limits=(0,rmax,minimum(Ueval)+minimum(Ueval)/10,w+w/10),
               titlesize = 24.0f0,
               xticklabelsize = 18.0f0,
               yticklabelsize = 18.0f0,
               xlabelsize = 20.0f0,
               ylabelsize = 20.0f0,
               xminorticksvisible = true, 
               xminorgridvisible = true
              )
lines!(axPot,r_dom,Ueval,label=L"U_{\mathrm{patch}}")
lines!(axPot,r_dom,U3eval,label=L"U_{3}")
lines!(axPot,r_dom,USwapeval,label=L"U_{\mathrm{Swap}}")
lines!(axPot,r_dom,Ueval+USwapeval,label=L"U_{\mathrm{patch}}+U_{\mathrm{Swap}}")

axislegend(axPot,position=:rt)

figPot2 = Figure(size=(1280,720))
axPot2 = Axis(figPot2[1,1],
               title=L"\mathrm{Potentials}",
               xlabel=L"\mathrm{Distance}~[\sigma]",
               ylabel=L"U(r)",
               limits=(0,rmax,minimum(Ueval)+minimum(Ueval)/10,w+w/10),
               titlesize = 24.0f0,
               xticklabelsize = 18.0f0,
               yticklabelsize = 18.0f0,
               xlabelsize = 20.0f0,
               ylabelsize = 20.0f0,
               xminorticksvisible = true, 
               xminorgridvisible = true
              )
lines!(axPot2,r_dom,Ueval,label=L"U_{\mathrm{patch}}")
series!(axPot2,r_dom,Utot,color=:thermal)







