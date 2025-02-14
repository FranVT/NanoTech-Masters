"""
    Functions
"""

function LJpotential(ϵ,σ,ηr,ηa,r)
    # Compute the Lennard-Jones potential
    return 4*ϵ*( ((σ)./r).^ηr - ((σ)./r).^ηa )  
end

function LJforce(ϵ,σ,ηr,ηa,r,vu)
    # Compute the Lennard-Jones Force
    return ((4*ϵ)./r).*( ηr.*((σ)./r).^ηr - ηa.*((σ)./r).^ηa ).*vu  
end

function dif(Ap,p1,p2)
    # Get the distance and unit vector.
    d = Ap[:,p1] - Ap[:,p2]
    n = sqrt(sum(d.^2))
    uv = d/n
    return (n,uv)
end

function rCut(σ,kb,ϵ,T)
    return ( (2*(σ)^6)./((1).+sqrt.((1).+((kb/ϵ).*T))) ).^(1/6)
end

function rCut2(σ,kb,ϵ,T)
    return 2^(1/6)*(1/(1+(sqrt(1+(kb*T)/(ϵ))))^(1/6))*σ
end

function InitialConditions(wx1,wx2,σ,Np,vR)
    dR = collect(wx1+σ:1.5*σ:wx2-σ);
    ndr = length(dR);
    space = reduce(vcat, collect( Iterators.product(dR,dR) ));
    idP = sample(collect(1:ndr*ndr),Np,replace=false);
    ubs = space[idP];
    map(s->vR[:,s].=ubs[s],collect(1:1:Np));
    return vR
end

function getIn(xl,yl,vR)
    # Find particles that get put in the x axis
    ppAux = findall(x->x.>xl,vR[1,:])
    pnAux = findall(x->x.<-xl,vR[1,:])

    # Teletransport from x to -x
    vR[1,findall(x->x.>xl,vR[1,:])] = -xl.+(vR[1,ppAux] .- xl)
    # Teletransport from -x to x
    vR[1,findall(x->x.<-xl,vR[1,:])] = xl.+(vR[1,pnAux] .+ xl)

    # Find particles that get put in the y axis
    ppAux = findall(x->x.>yl,vR[2,:])
    pnAux = findall(x->x.<-yl,vR[2,:])

    # Teletransport from y to -y
    vR[2,findall(x->x.>yl,vR[2,:])] = -yl.+(vR[2,ppAux] .- yl)
    # Teletransport from -y to y
    vR[2,findall(x->x.<-yl,vR[2,:])] = yl.+(vR[2,pnAux] .+ yl)

    return vR
end

function LJparticles(par,xl,yl,nP,R)

    # Create the ghost particles
    smAux = 2*[[xl,0],[xl,yl],[0,yl],[-xl,yl],[-xl,0],[-xl,-yl],[0,-yl],[xl,-yl]]
    Rg = stack(map(s->R.+smAux[s],collect(1:1:length(smAux))))
    auxR = [R reshape(Rg,2,nP*length(smAux))]
    N = length(auxR[1,:])
    
    # The ids of the particles
    ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:nP)) |> collect
    idm = Iterators.flatten(map( r-> map(s->(r,s),collect(1:r-1)  ), collect(2:nP) ))|>collect
    ida = Iterators.flatmap(s->findall(x->x == reverse(idm[s]),ids),collect(1:1:length(idm)))|>collect;
    # Evaluate the force for each particle
    f = stack(map(s-> LJforce(par...,dif(auxR,ids[s]...)...),collect(1:1:length(ids))))
    # Allocation of memory
    resx = zeros(nP,N);
    resy = zeros(nP,N);
    # x component
    map( s-> resx[ids[s]...] = f[1,s],collect(1:1:length(ids)) )
    map( s-> resx[idm[s]...] = -f[1,ida[s]],collect(1:1:length(idm)) )
    # y component
    map( s-> resy[ids[s]...] = f[2,s],collect(1:1:length(ids)) )
    map( s-> resy[idm[s]...] = -f[2,ida[s]],collect(1:1:length(idm)) )
    # Total force
    resx = reshape(sum(resx,dims=2),1,nP)
    resy = reshape(sum(resy,dims=2),1,nP)

    return [resx; resy]
        
end

"""
    Packages
"""

using Random, Distributions
using JLD, FileIO

Random.seed!(1234);

"""
    Parameters
"""
# Lennard-Jones parameters
epsP = 5;
sigmaP = 1;
reip = 12;
aeip = 6;
parmsLJ = (epsP,sigmaP,reip,aeip);

