"""
    Script for distributed implementation of Isgin Model
"""

using Pkg; Pkg.instantiate()
using Distributed
using Base.Threads
using ProgressMeter
using FileIO, JLD
using Random

# Call functions and parameters to all processes.
@everywhere include("isingFunc.jl")
@everywhere include("isingModel_parameters.jl")

# Set the random seed
Random.seed!(seed)

# Create the neighbors list
part = isingFunc.idNeighbors(Ng)

println("Compute Metropoli Algorithm")
# Metropoli algorithm
@time begin
    expr = @showprogress pmap(l->isingFunc.metropoliAlgorithm(part,l),1:Nexp);
end


#expr = map(s->first(info[s]),eachindex(info));
#energY = map(s->last(info[s]),eachindex(info));


println("Compute Hamiltonian")
# Compute the Hamiltonian for all the experiments
@time begin
    ham = @showprogress(map(r-> pmap(l->isingFunc.computeHamiltonianP(J,B,expr[r][l],part,Ng),eachindex(expr[r]))  ,eachindex(expr)))
end


# Data manipulation
energ = map(l->first.(ham[l]),eachindex(ham));
mag = map(l->last.(ham[l]),eachindex(ham));

# Save the data
save(File(format"JLD",string(path,"/T_",T*1000,"Ng_",Ng,"Nexp_",Nexp,"info_Ec.jld")),"info",(T,energ,mag))
