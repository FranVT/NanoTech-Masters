"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
using Plots, LaTeXStrings

include("functions.jl")

# Get a data frame with all the data.dat files information
df = getDF();

# Desire parameters 
date="2025-03-18-060945-phi-0.5-CLcon-0.01-Part-1500-shear-0.001-Nexp-1";
gamma_dot=0.001;
cl_con=0.01;
Npart=1500;

# New data frame
df_new = filter([:"Shear-rate",:"CL-Con",:"Npart",:"main-directory"] => (f1,f2,f3,f4) -> f1==gamma_dot && f2==cl_con && f3==Npart && f4==date,df);# Get the information in data frames
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

# Pressure 
fig_p=plot(
                title=L"\mathrm{Pressure}",
                xlabel=L"\mathrm{LJ}~\tau",
                ylabel=L"p",
                legend_position=:bottomright,
                framestyle=:box,
                formatter=:scientific,
                size=(1050,788),
            );
plot!(df_new."time-step".*df_assembly."TimeStep",df_assembly."p",label=L"\mathrm{Assembly}");
plot!(df_new."time-step".*(last(df_assembly."TimeStep") .+ df_shear."TimeStep"),df_shear."p",label=L"\mathrm{Shear}");

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

# Stress 
fig_stress_xy=plot(
                title=L"\mathrm{Stress}~xy",
                xlabel=L"\mathrm{LJ}~\tau",
                ylabel=L"\sigma_{xy}",
                legend_position=:bottomright,
                framestyle=:box,
                formatter=:scientific,
                size=(1050,788),
            );
plot!(df_new."time-step".*df_stressA."TimeStep",-df_stressA."xy",label=L"\mathrm{Assembly}");
plot!(df_new."time-step".*(last(df_stressA."TimeStep") .+ df_stressS."TimeStep"),-df_stressS."xy",label=L"\mathrm{Shear}");


stress_ass = sqrt.( df_stressA."xx".^2 .+ df_stressA."yy".^2 .+ df_stressA."zz".^2 .+ (2).*(df_stressA."xy".^2 .+ df_stressA."xz".^2 .+ df_stressA."yz".^2)  );
stress_she = sqrt.( df_stressS."xx".^2 .+ df_stressS."yy".^2 .+ df_stressS."zz".^2 .+ (2).*(df_stressS."xy".^2 .+ df_stressS."xz".^2 .+ df_stressS."yz".^2)  );

pressure_ass = (1/3).*(df_stressA."xx" .+ df_stressA."yy" .+ df_stressA."zz");
pressure_she = (1/3).*(df_stressS."xx" .+ df_stressS."yy" .+ df_stressS."zz");

# Stress 
fig_stress=plot(
                title=L"\mathrm{Stress~Tensor}",
                xlabel=L"\mathrm{LJ}~\tau",
                ylabel=L"\sigma",
                legend_position=:bottomright,
                framestyle=:box,
                formatter=:scientific,
                size=(1050,788),
            );
plot!(df_new."time-step".*df_stressA."TimeStep",stress_ass,label=L"\mathrm{Assembly}");
plot!(df_new."time-step".*(last(df_stressA."TimeStep") .+ df_stressS."TimeStep"),stress_she,label=L"\mathrm{Shear}");

# Stress 
fig_pressure=plot(
                title=L"\mathrm{Pressure~Tensor}",
                xlabel=L"\mathrm{LJ}~\tau",
                ylabel=L"p",
                legend_position=:bottomright,
                framestyle=:box,
                formatter=:scientific,
                size=(1050,788),
            );
plot!(df_new."time-step".*df_stressA."TimeStep",pressure_ass,label=L"\mathrm{Assembly}");
plot!(df_new."time-step".*(last(df_stressA."TimeStep") .+ df_stressS."TimeStep"),pressure_she,label=L"\mathrm{Shear}");




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


"""
map(s->savefig(fig_temp,s),joinpath.(df_new."main-directory",df_new."imgs-dir","temp.png"))
map(s->savefig(fig_p,s),joinpath.(df_new."main-directory",df_new."imgs-dir","p.png"))
map(s->savefig(fig_h,s),joinpath.(df_new."main-directory",df_new."imgs-dir","H.png"))
map(s->savefig(fig_stress_xy,s),joinpath.(df_new."main-directory",df_new."imgs-dir","stress_xy.png"))
map(s->savefig(fig_energy,s),joinpath.(df_new."main-directory",df_new."imgs-dir","energy-log.png"))
"""

