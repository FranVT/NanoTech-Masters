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

function Fpatch(eps_pair,sig_p,r)
    if r < 1.5*sig_p
        return 4*eps_pair*(sig_p^4/r^5)*exp.((sig_p)./(r.-(1.5*sig_p)).+2) + 2*eps*(sig_p/(r-1.5*sig_p)^2)*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2)
    else
        return 0.0
    end
end

# Parameters
N = 5000000;
sig = 0.4;
eps = 1.0;
rmin = 0.000001;
rmax = 5*sig;
r_dom = range(rmin,rmax,length=N);

Ueval = map(s->Upatch(eps,sig,s),r_dom);

figPatch = Figure(size=(1280,720))
axPatch = Axis(figPatch[1,1],
               title=L"\mathrm{Patch~Potential}",
               xlabel=L"\mathrm{Distance}~[\sigma]",
               ylabel=L"U_{\mathrm{Patch}}(r)",
               limits=(0,rmax,minimum(Ueval),-minimum(Ueval))
              )
lines!(axPatch,r_dom,Ueval)


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

function Forceij(eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    -d/drij SwapU
"""
    if r_ij < sig_p || r_ik < sig_p
        return 0.0
    elseif r_ij >= 1.5*sig_p || r_ik >= 1.5*sig_p
        return 0.0 
    else 
        t1 = (eps_ij*eps_ik/eps_jk)*( (sig_p^4/r_ij^5)*((sig_p^4/(2*r_ik^4))-1) )*( 8*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        t2 = (eps_ij*eps_ik/eps_jk)*( (sig_p/(r_ij-1.5*sig_p)^2)*((sig_p^4/(2*r_ij^4))-1)*((sig_p^4/(2*r_ik^4))-1) )*( 4*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        return t1+t2
    end
end

function Forceik(eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    -d/drij SwapU
"""
    if r_ij < sig_p || r_ik < sig_p
        return 0.0
    elseif r_ij >= 1.5*sig_p || r_ik >= 1.5*sig_p 
        return 0.0
    else
        t1 = (eps_ij*eps_ik/eps_jk)*( (sig_p^4/r_ik^5)*((sig_p^4/(2*r_ij^4))-1) )*( 8*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        t2 = (eps_ij*eps_ik/eps_jk)*( (sig_p/(r_ik-1.5*sig_p)^2)*((sig_p^4/(2*r_ij^4))-1)*((sig_p^4/(2*r_ik^4))-1) )*( 4*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        return t1+t2
    end
end

## Parameters for the file

N = 50;
M = 2*N*N*N;

eps_ij = 1.0;
eps_ik = 1.0;
eps_jk = 1.0;
sig = 0.4;
rmin = sig-sig/2;
rmax = 1.499*sig;
thi = 180/(4*N)
thf = 180 - thi;
w=1.0;

# Create the domains of evaluation according filename nessetities
th_dom = range(thi,thf,2*N);
r_dom = range(rmin,rmax,N);

Ueval = map(s->Upatch(eps,sig,s),r_dom);
U3eval = map(s->U3(eps_ij,eps_jk,sig,s),r_dom);
USwapeval = map(s->SwapU(w,eps_ij,eps_ik,eps_jk,sig,s,s),r_dom);
USwapeval2 = map(s->SwapU(0.5*w,eps_ij,eps_ik,eps_jk,sig,s,s),r_dom);
USwapeval4 = map(s->SwapU(0.25*w,eps_ij,eps_ik,eps_jk,sig,s,s),r_dom);
U2Swapeval = map(s->SwapU(2*w,eps_ij,eps_ik,eps_jk,sig,s,s),r_dom);


figSwap = Figure(size=(1280,720))
axSwap = Axis(figSwap[1,1],
               title=L"\mathrm{Patch~Potential}",
               xlabel=L"\mathrm{Distance}~[\sigma]",
               ylabel=L"U(r)",
               limits=(0,rmax,minimum(Ueval),-minimum(Ueval))
              )
lines!(axSwap,r_dom,Ueval,label=L"U_{\mathrm{patch}}")
#lines!(axSwap,r_dom,U3eval,label=L"U_{\mathrm{3}}")
lines!(axSwap,r_dom,U2Swapeval,label=L"2U_{\mathrm{swap}}")
lines!(axSwap,r_dom,USwapeval,label=L"U_{\mathrm{swap}}")
lines!(axSwap,r_dom,USwapeval2,label=L"U_{\mathrm{swap}}/2")
lines!(axSwap,r_dom,USwapeval4,label=L"U_{\mathrm{swap}}/4")
lines!(axSwap,r_dom,Ueval.+U2Swapeval,label=L"U_{\mathrm{patch}}+2U_{\mathrm{swap}}")
lines!(axSwap,r_dom,Ueval.+USwapeval,label=L"U_{\mathrm{patch}}+U_{\mathrm{swap}}")
lines!(axSwap,r_dom,Ueval.+USwapeval2,label=L"U_{\mathrm{patch}}+U_{\mathrm{swap}}/2")
lines!(axSwap,r_dom,Ueval.+USwapeval4,label=L"U_{\mathrm{patch}}+U_{\mathrm{swap}}/4")


axislegend(axSwap,position=:rb)


