"""
    Script for basic data analysis and graphs
"""

using GLMakie
#GLMakie.activate!(; screen_config...)

#include("getData.jl")

f = Figure()
ax = Axis(f[1,1],
    xscale = log10,
    limits = (nothing,nothing,minimum(minimum.((getData.pote,getData.kine,getData.pote+getData.kine))),maximum(maximum.((getData.pote,getData.kine,getData.pote+getData.kine)))),
    xminorticksvisible = true, xminorgridvisible = true,
    xlabel = "Time steps [Log10]", ylabel = "Energy",
    title = "Energy"
    )

lines!(ax,getData.timestep,getData.pote,label="U", color = :red)
lines!(ax,getData.timestep,getData.kine,label="K", color = :orange)
lines!(ax,getData.timestep,getData.pote.+getData.kine,label="U+K", color = :black)

f[1,2] = Legend(f,ax,"Legends",framevisible=true)
