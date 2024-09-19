"""
    Scripts to create figures of the potentials
"""

using GLMakie

## Parameters of the potentials
sigma_parti = 0.5; 
sigma_patch = 0.4;
eps = 1;
rc = 1.5*sigma_patch;

## Parameters for the graphs
N = 1000;
df = 3*sigma_parti;

## Spatial range
dist = range(1e-12,df,length=N);

## Potentials

function potCLMO(eps,sigma,r)
    r = collect(r);
    r[r.>2^(1/6)*sigma].=2^(1/6)*sigma;
    return 4*eps.*( (sigma./r).^(12) .- (sigma./r).^(6) ).+eps
end

function potPatchPatch(eps,sigma,r,rc)
    r = collect(r);
    r[r.>=rc].=rc;
    return 2*eps*(((sigma./(2*r)).^4).-1).*exp.(sigma./(r.-rc).+2)
end

function potSwap(eps,sigma,r,rc)
    r = collect(r);
    t1 = potPatchPatch(eps,sigma,r,rc);
    t1 = -(t1.*isfinite.(t1))./eps;
    return (t1.*t1)./eps
end


## Evaluation
potParts = potCLMO(eps,sigma_parti,dist);
potPatch = potPatchPatch(eps,sigma_patch,dist,rc);
potPatch = potPatch.*isfinite.(potPatch);
potSwapp = potSwap(eps,sigma_patch,dist,rc);
potTotPc = potPatch .+ potSwapp;

## Figure

fig = Figure(size=(1280,980))

ax = Axis(fig[1,1:2],
        aspect = nothing,
        limits = (0,df,minimum(potPatch),minimum(potPatch)^2),
        title = L"\mathrm{Potentials~of~simulations}",
        xlabel = L"\mathrm{Distance~}\sigma",
        ylabel = L"\sigma_{U(r)}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
    )

lines!(ax,dist,potParts)
lines!(ax,dist,potPatch)
lines!(ax,dist,potSwapp)
lines!(ax,dist,potTotPc)

