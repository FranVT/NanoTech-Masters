"""
    Script to create graphs and stuff
"""

using GLMakie

include("functions.jl")

start_dir=pwd();

# Directories with information
dirs = (
        "systemCL100MO1900ShearRate2000Cycles4",
        "systemCL200MO1800ShearRate2000Cycles4",
        "systemCL300MO1700ShearRate2000Cycles4",
        "systemCL400MO1600ShearRate2000Cycles4"
      );


function getData(pwdDir,dir)
    pwdDir = joinpath(pwdDir,dir);
    
assemblyFiles_names = (
                       "energy_assembly.fixf",
                       "bondlenPatch_assembly.fixf",
                       "bondlenCL_assembly.fixf"
                      );

shearFiles_names = (
                        "energy_shear.fixf",
                        "bondlenPatch_shear.fixf",
                        "bondlenCL_shear.fixf",
                        "stressVirial_shear.fixf"
                      );

files = (assemblyFiles_names,shearFiles_names);


    data_energy = map(s->getFixInfo(joinpath(pwdDir,s[1])),files);
    data_blPatch = map(s->getFixInfo(joinpath(pwdDir,s[2])),files);
    data_blCL = map(s->getFixInfo(joinpath(pwdDir,s[3])),files);
    data_stress = getFixInfo(joinpath(pwdDir,shearFiles_names[4])); 
    return (data_energy,data_blPatch,data_blCL,data_stress)
end

info = map(s->getData(start_dir,s),dirs);

ids=(L"0.05%~\mathrm{CL}",L"0.10%~\mathrm{CL}",L"0.15%~\mathrm{CL}",L"0.20%~\mathrm{CL}");
color_id=(:orange,:darkgreen,:midnightblue,:gray0)

t_assembly = map(s->0.005.*only.(info[s][1][1][1,:]),eachindex(info));
T_assembly = map(s->only.(info[s][1][1][2,:]),eachindex(info));
U_assembly = map(s->only.(info[s][1][1][3,:]),eachindex(info));
K_assembly = map(s->only.(info[s][1][1][4,:]),eachindex(info));
E_assembly = U_assembly .+ K_assembly;

t_shear = map(s->last(t_assembly[s]) .+ 0.001.*only.(info[s][1][2][1,:]),eachindex(info));
T_shear = map(s->only.(info[s][1][2][2,:]),eachindex(info));
U_shear = map(s->only.(info[s][1][2][3,:]),eachindex(info));
K_shear = map(s->only.(info[s][1][2][4,:]),eachindex(info));
E_shear = U_shear .+ K_shear;

tf = maximum(last.(t_shear));

fig_Energy = Figure(size=(1080,980));
ax_T = Axis(fig_Energy[1,1:2],
                   title = L"\mathrm{Temperature}",
                   xlabel = L"\mathrm{Time~[tau]~log10}",
                   ylabel = L"\mathrm{T}",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                   xscale = log10,
                   limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
                  )
ax_E = Axis(fig_Energy[2,1:2],
                   title = L"\mathrm{Energy}",
                   xlabel = L"\mathrm{Time~[tau]~log10}",
                   ylabel = L"\mathrm{E}",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                   xscale = log10,
                   limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
                  )

map(s->lines!(ax_T,t_assembly[s],T_assembly[s],label=ids[s],color=color_id[s]),eachindex(T_assembly))
map(s->lines!(ax_T,t_shear[s],T_shear[s],label=ids[s],color=color_id[s]),eachindex(T_shear))
map(s->vlines!(ax_T,last(t_assembly[s])),eachindex(ids))
axislegend(ax_T,position=:rb,unique=true)

map(s->lines!(ax_E,t_assembly[s],E_assembly[s],label=ids[s],color=color_id[s]),eachindex(T_assembly))
map(s->lines!(ax_E,t_shear[s],E_shear[s],label=ids[s],color=color_id[s]),eachindex(T_shear))
map(s->vlines!(ax_E,last(t_assembly[s])),eachindex(ids))
axislegend(ax_E,position=:rb,unique=true)

## Bond lengths
tbp_assembly = map(s->0.005.*only.(info[s][2][1][1,:]),eachindex(info));
ebp_assembly = map(s->only.(info[s][2][1][2,:]),eachindex(info));

