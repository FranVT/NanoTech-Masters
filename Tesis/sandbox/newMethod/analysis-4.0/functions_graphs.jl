"""
    Script for graphs functions 
"""

function plotSystem(time,temp,lbl,title)
"""
    Plot the strain vs stress given ONE dataframe
"""

fig_comp=plot(time,temp,
                framestyle = :box,
                layout = (1,1),
                size=(1600,900),
                right_margin=10px,
                left_margin=30px,
                top_margin=10px,
                bottom_margin=30px,
                labels = false,
                titlefontsize = 24,
                xlabelfontsize=20,
                legendfontsize = 12,
                xtickfontsize = 14,
                ytickfontsize = 14,
                xguidefontsize = 12,
                yguidefontsize = 12,
                annotationfontsize = 12,
                title = title,
                xlabel = "strain"
               )
map(s->plot!([NaN],[NaN],label=string(1000*s...)),lbl)
plot!(
      legend_title = L"\dot{\gamma}\times10^{-3}",
        legend_title_font_pointsize = 16,
        legend_column = div(length(lbl),2)
     )

    return fig_comp
end

function plotStrainShear(strain,shear,assembly_dat,shear_dat,title,subtitle,ylbl)
"""
    Plot strain vs shear
"""

fig=Figure(size=(1080,900));

clbr=:managua10;

ax=Axis(fig[1:1,1:1],
    title=latexstring(title),
    subtitle=latexstring(subtitle),
    xlabel=L"\mathrm{Strain}",
    ylabel=latexstring(ylbl), #L"\langle\sigma_{xy}\rangle",
    titlesize=24.0f0,
    subtitlesize=20.0f0,
    xticklabelsize=18.0f0,
    yticklabelsize=18.0f0,
    xlabelsize=22.0f0,
    ylabelsize=22.0f0,
    xminorticksvisible=true,
    xminorgridvisible=true
   )

series!([Point2f.(strain[s],shear[s]) for s in eachindex(shear_dat)],labels=string.((1000).*reduce(vcat,systemShear.dgamma)),color=clbr)

labels = [latexstring("\\mathrm{Number~of~particles}: ",assembly_dat."Npart"...),
          latexstring("\\mathrm{Packing~fraction}: ",assembly_dat."phi"...), 
          latexstring("\\mathrm{Cl~concentration}: ",assembly_dat."CL-Con"...), 
          latexstring("\\mathrm{Damp}: ",assembly_dat."damp"...), 
          latexstring("\\mathrm{Number~of~experiments}: ",first(shear_dat)."Nexp"...), 
          latexstring("\\mathrm{Time~Avg}: ",first(shear_dat)."save-fix"./first(shear_dat)."N_def"...,"\\gamma")
         ]

Legend(fig[1,2],ax,
       L"\dot{\gamma}\times 10^{-3}",
       linewidth=5,
       titlesize=20,
       labelsize=18
      )

elem = MarkerElement(color = :black, marker = :circle, markersize = 0.1, strokecolor = :black)


Legend(fig[2,1],
       [elem for i in eachindex(labels)],
    labels,
    patchsize = (5, 5), rowgap = 10,
    orientation = :horizontal
   )

    return fig

end

function plotTimeSystem(strain,shear,assembly_dat,shear_dat,title,subtitle,ylbl)
"""
    Plot strain vs shear
"""

fig=Figure(size=(1080,900));

clbr=:managua10;

ax=Axis(fig[1:1,1:1],
    title=latexstring(title),
    subtitle=latexstring(subtitle),
    xlabel=L"\mathrm{Strain}",
    ylabel=latexstring(ylbl), #L"\langle\sigma_{xy}\rangle",
    titlesize=24.0f0,
    subtitlesize=20.0f0,
    xticklabelsize=18.0f0,
    yticklabelsize=18.0f0,
    xlabelsize=22.0f0,
    ylabelsize=22.0f0,
    xminorticksvisible=true,
    xminorgridvisible=true
   )

#strain[s].*
series!([Point2f.(eachindex(strain[s]).*shear_dat[s]."time-step".*shear_dat[s]."save-fix".*systemShear.dgamma[s],shear[s]) for s in eachindex(shear_dat)],labels=string.((1000).*reduce(vcat,systemShear.dgamma)),color=clbr)


labels = [latexstring("\\mathrm{Number~of~particles}: ",assembly_dat."Npart"...),
          latexstring("\\mathrm{Packing~fraction}: ",assembly_dat."phi"...), 
          latexstring("\\mathrm{Cl~concentration}: ",assembly_dat."CL-Con"...), 
          latexstring("\\mathrm{Damp}: ",assembly_dat."damp"...), 
          latexstring("\\mathrm{Number~of~experiments}: ",first(shear_dat)."Nexp"...), 
          latexstring("\\mathrm{Time~Avg}: ",first(shear_dat)."save-fix"./first(shear_dat)."N_def"...,"\\gamma")
         ]

