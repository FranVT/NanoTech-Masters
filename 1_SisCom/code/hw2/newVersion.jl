
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

function LJFparticles(par,vR)
    N = length(vR[1,:]);
    # The ids of the particles
    ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:N)) |> collect
    # Evaluate the function
    feval = Iterators.flatmap(s-> LJforce(par...,dif(vR,ids[s]...)...),collect(1:1:length(ids))) |> collect
    # auxiliar to store the force for each particle
    info = zeros(N,N)
    # Create the upper triangular matrix
    map(s->info[ids[s]...] = feval[s],collect(1:1:length(ids)))
    # Get the lower triangular amtrix with the transpose
    info = info - info'
    # Get the force per particle
    ljf = sum(info,dims=2)
    return ljf
end

function rCut(σ,kb,ϵ,T)
    return ( (2*(σ)^6)./((1).+sqrt.((1).+((kb/ϵ).*T))) ).^(1/6)
end

# Parameters: ϵ,σ,ηr,ηa
parms = (4,1,12,6)
N = 10;

# Array with position
pos = zeros(2,N)
pos[1,:] = rand(1,N)
pos[2,:] = rand(1,N)

# Compute the for for each particle
LJFparticles(parms,pos)

# Create ghost particles
# Width of the box x
Lx = 2;
# Height of the box y
Ly = 2;
# Number boxes
n = 2;

# Auxiliary
gPart = zeros(2,N,4)
gPart[:,:,1] = pos .+ n*[Lx,0]
gPart[:,:,2] = pos .+ n*[0,Ly]
gPart[:,:,3] = pos .+ n*[0,-Ly]
gPart[:,:,4] = pos .+ n*[-Lx,0]


gPart = pos .+ n*[Lx,Ly]

# Velocity
m = 1; kB = 1; T = 1;
dt = 1e-3;
vn = sqrt( m/(2*pi*kB*T) )
vn*dt


LJpotential.(parms...,collect(0.5:1e-4:2))

vr = collect(0.5:1e-2:2)
plot(vr[end],LJpotential(parms...,2))

collect(0:1e-3:4*10)


# Parameters: ϵ,σ,ηr,ηa
parms = (4,1,12,6)
T = 4;
vr = collect(0.5:1e-2:5)
plot(vr,[LJpotential(parms...,vr),LJforce(parms...,vr,1)] ,
    xlims = (0.8,3),
    ylims = (-10,10),
    gridalpha = 1,
    formatter = :plain,
    minorgrid = true,
    minorgridalpha = 0.5,
    framestyle = :box,
    label = false
)
plot!([0,4],[3,4])


idAux = Iterators.flatmap( s-> [s*Np+1:(s*Np)+Np],collect(1:1:4) ) |> collect