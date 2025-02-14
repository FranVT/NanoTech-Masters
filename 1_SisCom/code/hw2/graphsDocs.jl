using Plots, LaTeXStrings
gr()
#default(palette = palette(:romaO50))

function LJpotential(ϵ,σ,ηr,ηa,r)
    # Compute the Lennard-Jones potential
    return (4).*(ϵ).*( (((σ)./r).^ηr) .- (((σ)./r).^ηa) )
end

function LJforce(ϵ,σ,ηr,ηa,r)
    # Compute the Lennard-Jones Force
    return ((4*ϵ)./r).*( ηr.*((σ)./r).^ηr - ηa.*((σ)./r).^ηa )
end

function LJpotentialCut(ϵ,σ,ηr,ηa,r,rcut)
    # Compute the Lennard-Jones potential
    return LJpotential(ϵ,σ,ηr,ηa,r).-((r.-rcut).*LJforce(ϵ,σ,ηr,ηa,rcut)).-LJpotential(ϵ,σ,ηr,ηa,rcut)
end


function rcutP(σ,α)
    return σ*((2^(1/6))/((1+sqrt(1+α))^(1/6)))
end
function rcutN(σ,α)
    return σ*((2^(1/6))/((1-sqrt(1+α))^(1/6)))
end

# Parameters
σ = 1;
ϵ = 1;
xl = 10;

# Arrays for plots
r = collect(0.5:1e-4:4*σ);

pLJ = plot(
    titlelocation = :center, 
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    xlabel = L"r", ylabel = L"U(r)",
    xlims = (0.5*σ,2.5*σ),
    ylims = (-2*ϵ,2*ϵ),
        size = (480,480),
        aspect_ratio = 2/4,
    formatter = :plain,
#        minorgrid = true,
#        minorgridalpha = 0.5,
    gridalpha = 0.5,
    framestyle = :box
)


plot!(pLJ,r,LJpotential(ϵ,σ,12,6,r), label = false)
plot!(pLJ,r,ϵ*[0 -0.5 -1].*(r./r),
    label=[L"U(r) = 0" L"U(r) = -0.5ϵ" L"U(r) = -ϵ"]
)
scatter!(pLJ,[rcutP(σ,-0.5) rcutN(σ,-0.5)],
        [LJpotential(ϵ,σ,12,6,rcutP(σ,-0.5)) LJpotential(ϵ,σ,12,6,rcutN(σ,-0.5))],label=false,
    markersize = 3,
    markercolor =:black
)
scatter!(pLJ,[rcutP(σ,-1) rcutN(σ,-1)],
    [LJpotential(ϵ,σ,12,6,rcutP(σ,-1)) LJpotential(ϵ,σ,12,6,rcutN(σ,-1))],label=false,
    markersize = 3,
    markercolor =:black
)
scatter!(pLJ,[rcutP(σ,0) rcutN(σ,0)],
    [LJpotential(ϵ,σ,12,6,rcutP(σ,0)) LJpotential(ϵ,σ,12,6,rcutN(σ,0))],label=false,
    markersize = 3,
    markercolor =:black
)

savefig(pLJ,"LennarJonesDifferentEnergies.pdf")

pLJc = plot(
    title = L"\mathrm{Comparisson~of~LJpotential~with~LJ~cut~potential}",
    titlelocation = :center, 
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    xlabel = L"r", ylabel = L"U(r)",
    xlims = (0.5*σ,2.5*σ),
    ylims = (-2*ϵ,2*ϵ),
        size = (480,480),
        aspect_ratio = 2/4,
    formatter = :plain,
#        minorgrid = true,
#        minorgridalpha = 0.5,
    gridalpha = 0.5,
    framestyle = :box,
    linewidth=2
)

plot!(pLJc,r,LJpotential(ϵ,σ,12,6,r), label = L"\mathrm{LJ~potential}")
plot!(pLJc,r,LJpotentialCut(ϵ,σ,12,6,r,rcutN(σ,-0.5)), label = L"\mathrm{LJ~cut~potential}")
plot!(pLJc,r,ϵ*-0.5.*(r./r),label=L"U(r) = -0.5ϵ")
plot!(pLJc,rcutN(σ,-0.5)*(r./r),range(LJpotential(ϵ,σ,12,6,rcutN(σ,-0.5)),0,length=length(r./r)),
    linewidth=1.5,
    label = false,
    line=:dot
)
scatter!(pLJc,[rcutN(σ,-0.5) rcutN(σ,-0.5)],
        [LJpotential(ϵ,σ,12,6,rcutN(σ,-0.5)) 0],label=false,
    markersize = 3,
    markercolor =:black
)

savefig(pLJc,"LennarJonesComparison.pdf")

using JLD, FileIO

# Directory to store the simulation
auxDir = joinpath(@__DIR__,"data");

sigmaP = 1;
xl = 10*sigmaP;
yl = 10*sigmaP;
function posPlot(x,y)
    """
        Plot the position for the animation
    """
    scatter(x,y,
            title = L"\mathrm{Ghost~particles}",
            titlelocation = :center,
            titlefontsize = 12,
            markersize = 2.5*sigmaP,
            tickfontsize = 8,
            xlims = (-2.5*xl/sigmaP,2.5*xl/sigmaP),
            ylims = (-2.5*yl/sigmaP,2.5*yl/sigmaP),
            xlabel = L"x/σ",
            ylabel = L"y/σ",
            label = false,
            size = (480,480),
            aspect_ratio = 1,
            formatter = :plain,
            minorgrid = true,
            minorgridalpha = 0.5,
            gridalpha = 10,
            labelfontsize = 13,
            framestyle = :box
        )
end

# Plot Initial position
R = load( string(auxDir,"\\part_r_",2,".jld"),"vR" )./sigmaP
# Create the ghost particles
smAux = 2*[[xl,0],[xl,yl],[0,yl],[-xl,yl],[-xl,0],[-xl,-yl],[0,-yl],[xl,-yl]]
Rg = stack(map(s->R.+smAux[s],collect(1:1:length(smAux))))
auxR = [R reshape(Rg,2,length(R[1,:])*length(smAux))]

inPos = posPlot(auxR[1,:],auxR[2,:])
savefig(inPos,"ghostParticles.pdf")



