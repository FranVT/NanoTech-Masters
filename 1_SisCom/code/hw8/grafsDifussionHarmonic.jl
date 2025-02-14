"""
    Script to visualize the diffusion
"""

using Plots
using Nord

heatmap(1:101,r,sol)

plot(sol[:,1])
plot!(sol[:,end])