tbcl_assembly = map(s->0.005.*only.(info[s][3][1][1,:]),eachindex(info));
ebcl_assembly = map(s->only.(info[s][3][1][2,:]),eachindex(info));


tbp_shear = map(s-> last(tbp_assembly[s]) .+ 0.001.*only.(info[s][2][2][1,:]),eachindex(info));
ebp_shear = map(s->only.(info[s][2][2][2,:]),eachindex(info));

tbcl_shear = map(s-> last(tbcl_assembly[s]) .+ 0.001.*only.(info[s][3][2][1,:]),eachindex(info));
ebcl_shear = map(s->only.(info[s][3][2][2,:]),eachindex(info));

fig_Bond = Figure(size=(1080,980));
ax_Bond = Axis(fig_Bond[1,1:2],
                   title = L"\mathrm{Enegy~bond~from~patches}",
                   xlabel = L"\mathrm{Time~[tau]~log10}",
                   ylabel = L"\mathrm{E}",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                   xscale = log10,
                   limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
                  )
ax_CL = Axis(fig_Bond[2,1:2],
                   title = L"\mathrm{Energy~bond~from~Patches~of~CL}",
                   xlabel = L"\mathrm{Time~[tau]~log10}",
                   ylabel = L"\mathrm{E}",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                   xscale = log10,
                   limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
                  )


map(s->lines!(ax_Bond,tbp_assembly[s],ebp_assembly[s],label=ids[s],color=color_id[s]),eachindex(ids))
map(s->lines!(ax_Bond,tbp_shear[s],ebp_shear[s],label=ids[s],color=color_id[s]),eachindex(ids))
map(s->vlines!(ax_Bond,last(tbp_assembly[s])),eachindex(ids))
axislegend(ax_Bond,position=:rb,unique=true)


map(s->lines!(ax_CL,tbcl_assembly[s],ebcl_assembly[s],label=ids[s],color=color_id[s]),eachindex(ids))
map(s->lines!(ax_CL,tbcl_shear[s],ebcl_shear[s],label=ids[s],color=color_id[s]),eachindex(ids))
map(s->vlines!(ax_CL,last(tbcl_assembly[s])),eachindex(ids))
axislegend(ax_CL,position=:rb,unique=true)

## Stress 

tstress_shear = map(s-> (0.001).*only.(info[s][4][1,:]),eachindex(info));
stressXX_shear = map(s->only.(-info[s][4][3,:]),eachindex(info));
stressXY_shear = map(s->only.(-info[s][4][6,:]),eachindex(info));

fig_Stress = Figure(size=(1080,980));
ax_stressXX = Axis(fig_Stress[1,1:2],
                   title = L"\mathrm{Stress}~xx",
                   xlabel = L"\mathrm{Time [tau]}",
                   ylabel = L"\sigma",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                   #xscale = log10,
                   #limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
                  )
ax_stressXY = Axis(fig_Stress[2,1:2],
                   title = L"\mathrm{Stress}~xy",
                   xlabel = L"\mathrm{Time [tau]}",
                   ylabel = L"\sigma",
                   titlesize = 24.0f0,
                   xticklabelsize = 18.0f0,
                   yticklabelsize = 18.0f0,
                   xlabelsize = 20.0f0,
                   ylabelsize = 20.0f0,
                   xminorticksvisible = true, 
                   xminorgridvisible = true,
                   xminorticks = IntervalsBetween(5),
                   #xscale = log10,
                   #limits = (10e0,exp10(1+round(log10(tf))),nothing,nothing)
                  )

map(s->lines!(ax_stressXX,tstress_shear[s],stressXX_shear[s],label=ids[s],color=color_id[s]),eachindex(ids))
axislegend(ax_stressXX,position=:rb)

map(s->lines!(ax_stressXY,tstress_shear[s],stressXY_shear[s],label=ids[s],color=color_id[s]),eachindex(ids))
axislegend(ax_stressXY,position=:rb)

## Save the figures

save("Temp_Energ.png",fig_Energy)
save("BondEnerg.png",fig_Bond)
save("Stress.png",fig_Stress)



