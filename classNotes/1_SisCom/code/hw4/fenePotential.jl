#=
    To create graph for FENE potential
=#

function FENEpotential(K,Ro,ϵ,σ,r)
    return (-0.5*K*Ro^2)*log.((1).-(r./Ro).^2) .+ 4*ϵ.*(((σ)./r).^12 .- ((σ)./r).^6) .+ ϵ
end
function FENEforce(K,Ro,ϵ,σ,r)
    return -( ((K).*r)./((1) .- (r.^2/Ro^2)) .+ (4*ϵ./r).*((12).*((σ)./r).^12 .- (6).*((σ)./r).^6) )
end

function LJforce(ϵ,σ,r)
    return - ( (4*ϵ./r).*((12).*((σ)./r).^12 .- (6).*((σ)./r).^6) )
end

function angleStyle(K,θo,θ)
    return (K).*(θ .- θo).^2
end

function dihedralStyle(K,d,n,Φ)
    return (K).*((1) .+ d.*cos.((n).*Φ))
end

using Plots, LaTeXStrings
gr()

ϵp = 5;
σp = 1;
Ro = σp;
θp = pi;

# Radial and angular domain
r1 = collect(0.5*σp:σp/100:3*σp);
r2 = collect(0.5*σp:σp/100:5*σp);
r3 = collect(0.5*σp:σp/100:7*σp);
θ = collect(0:pi/100:2pi);

# Parameters for the FENE potential
p1 = (ϵp/((3*σp)^2),3*σp,ϵp,σp);
p2 = (ϵp/((5*σp)^2),5*σp,ϵp,σp);
p3 = (ϵp/((7*σp)^2),7*σp,ϵp,σp);

pFENE  = plot(
    title = L"\mathrm{FENE}~\mathrm{potential}",
    xlabel = L"r~[\mathrm{distance}]",
    ylabel = L"U(r)~[\mathrm{energy}]",
    xlims = (0.5*σp,7*σp),
    ylims = (0,2*ϵp),
    size = (480,480), #aspect_ratio = 1,
    formatter = :plain,
    gridalpha = 1,
    minorgrid = true,
    minorgridalpha = 0.2,
    framestyle = :box
)

plot!(pFENE,r1,FENEpotential(p1...,r1),label=L"U_{\mathrm{FENE}}(\frac{ϵ}{3σ^2},3σ,ϵ,σ,r)")
plot!(pFENE,r2,FENEpotential(p2...,r2),label=L"U_{\mathrm{FENE}}(\frac{ϵ}{5σ^2},5σ,ϵ,σ,r)")
plot!(pFENE,r3,FENEpotential(p3...,r3),label=L"U_{\mathrm{FENE}}(\frac{ϵ}{10σ^2},10σ,ϵ,σ,r)")
plot!(pFENE,r3,ϵp.*(r3./r3),label=L"U(r) = ϵ",linewidth=1.5,line=:dash,linecolor=:black)


savefig(pFENE,"FENEComparison.pdf")

# Force due to LJ and FENE potentials.

fPot  = plot(
    title = L"\mathrm{Force}~\mathrm{comparisson}",
    xlabel = L"r~[\mathrm{distance}]",
    ylabel = L"F(r)~[\mathrm{force}]",
    xlims = (0.5*σp,3*σp),
    ylims = (-2*ϵp,2.5*ϵp),
    size = (480,480), #aspect_ratio = 1,
    formatter = :plain,
    gridalpha = 1,
    minorgrid = true,
    minorgridalpha = 0.2,
    framestyle = :box,
    legend_position = :bottomleft
)
plot!(fPot,r,FENEforce(p1...,r),label = L"F = -\nabla U_{\mathrm{FENE}}")
plot!(fPot,r,LJforce(ϵp,σp,r),label = L"F = -\nabla U_{\mathrm{LJ}}")

savefig(fPot,"forceComparison.pdf")

# Angular potentials

pANG  = plot(
    title = L"\mathrm{Angular}~\mathrm{potential}",
    xlabel = L"θ~[\mathrm{radians}]",
    ylabel = L"U(\theta)~[\mathrm{energy}]",
    xlims = (0,2*pi),
    ylims = (0,2*ϵp),
    size = (480,480), #aspect_ratio = 1,
    formatter = :plain,
    gridalpha = 1,
    minorgrid = true,
    minorgridalpha = 0.2,
    framestyle = :box
)

plot!(pANG,θ,angleStyle(ϵp/(θp^2),θp,θ),label=L"\mathrm{Angle~Style}")
plot!(pANG,θ,dihedralStyle(ϵp,1,1,θ),label=L"\mathrm{Dihedral~Style},~d=1")
plot!(pANG,θ,dihedralStyle(ϵp,-1,1,θ),label=L"\mathrm{Dihedral~Style},~d=-1")

savefig(pANG,"angularPotential.pdf")