# r cut parameters
kB = 1;
T = 5;
parmsRcut = (sigmaP,kB,epsP,T);

#rCut(parmsRcut...)
#rCut2(parmsRcut...)
#/(2*xl)
#n = floor(Int,rCut(parmsRcut...)/2*xl)

# System parameters
m = 1;
ti = 0;
tf = 10;
dt = 1e-3;
Np = 100;
Nt = Int(div(tf-ti,dt,RoundUp)) + 1;
xl = 10*sigmaP;
yl = 10*sigmaP;
parmsLim = (-xl,xl,-yl,yl);

# Directory to store the simulation
auxDir = joinpath(@__DIR__,"data");

"""
    Memory allocation
"""
vR = zeros(2,Np);
vV = zeros(2,Np);
aux = zeros(2,Np);
vKm = zeros(Nt);

# Initial conditions
vR = InitialConditions(-xl,xl,sigmaP,Np,vR)

# Save Initial Conditions
save(File(format"JLD",string(auxDir,"\\part_r_1.jld")),"vR",vR)

# Initial Velocities
vV[1,:] = rand( Normal(0,sqrt(kB*T/m)),Np );
vV[2,:] = rand( Normal(0,sqrt(kB*T/m)),Np );

@time begin
    
    for it = 1:Nt
        # Compute the force and turn it into acceleration
        ac = (1/m).*LJparticles(parmsLJ,xl,yl,Np,vR);
        # Compute v*
        aux = reduce(hcat,map(s->vV[:,s] + (dt/2)*(ac[:,s]) ,collect(1:1:Np)));
        # Get position
        vR = reduce(hcat,map(s->vR[:,s] + dt*aux[:,s] ,collect(1:1:Np)));
        # Teletransport particles
        vR = getIn(xl,yl,vR)
        # Compute the force and turn it into acceleration
        ac = (1/m).*LJparticles(parmsLJ,xl,yl,Np,vR);
        # Compute velocity
        vV = reduce(hcat,map(s->aux[:,s] + (dt/2)*(ac[:,s]) ,collect(1:1:Np)));
        # Compute mean of velocity square
        vKm[it] = mean(sum(vV.^2,dims=1));
        # Save the array of position
        if it%2 == 0; save(File(format"JLD",string(auxDir,"\\part_r_",it,".jld")),"vR",vR); end
    end

end
# Save the energy array
save(File(format"JLD",string(auxDir,"\\kinetimEnergy.jld")),"vKm",vKm)

"""
    Graphics
"""

using Plots, LaTeXStrings
gr()


function temPlot(x,y)
    """
        Plot the temperature
    """
    plot(x,y,
        xlabel = L"t",
        ylabel = L"T(t)",
        label = false,
        size = (480,480),
        #aspect_ratio = 3/4,
        title = L"\mathrm{Temperature}"
    )
end


function posPlot(x,y,T,it)
    """
        Plot the position for the animation
    """
    scatter(x,y,
            title = string(
                    L"\mathrm{Nt} = ",latexstring("$(it)"),
                    L",~~~\mathrm{T:}~",latexstring("$(round(T,digits=6))")
                    ),
            titlelocation = :left,
            titlefontsize = 12,
            markersize = 10*sigmaP,
            tickfontsize = 8,
            xlims = (-xl/sigmaP,xl/sigmaP),
            ylims = (-yl/sigmaP,yl/sigmaP),
            xlabel = L"x/σ",
            ylabel = L"y/σ",
            label = false,
            size = (480,480),
            aspect_ratio = 1,
            formatter = :plain,
            minorgrid = true,
            minorgridalpha = 0.5,
            gridalpha = 1,
            labelfontsize = 13,
            framestyle = :box
        )
end


kinem = load( string(auxDir,"\\kinetimEnergy.jld"),"vKm" );

# Compute the temperaute
vT = (1/3)*(cumsum(kinem)./collect(1:length(kinem)));

# Plot the temperature
tempPlot = temPlot(collect(0:dt:tf),vT)

# Save the Temperatur plot
savefig(tempPlot,"100TempPlotPBC3.pdf")


# Plot Initial position
info = load( string(auxDir,"\\part_r_",2,".jld"),"vR" )./sigmaP
inPos = posPlot(info[1,:],info[2,:],vT[1],1)

# Create the animation
@time begin
    anim = @animate for it ∈ 2:4:Nt
        info = load( string(auxDir,"\\part_r_",it,".jld"),"vR" )./sigmaP
        posPlot(info[1,:],info[2,:],vT[it],it)
    end
    gif(anim,"gif100_2Hw_pbc3.gif",fps=24)
end

