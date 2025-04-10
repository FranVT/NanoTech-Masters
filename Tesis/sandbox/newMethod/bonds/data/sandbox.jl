"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
using Plots, LaTeXStrings

include("functions.jl")

# Get a data frame with all the data.dat files information
df = getDF();

# Desire parameters 
date="2025-04-09-191309";
gamma_dot=0.05;
cl_con=0.05;
Npart=2500;

# New data frame
df_new = filter([:"Shear-rate",:"CL-Con",:"Npart",:"date"] => (f1,f2,f3,f4) -> f1==gamma_dot && f2==cl_con && f3==Npart && f4==date,df);# Get the information in data frames
#df_new = df_new[2,:]; 

(df_assembly, df_shear, df_stressA, df_stressS) = extractInfo(df_new);

"""
    Plots
"""
default(fontfamily = "times", fontsize = 18)
# Temperature
fig_temp=plot(
                title=L"\mathrm{Temperature}",
                xlabel=L"\mathrm{LJ}~\tau",
                ylabel=L"T",
                legend_position=:bottomright,
                framestyle=:box,
                formatter=:scientific,
                size=(1050,788),
            );
plot!(df_new."time-step".*df_assembly."TimeStep",df_assembly."Temp",label=L"\mathrm{Assembly}");
plot!(df_new."time-step".*(last(df_assembly."TimeStep") .+ df_shear."TimeStep"),df_shear."Temp",label=L"\mathrm{Shear}");

# Stress figure Norm

# Virial
stress_ass = sqrt.( df_stressA."xx".^2 .+ df_stressA."yy".^2 .+ df_stressA."zz".^2 .+ (2).*(df_stressA."xy".^2 .+ df_stressA."xz".^2 .+ df_stressA."yz".^2)  );
stress_she = sqrt.( df_stressS."xx".^2 .+ df_stressS."yy".^2 .+ df_stressS."zz".^2 .+ (2).*(df_stressS."xy".^2 .+ df_stressS."xz".^2 .+ df_stressS."yz".^2)  );

pressure_ass = (1/3).*(df_stressA."xx" .+ df_stressA."yy" .+ df_stressA."zz");
pressure_she = (1/3).*(df_stressS."xx" .+ df_stressS."yy" .+ df_stressS."zz");


# stress/atom all
stress_ass_atom = sqrt.( df_stressA."xx_atom".^2 .+ df_stressA."yy_atom".^2 .+ df_stressA."zz_atom".^2 .+ (2).*(df_stressA."xy_atom".^2 .+ df_stressA."xz_atom".^2 .+ df_stressA."yz_atom".^2)  );
stress_she_atom = sqrt.( df_stressS."xx_atom".^2 .+ df_stressS."yy_atom".^2 .+ df_stressS."zz_atom".^2 .+ (2).*(df_stressS."xy_atom".^2 .+ df_stressS."xz_atom".^2 .+ df_stressS."yz_atom".^2)  );

pressure_ass_atom = (1/3).*(df_stressA."xx_atom" .+ df_stressA."yy_atom" .+ df_stressA."zz_atom");
pressure_she_atom = (1/3).*(df_stressS."xx_atom" .+ df_stressS."yy_atom" .+ df_stressS."zz_atom");


# stress/atom patches
stress_ass_patch = sqrt.( df_stressA."xx_patch".^2 .+ df_stressA."yy_patch".^2 .+ df_stressA."zz_patch".^2 .+ (2).*(df_stressA."xy_patch".^2 .+ df_stressA."xz_patch".^2 .+ df_stressA."yz_patch".^2)  );
stress_she_patch = sqrt.( df_stressS."xx_patch".^2 .+ df_stressS."yy_patch".^2 .+ df_stressS."zz_patch".^2 .+ (2).*(df_stressS."xy_patch".^2 .+ df_stressS."xz_patch".^2 .+ df_stressS."yz_patch".^2)  );

pressure_ass_patch = (1/3).*(df_stressA."xx_patch" .+ df_stressA."yy_patch" .+ df_stressA."zz_patch");
pressure_she_patch = (1/3).*(df_stressS."xx_patch" .+ df_stressS."yy_patch" .+ df_stressS."zz_patch");


# stress/atom central particles 
stress_ass_central = sqrt.( df_stressA."xx_part".^2 .+ df_stressA."yy_part".^2 .+ df_stressA."zz_part".^2 .+ (2).*(df_stressA."xy_part".^2 .+ df_stressA."xz_part".^2 .+ df_stressA."yz_part".^2)  );
stress_she_central = sqrt.( df_stressS."xx_part".^2 .+ df_stressS."yy_part".^2 .+ df_stressS."zz_part".^2 .+ (2).*(df_stressS."xy_part".^2 .+ df_stressS."xz_part".^2 .+ df_stressS."yz_part".^2)  );

pressure_ass_central = (1/3).*(df_stressA."xx_part" .+ df_stressA."yy_part" .+ df_stressA."zz_part");
pressure_she_central = (1/3).*(df_stressS."xx_part" .+ df_stressS."yy_part" .+ df_stressS."zz_part");


