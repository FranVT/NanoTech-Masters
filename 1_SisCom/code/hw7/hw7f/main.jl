
using Distributions
using Plots
using ProgressMeter
using FileIO
using JLD

include("parameters.jl")
include("Functions.jl")

rmT = include("multipleTemperatures.jl")

# Get the data
states = map(l->first.(rmT.multTemp[l]),eachindex(rmT.multTemp));
energ = map(l->first.(last.(rmT.multTemp[l])),eachindex(rmT.multTemp));
magn = map(l->last.(last.(rmT.multTemp[l])),eachindex(rmT.multTemp));

# Compute the mean and the variance
meanT = map(nT->mean( mean.(map(nexp->energ[nT][nexp][div(Ng*Ng*Nsteps,5):end],1:Nexp))),eachindex(energ));
varT = map(nT->var( var.(map(nexp->energ[nT][nexp][div(Ng*Ng*Nsteps,5):end],1:Nexp))),eachindex(energ));

# Plots random
"""
pm = scatter(T,meanT,label=false)
        plot!(pm,T,meanT,label=false)
vm = scatter(T,varT,label=false)
    plot!(vm,T,varT,label=false)
"""

#save(File(format"JLD",string(path,"/rangeT_",T[1],"_",T[end],"meanVar.jld")),"info",(meanT,varT))
#save(File(format"JLD",string(path,"/rangeT_",T[1],"_",T[end],"hamiltonian.jld")),"hamiltonian",(energ,magn))
function system(part,sys,Ng,mks)
    """
        Scatter plot for the system
            mks:        Marker size
    """
        splot = scatter(
                size = (460,460),
                label = false,
                framestyle = :box,
                xticks = false,
                yticks = false,
                xlims = (0,Ng+1),
                ylims = (0,Ng+1),
                aspect_ratio = 1/1,
                background_color = Nord.grey,
                legend_position = :outertop,
                legend_column = 2
        )
    
        scatter!(splot,first.(part)[reshape(sys.==1,Ng*Ng)],
            mc = Nord.white,
            markershape = :utriangle,
            markersize = mks,
            markerstrokecolor = Nord.grey,
            label = L"\sigma = 1"
        )
        scatter!(splot,first.(part)[reshape(sys.==-1,Ng*Ng)],
            mc =Nord.black,
            markershape = :dtriangle,
            markersize = mks,
            markerstrokecolor = Nord.grey,
            label = L"\sigma = -1"
        )
    end
    
    function createAnimation(path,part,info,frames,Ng,mk)
        # Create the animation
        anim = @animate for it ∈ 1:1:frames
            system(part,info[it],Ng,mk)
        end
        gif(anim,string(path,"/",frames,"gificing.gif"),fps=12)
    end
    
