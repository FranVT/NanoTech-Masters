# Packages
using Random, Distributions
using FileIO, JLD
using LinearAlgebra

 # Configure the random generator
 Random.seed!(4321)

 # Include functions and parameters
 include("isingModel_parameters.jl")
 include("isingModel_functions.jl")

# Start the system with random spins
sys = wsample(σs,[1-η,η],(Ng,Ng));

# ids with its neighbors
part = idNeighbors(Ng);

println("Compute Energy")
@time begin
# Compute the energy 
energ = computeEnergy(J,B,sys,part,Ng);
end

# Make an energy comparsion between systems
idc = rand(1:Ng*Ng,10);
println("Small changes")
@time begin
nsys = map(s->smallSysChange(sys,part,σs,Ng,s),idc);
end

println("Compute N Energy")
@time begin
nenerg = map(s->computeEnergy(J,B,nsys[s],part,Ng),1:length(nsys))
end

println("Energy differences")
denerg = nenerg .- energ

println("Compute difference of Energy")
@time begin
dfenerg = map(s->computeDeltaE(J,B,nsys[s],sys,part,Ng,idc[s]),1:length(nsys))
end
 Make an energy comparsion between systems
idc = rand(1:Ng*Ng,10);
println("Small changes")
@time begin
nsys = map(s->smallSysChange(sys,part,σs,Ng,s),idc);
end

println("Compute N Energy")
@time begin
nenerg = map(s->computeEnergy(J,B,nsys[s],part,Ng),1:length(nsys))
end

println("Energy differences")
denerg = nenerg .- energ

println("Compute difference of Energy")
@time begin
dfenerg = map(s->computeDeltaE(J,B,nsys[s],sys,part,Ng,idc[s]),1:length(nsys))
end



