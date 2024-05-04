"""
    Ising Model 

"""

# Packages
using Base.Threads
using Random, Distributions
using FileIO, JLD
using LinearAlgebra

 # Configure the random generator
 Random.seed!(4321)

 # Include functions and parameters
 include("isingModel_parameters_parallel.jl")
 include("isingModel_functions_parallel.jl")

# Start the system with random spins
sys = wsample(σs,[1-η,η],(Ng,Ng));

# ids with its neighbors
part = idNeighbors(Ng);


# Create the domain
domExp = 1:Nexp

# Create the partitions
chunks = Iterators.partition(domExp,1);

@time begin
# Task
task = map(chunks) do s
    Threads.@spawn map(l->metropoliAlgorithm(sys,l,Nth),s)
end

# Fetch
# (states,energ,mag)
infoSim = Iterators.flatten(fetch.(task))|>collect
end

# Manipulate the data
sysE = first.(infoSim);

@time begin
haml = map(s->hamExpr(J,B,sysE[s],part,Ng),eachindex(sysE))
end



#@time begin
#(energ,mag) = computeHamiltonianP(J,B,first(infoSim[1])[end],part,Ng)
#end


"""
@time begin
len_Exp = first.(last.(infoSim));
allHam = map(r-> map( s-> computeHamiltonianP(J,B,first(infoSim[r])[s],part,Ng), 1:len_Exp[r]), 1:Nexp)
end
"""

# Save the data
#save(File(format"JLD",string(path,"/par_T_",T,"_",nExp,"states.jld")),"states",states)
#save(File(format"JLD",string(path,"/parseeds_T_",T,"_",nExp,step,".jld")),"seeds",setSeeds)


hamiltonian = last.(infoSim);

# Limits fot the average of the quantities.
indc = map(s-> (length(first(hamiltonian[s]))÷100)*10 ,1:length(hamiltonian))

