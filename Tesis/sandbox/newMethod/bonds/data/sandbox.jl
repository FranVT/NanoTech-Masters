"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
using Plots, LaTeXStrings

include("functions.jl")




# Get a data frame with all the data.dat files information
df = getDF();

# Desire parameters 
gamma_dot=0.001;
cl_con=0.01;
Npart=1500;

# New data frame
df_new = filter([:"Shear-rate",:"CL-Con",:"Npart"] => (f1,f2,f3) -> f1==gamma_dot && f2==cl_con && f3==Npart,df);# Get the information in data frames

(df_assembly, df_shear, df_stressA, df_stressS) = extractInfo(df_new);

"""
    Plots
"""
default(fontfamily = "times", fontsize = 16)
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

map(s->savefig(fig_temp,s),joinpath.(df_new."main-directory",df_new."imgs-dir","temp.png"))

# Stress 
fig_stress=plot(
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

map(s->savefig(fig_stress,s),joinpath.(df_new."main-directory",df_new."imgs-dir","stress.png"))

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

map(s->savefig(fig_energy,s),joinpath.(df_new."main-directory",df_new."imgs-dir","energy-log.png"))


