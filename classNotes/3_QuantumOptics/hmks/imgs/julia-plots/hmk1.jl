"""
    Script to plot the homework
"""

using LinearAlgebra
using GLMakie
using Distributions

# Photon numer distribution of coherent state

n = (1,10,100);

fig_coherent=Figure(size=(1920,1080));
ax=Axis(fig_coherent[1,1:2],
               title=L"\mathrm{Photon~number~distribution~of~coherent~state}",
               xlabel=L"\mathrm{Photon~number}",
               ylabel=L"\mathrm{p(n)}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               limits=(0,150,0,1)
              )
map(s->lines!(ax,Poisson(s)),n)
map(s->scatter!(ax,Poisson(s)),n)

