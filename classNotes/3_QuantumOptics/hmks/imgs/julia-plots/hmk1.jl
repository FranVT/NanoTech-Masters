"""
    Script to plot the homework
"""

using LinearAlgebra
using GLMakie
using Distributions

# Photon numer distribution of coherent state

n = (1,10,100);

fig_coherent=Figure()
ax=Axis(fig[1,1])
map(s->lines!(ax,Poisson(s)),n)

