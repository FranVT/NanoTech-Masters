
aux = collect(1:1:10)

# Create tuples
miau = collect( Iterators.product(aux,aux) )

# Create a function
function f(x,y)
    return x*y
end

function dif(Ap,p1,p2)
    d = Ap[:,p1] - Ap[:,p2]
    n = sqrt(sum(d.^2))
    return (d,n)
end

function LF(d,n)
    return d/n
end

# Evaluate the function with tuples
f(miau[1]...)

# Just fun
map( s->f(miau[s]...),collect(1:10) )




# Map a function and is a vector
Iterators.flatmap(n -> -n:2:n, 1:3) |> collect

# Create the upper triangle matrix
"""
    The particle with id 1 with bla bla bla
"""
N = 10; # Number of particles
# The ids of the particles
ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:N)) |> collect
# Evaluate the function
feval = Iterators.flatmap(s-> f(ids[s]...),collect(1:1:length(ids))) |> collect
# auxiliar to store the force for each particle
info = zeros(N,N)
# Create the upper triangular matrix
map(s->info[ids[s]...] = feval[s],collect(1:1:length(ids)))
# Get the lower triangular amtrix with the transpose
info = info - info'
# Get the force per particle
ljf = sum(info,dims=2)


# Array with position
pos = zeros(2,N)
pos[1,:] = rand(1,N)
pos[2,:] = rand(1,N)

jeje = dif(pos,1,2)

dif(pos,ids[1]...)/sqrt(sum(dif(pos,ids[1]...).^2))

LF(jeje...)



function LJforce(ϵ,σ,ηr,ηa,r,vu)
    # Compute the Lennard-Jones Force
    return 4*ϵ/r*( ηr*(σ/r)^ηr - ηa*(σ/r)^ηa )*vu  
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



#dif(pos,ids[1]...)
# Parameters: ϵ,σ,ηr,ηa
parms = (4,1,12,6)

LJforce(4,1,12,6,dif(pos,ids[1]...)...)

# Compute the force for each particle
N = 10; # Number of particles
# The ids of the particles
ids = Iterators.flatmap(s->Iterators.product(s,collect(1+s:1:N)),collect(1:1:N)) |> collect
# Evaluate the function
feval = Iterators.flatmap(s-> LJforce(parms...,dif(pos,ids[s]...)...),collect(1:1:length(ids))) |> collect
# auxiliar to store the force for each particle
info = zeros(N,N)
# Create the upper triangular matrix
map(s->info[ids[s]...] = feval[s],collect(1:1:length(ids)))
# Get the lower triangular amtrix with the transpose
info = info - info'
# Get the force per particle
ljf = sum(info,dims=2)

LJFparticles(parms,pos)

