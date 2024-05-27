"""
    Script to graph the solution of Poisson equation using FEM
"""

using GLMakie
using ElectronDisplay

GLMakie.activate!()
ElectronDisplay.CONFIG.single_window = true

ρ = source(Xgrid,Ygrid,30,25,3);

f = Figure(
    figure_padding =30,
    fontsize = 20,
    backgroundcolor = :white,
    size = (2*720,720)
)
axf = Axis(f[1,1][1,1],
    #aspect = DataAspect(),
    limits=(0,100,0,100),
    title = L"\mathrm{Solution~Poisson~equation}",
    xlabel = L"x",
    ylabel = L"y"
)
hmf = heatmap!(axf,xgrid,ygrid,Vgrid,colormap = :lipari50)
Colorbar(f[1,1][1,2],hmf,
    label = L"\phi(x,y)"
)
axg = Axis(f[1,2][1,1],
    #aspect = DataAspect(),
    limits=(0,100,0,100),
    title = L"\mathrm{Density~distribution}",
    xlabel = L"x",
    ylabel = L"y"
)
hmg = heatmap!(axg,xgrid,ygrid,ρ,colormap = :lipari50)
Colorbar(f[1,2][1,2],hmg,
    label = L"\rho(x,y)"
)
f

#save("hires.png", f, px_per_unit = 2)

f3 = Figure(
    figure_padding =60,
    fontsize = 18,
    backgroundcolor = :gray97,
    size = (2*720,720)
)
axf3 = Axis3(f3[1,1][1,1],
    #aspect = DataAspect(),
    limits=(0,100,0,100,minimum(Vgrid),maximum(Vgrid)),
    title = L"\mathrm{Solution~Poisson~equation}",
    xlabel = L"x",
    ylabel = L"y",
    zlabel = L"\phi(x,y)"
)
sf3 = surface!(axf3,xgrid,ygrid,Vgrid,colormap = :lipari50)
axg3 = Axis3(f3[1,2][1,1],
    #aspect = DataAspect(),
    limits=(0,100,0,100,minimum(ρ),maximum(ρ)),
    title = L"\mathrm{Density~distribution}",
    xlabel = L"x",
    ylabel = L"y",
    zlabel = L"\rho(x,y)"
)
sg3 = surface!(axg3,xgrid,ygrid,ρ,colormap = :lipari50)
f3