"""
fig = Figure(size=(600,400))
ax = Axis(fig[1,1],
    title=L"\mathrm{Distribution}",
    xlabel=L"x",
    ylabel=L"P(x,t)",
    xminorticksvisible = true,
    yminorticksvisible = true,
    xminorgridvisible = true,
    yminorgridvisible = true,
    xminorticks = IntervalsBetween(3+1)
    )
ax.aspect = AxisAspect(2/1)
lines!(r,sol[:,1])
lines!(r,sol[:,end])
#scatter!(r,solhd[:,end],markersize=5)
xlims!(ax,(first(r)-dr,last(r)+dr))

#limits!(ax,BBox(first(r)-dr,last(r)+dr,0-dr,1+dr))


# https://beautiful.makie.org/examples/2d/lines/line_cmap

"""