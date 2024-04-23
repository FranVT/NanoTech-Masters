"""
    Script for graphs
"""

using Plots, LaTeXStrings
using FileIO, JLD
using Nord

"""
        Usefully functions
"""
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

"""
    Data Analysis and graphs
"""

# Include the parameters of the simulation
include("isingModel_parameters.jl")

nExp = 1;

# Retreive the information
(info, Nstates) = getInfo(T,nExp);

# Compute the energy for all the states 
@time begin
    energ = map(s->computeEnergy(J,B,info[s],part,Ng),1:Nstates);
end

# Compute the magnetization for all the states
@time begin
    mag = map(s->sum(Int64,info[:,:,s],sr),1:1:Nstates);
end

"""
    Graphs
"""
system(part,info[:,:,end],Ng,3)

pEnerg = plot(energ,title="Energy")
pMag = plot(mag,title="Magnetization")