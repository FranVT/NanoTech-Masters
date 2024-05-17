"""
    Script to visualize the diffusion
"""

using CairoMakie

fig = Figure(size=(600,400))
ax = Axis(fig[1,1],xlabel=L"x")
lines!(r,sol[:,1])


plot!(sol[:,end])


# https://beautiful.makie.org/examples/2d/lines/line_cmap