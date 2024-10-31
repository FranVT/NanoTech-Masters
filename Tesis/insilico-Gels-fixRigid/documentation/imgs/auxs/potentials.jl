"""
    Script for correction in the potentials
"""

using GLMakie

# Create the functions
function WCA(eps_pair,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
if r < sig_p*(2^(1/6))
        return 4*eps_pair*( (sig_p/r).^12 .- (sig_p/r).^6) .+ eps_pair 
    else
        return 0.0
    end
end



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
sigCP=0.5;
sig = 0.4;
eps = 1.0;
w=1;
rmin = 0.000001;
rmax = (2^(1/6));
r_dom = range(rmin,rmax,length=N);

WCAeval =map(s->WCA(eps,sigCP,s),r_dom); 
Ueval = map(s->Upatch(eps,sig,s),r_dom);
U3eval = map(s->U3(eps,eps,sig,s),r_dom);
USwapeval = map(s->SwapU(w,eps,eps,eps,sig,s,s),r_dom);
USwapfam = reduce(hcat,map(r->map(s->SwapU(w,eps,eps,eps,sig,s,r),r_dom),r_dom));

Utot = reduce(hcat,map(s->Ueval.+USwapfam[:,s],1:150));

figPot = Figure(size=(1920,1080))
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

vlines!(axPot,1.5*sig,linestyle=:dash)
axislegend(axPot,position=:rt)

## Add stuff

figPot2 = Figure(size=(1920,1080))
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
lines!(axPot2,r_dom,WCAeval,label=L"WCA_{\mathrm{patch}}")
lines!(axPot2,r_dom,Ueval,label=L"U_{\mathrm{patch}}")
lines!(axPot2,r_dom,USwapeval,label=L"U_{\mathrm{Swap}}")
lines!(axPot2,r_dom,Ueval+USwapeval,label=L"U_{\mathrm{patch}}+U_{\mathrm{Swap}}")

vlines!(axPot2,1.5*sig,linestyle=:dash)
axislegend(axPot2,position=:rt)

## Add stuff

rmax = sigCP+(2^(1/6));
r_dom = range(rmin,rmax,length=N);


WCAeval =map(s->WCA(eps,sigCP,s),r_dom); 
Ueval = map(s->Upatch(eps,sigCP+sig,s),r_dom);
U3eval = map(s->U3(eps,eps,sigCP+sig,s),r_dom);
USwapeval = map(s->SwapU(w,eps,eps,eps,sigCP+sig,s,s),r_dom);
USwapfam = reduce(hcat,map(r->map(s->SwapU(w,eps,eps,eps,sigCP+sig,s,r),r_dom),r_dom));

figPot3 = Figure(size=(1920,1080))
axPot3 = Axis(figPot3[1,1],
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
lines!(axPot3,r_dom,WCAeval,label=L"WCA_{\mathrm{patch}}")
lines!(axPot3,r_dom,Ueval,label=L"U_{\mathrm{patch}}")
lines!(axPot3,r_dom,USwapeval,label=L"U_{\mathrm{Swap}}")
lines!(axPot3,r_dom,Ueval+USwapeval,label=L"U_{\mathrm{patch}}+U_{\mathrm{Swap}}")

vlines!(axPot3,rmax-sigCP,linestyle=:dash,color=:orange)
vlines!(axPot3,1.5*sig,linestyle=:dash,color=:grey)
vlines!(axPot3,sigCP+1.5*sig,linestyle=:dash,color=:black)
vlines!(axPot3,1.5*(sigCP+sig),linestyle=:dash)
axislegend(axPot3,position=:rt)