# Plot of the norm
time_assembly=df_new."time-step".*df_stressA."TimeStep";
time_shear=last(time_assembly).+(df_new."time-step".*df_stressS."TimeStep");

p1 = plot(
            title=L"-\mathrm{Norm}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"-|\sigma|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly,-stress_ass,label=L"\mathrm{Assembly}")
plot!(time_shear,-stress_she,label=L"\mathrm{Shear}")

# Plot of the trace of the stress tensor of the system
p2 = plot(
            title=L"1/3\mathrm{Trace}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\mathrm{Tr}(\sigma)",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly,pressure_ass,label=L"\mathrm{Assembly}")
plot!(time_shear,pressure_she,label=L"\mathrm{Shear}")

# Plot of the xy component of the stress tensor
p3 = plot(
            title=L"-\sigma_{xy}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"-\sigma_{xy}",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly,-df_stressA."xy",label=L"\mathrm{Assembly}")
plot!(time_shear,-df_stressS."xy",label=L"\mathrm{Shear}")

# Plot of the xy component of the stress tensor during shear
p4 = plot(
            title=L"-\sigma_{xy}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"-\sigma_{xy}",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
#plot!(time_assembly,df_stressA."xy",label=L"\mathrm{Assembly}")
plot!(time_shear,-df_stressS."xy",label=L"\mathrm{Shear}")

# Combo of all previous plots
pressure=plot(p1,p2,p3,p4,
                layout = (2,2),
                suptitle = L"\mathrm{Compute~pressure}",
                plot_titlefontsize = 15
             )


# Plot compute stress/atom

# Plot of the norm
p1 = plot(
            title=L"-\mathrm{Norm}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"-|\sigma|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly,-stress_ass_atom,label=L"\mathrm{Assembly}")
plot!(time_shear,-stress_she_atom,label=L"\mathrm{Shear}")

# Plot of the trace of the stress tensor of the system
p2 = plot(
            title=L"1/3~\mathrm{Trace}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\mathrm{Tr}(\sigma)",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly,pressure_ass_atom,label=L"\mathrm{Assembly}")
plot!(time_shear,pressure_she_atom,label=L"\mathrm{Shear}")

# Plot of the xy component of the stress tensor
p3 = plot(
            title=L"\sigma_{xy}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\sigma_{xy}",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly,df_stressA."xy_atom",label=L"\mathrm{Assembly}")
plot!(time_shear,df_stressS."xy_atom",label=L"\mathrm{Shear}")

# Plot of the xy component of the stress tensor during shear
p4 = plot(
            title=L"\sigma_{xy}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\sigma_{xy}",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
#plot!(time_assembly,df_stressA."xy",label=L"\mathrm{Assembly}")
plot!(time_shear,df_stressS."xy_atom",label=L"\mathrm{Shear}")

# Combo of all previous plots
stress_atom=plot(p1,p2,p3,p4,
                layout = (2,2),
                suptitle = L"\mathrm{Compute~stress/atom~all}",
                plot_titlefontsize = 15
             )





# Enthalpy 
fig_h=plot(
           title=L"\mathrm{Enthalpy}",
                xlabel=L"\mathrm{LJ}~\tau",
                ylabel=L"H",
                legend_position=:bottomright,
                framestyle=:box,
                formatter=:scientific,
                size=(1050,788),
            );
plot!(df_new."time-step".*df_assembly."TimeStep",df_assembly."H",label=L"\mathrm{Assembly}");
plot!(df_new."time-step".*(last(df_assembly."TimeStep") .+ df_shear."TimeStep"),df_shear."H",label=L"\mathrm{Shear}");

# Energy 
fig_energy=plot(
                title=L"\mathrm{Total~Energy}",
                xlabel=L"\mathrm{Times~Steps}",
                ylabel=L"\mathrm{Energy}~[\epsilon]",
                legend_position=:topright,
                framestyle=:box,
                formatter=:plain,
                xscale=:log10,
                size=(1050,788),
            );
plot!(df_assembly."TimeStep",df_assembly."Etot",label=L"\mathrm{Assembly}");
plot!(last(df_assembly."TimeStep") .+ df_shear."TimeStep",df_shear."Etot",label=L"\mathrm{Shear}");



map(s->savefig(stress_atom,s),joinpath.(df_new."main-directory",df_new."imgs-dir","compute_stress.png"))
map(s->savefig(pressure,s),joinpath.(df_new."main-directory",df_new."imgs-dir","compute_pressure.png"))




"""
map(s->savefig(fig_temp,s),joinpath.(df_new."main-directory",df_new."imgs-dir","temp.png"))
map(s->savefig(fig_p,s),joinpath.(df_new."main-directory",df_new."imgs-dir","p.png"))
map(s->savefig(fig_h,s),joinpath.(df_new."main-directory",df_new."imgs-dir","H.png"))
map(s->savefig(fig_stress_xy,s),joinpath.(df_new."main-directory",df_new."imgs-dir","stress_xy.png"))
map(s->savefig(fig_energy,s),joinpath.(df_new."main-directory",df_new."imgs-dir","energy-log.png"))
"""
