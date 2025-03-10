"""
    Script to plot the homework
"""

using LinearAlgebra
using GLMakie, LaTeXStrings
using Distributions

include("functions.jl")

# Photon numer distribution of coherent state
n_mean =(1,10,100);

# Domain of the number of photons
n=0:1:2*last(n_mean);

# Evluation of the functions
p_n = collect(map(s-> pdf(Poisson(s),n) ,n_mean));

# Mean coordinates
mean_p = map(s->(mean(Poisson(s)),pdf(Poisson(s),s)),n_mean);

# Define a theme with a custom colormap
my_theme = Theme(
    font = "Computer Modern",
    colormap = :viridis,  # or any valid colormap name/object
    palette = (color = Makie.wong_colors(),)  # optional categorical colors
)

# Apply the theme to the entire figure
set_theme!(my_theme)


fig_coherent=Figure(size=(1080,1080));
ax=Axis(fig_coherent[1,1:2],
               title=L"\mathrm{Photon~number~distribution~of~coherent~state}",
               xlabel=L"\mathrm{Photon~number}",
               ylabel=L"\mathrm{p(n)}",
               titlesize=34.0f0,
               xticklabelsize=20.0f0,
               yticklabelsize=20.0f0,
               xlabelsize=30.0f0,
               ylabelsize=30.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               limits=(0,150,0,nothing),
               xticks=0:10:last(n),
              
              )
#set_theme!(colormap = :berlin)

map(s->lines!(ax,p_n[s],linewidth=5),eachindex(n_mean))
map(s->stem!(ax,mean_p[s],label=latexstring("\\langle n \\rangle =",n_mean[s]),marker=:circle,markersize=20,stemwidth=5),eachindex(n_mean))
axislegend(labelsize=20.0f0)


# Photon numer distribution of Fock state
n_mean =(1,10,100);

# Domain of the number of photons
n=0:1:2*last(n_mean);

# Evluation of the functions
p_n = collect(map(s-> pdf(Dirac(s),n) ,n_mean));

# Mean coordinates
mean_p = map(s->(mean(Dirac(s)),pdf(Dirac(s),s)),n_mean);

# Define a theme with a custom colormap
my_theme = Theme(
    font = "Computer Modern",
    colormap = :viridis,  # or any valid colormap name/object
    palette = (color = Makie.wong_colors(),)  # optional categorical colors
)

# Apply the theme to the entire figure
set_theme!(my_theme)


fig_fock=Figure(size=(1080,1080));
ax=Axis(fig_fock[1,1:2],
               title=L"\mathrm{Photon~number~distribution~of~Fock~state}",
               xlabel=L"\mathrm{Photon~number}",
               ylabel=L"\mathrm{p(n)}",
               titlesize=34.0f0,
               xticklabelsize=20.0f0,
               yticklabelsize=20.0f0,
               xlabelsize=30.0f0,
               ylabelsize=30.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               limits=(0,150,0,nothing),
               xticks=0:10:last(n),
              
              )
#set_theme!(colormap = :berlin)

map(s->lines!(ax,p_n[s],linewidth=5),eachindex(n_mean))
map(s->stem!(ax,mean_p[s],label=latexstring("\\langle n \\rangle =",n_mean[s]),marker=:circle,markersize=20,stemwidth=5),eachindex(n_mean))
axislegend(labelsize=20.0f0)


# Photon numer distribution of Thermal state
n_mean =(1,10,100);

# Domain of the number of photons
n=0:1:2*last(n_mean);

# get the alpha parameter
alpha=map(s->omegaT_ratio(s),n_mean);

# Evluation of the functions
p_n = collect(map(s-> pdfThermal(s,n) ,alpha));

# Mean coordinates
mean_p = map(s->( n_mean[s] ,pdfThermal(alpha[s],n_mean[s])),eachindex(n_mean));

# Define a theme with a custom colormap
my_theme = Theme(
    font = "Computer Modern",
    colormap = :viridis,  # or any valid colormap name/object
    palette = (color = Makie.wong_colors(),)  # optional categorical colors
)

# Apply the theme to the entire figure
set_theme!(my_theme)


fig_thermal=Figure(size=(1080,1080));
ax=Axis(fig_thermal[1,1:2],
               title=L"\mathrm{Photon~number~distribution~of~thermal~state}",
               xlabel=L"\mathrm{Photon~number}",
               ylabel=L"\mathrm{p(n)}",
               titlesize=34.0f0,
               xticklabelsize=20.0f0,
               yticklabelsize=20.0f0,
               xlabelsize=30.0f0,
               ylabelsize=30.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               limits=(0,150,0,nothing),
               xticks=0:10:last(n),
              
              )
#set_theme!(colormap = :berlin)

map(s->lines!(ax,p_n[s],linewidth=5),eachindex(n_mean))
map(s->stem!(ax,mean_p[s],label=latexstring("\\langle n \\rangle =",n_mean[s]),marker=:circle,markersize=20,stemwidth=5),eachindex(n_mean))
axislegend(labelsize=20.0f0)