Legend(fig[1,2],ax,
       L"\dot{\gamma}\times 10^{-3}",
       linewidth=5,
       titlesize=20,
       labelsize=18
      )

elem = MarkerElement(color = :black, marker = :circle, markersize = 0.1, strokecolor = :black)


Legend(fig[2,1],
       [elem for i in eachindex(labels)],
    labels,
    patchsize = (5, 5), rowgap = 10,
    orientation = :horizontal
   )

    return fig

end




#=
function Strain_Shear(L,shear_dat,system_shear,stress_shear)
"""
    Prepare the data to plot
"""

    # Indixes for the shear moments
    aux=shear_dat."time-step".*shear_dat."Shear-rate".*shear_dat."save-stress";
    # Time steps per set of deformations
    N_deform=shear_dat."Max-strain".*shear_dat."N_def";
    # Time steps stored due to time average/Total of index per deformation cycle
    ind_cycle=div.(N_deform,shear_dat."save-stress",RoundDown);

    cycle=(1:1:length(stress_shear."TimeStep"));


    # Create strain and time domains
    strain=aux[1].*cycle;


xx=stress_shear."c_stress[1]";
yy=stress_shear."c_stress[2]";
zz=stress_shear."c_stress[3]";
xy=stress_shear."c_stress[4]";
xz=stress_shear."c_stress[5]";
yz=stress_shear."c_stress[6]";

norm_stress=norm(xx,yy,zz,xy,xz,yz);

xx_virial=stress_shear."c_stressVirial[1]";
yy_virial=stress_shear."c_stressVirial[2]";
zz_virial=stress_shear."c_stressVirial[3]";
xy_virial=stress_shear."c_stressVirial[4]";
xz_virial=stress_shear."c_stressVirial[5]";
yz_virial=stress_shear."c_stressVirial[6]";

norm_stressVirial=norm(xx_virial,yy_virial,zz_virial,xy_virial,xz_virial,yz_virial);

return (gamma=strain,sxy=xy[cycle],svirxy=xy_virial[cycle],snorm=norm_stress[cycle],svirnorm=norm_stressVirial[cycle],dgamma=shear_dat."Shear-rate")

end

function plotStrain_Shear(strain,stress,lbl,title,datA,datS)
"""
    Plot the strain vs stress given ONE dataframe
"""

fig_comp=plot(strain,stress,
                framestyle = :box,
                layout = (1,1),
                size=(1400,900),
                right_margin=5mm,
                left_margin=5mm,
                top_margin=5mm,
                bottom_margin=5mm,
                labels = false,
                titlefontsize = 24,
                xlabelfontsize=20,
                legendfontsize = 12,
                xtickfontsize = 14,
                ytickfontsize = 14,
                xguidefontsize = 12,
                yguidefontsize = 12,
                annotationfontsize = 12,
                title = title,
                xlabel = "strain",
                palette = :bamako10
               )
map(s->plot!([NaN],[NaN],label=string(1000*s...)),lbl)
plot!(
      legend_title = L"\dot{\gamma}\times10^{-3}",
        legend_title_font_pointsize = 16,
        legend_column = 1, #div(length(lbl),2),
        legend=:outerright
     )



inset_bbox = bbox(0.5, 0.65, 0.3, 0.25, :bottom, :left)

plot!([NaN],[NaN],
      label=string("Total particles: ",datA."Npart"[1]),
      linealpha = 0,
      markeralpha = 0,
      inset=inset_bbox,
      subplot=2,
      grid=false,
      axis=false,
      bg_inside=:transparent,
      framestyle=:none,
      legend=:topright,
      legend_column = 2,
        legend_font_pointsize=12
     )
plot!([NaN],[NaN],
      label=string("damp: ",datA."damp"...),
      linealpha = 0,
      markeralpha = 0,
      subplot=2
     )
plot!([NaN],[NaN],
      label=string("Number of experiments: ",datS[1]."Nexp"...),
      linealpha = 0,
      markeralpha = 0,
      subplot=2
     )
plot!([NaN],[NaN],
      label=string("Packing fraction: ",datA."phi"...),
      linealpha = 0,
      markeralpha = 0,
      subplot=2
    )
plot!([NaN],[NaN],
      label=string("Cl Concentration: ",datA."CL-Con"...),
      linealpha = 0,
      markeralpha = 0,
     subplot=2
    )




    return fig_comp
end
=#


