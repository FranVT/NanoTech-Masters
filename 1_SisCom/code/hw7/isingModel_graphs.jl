"""
    Script for graphs
"""

using Plots, LaTeXStrings
using FileIO, JLD
using Nord

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
        system(part,info[:,:,it],Ng,mk)
    end
    gif(anim,string(path,"/",frames,"gificing.gif"),fps=24)
end

function getInfo(frames,saveStates,Ng)
    info = zeros(Int64,Ng,Ng,frames);
    aux = append!([0],cumsum(first.(size.(saveStates))));
    
    for s∈1:Nsteps
        for t∈1:length(saveStates[s])
            info[:,:,t+aux[s]] = load(string(path,"/state",s,"_",saveStates[s][t],".jld"),"σ")
        end
    end
    return info
end


# Include the parameters of the simulation
include("isingModel_parameters.jl")

# Retreive the information
#info = getInfo(path,Ng,Nsteps);

# Compute the energy 
@time begin
energ = map(s->computeEnergy(J,B,info[:,:,s],part,Ng),1:frames);
end
