
using Plots
auxDir = joinpath(@__DIR__,"data");


info = load( string(auxDir,"\\part_r_",4,".jld"),"vR" )
scatter( info[1,:]./sigmaP,info[2,:]./sigmaP,markersize=1,xlims=(-12,12),ylims=(-12,12) )
info = load( string(auxDir,"\\part_r_",1000,".jld"),"vR" )
scatter!( info[1,:]./sigmaP,info[2,:]./sigmaP,markersize=2.5 )



scatter( info[1,:]./sigmaP,info[2,:]./sigmaP,markersize=2.5 )


scatter!( info[1,:]./sigmaP,info[2,:]./sigmaP,markersize=2.5 )
