"""
    Sandbox script to test functions and stuff
"""

using DataFrames, CSV
using Plots, LaTeXStrings, Plots.PlotMeasures
gr()

include("functions.jl")

#= 
    D I R E C T O R I E S   AND   P A T H S
=#

# Get the parent directory
parent_dir=dirname(pwd());
# Select the siimulation scheme (Version and stuff)
scheme_dir="bonds-3.0";
# Select the "system" by id
id="2025-05-06-124111";
# Select the system by "cross-linker" concentration
cl_con=0.5;


# Path to the data directory of the simulation scheme
path_data=joinpath(parent_dir,scheme_dir,"data");
# Path to the data directory of the specific system
path_system=joinpath(path_data,string("system-",id,"-CL-",cl_con));


# Get a data frame with all the data.dat files information
df = getDF(path_system);

# Get the data from assembly simulation
df_assembly=extractInfoAssembly(path_system,df);




# Create the function to extract fix mode vector files info
file_name=vcat(df."file2");
aux=split.(readlines(joinpath(path_system,file_name...))," ");
    # Get time step and number of rows
    (TimeStep,nrows)=parse(Int64,aux[3]);










# Get the shear rates
#gamma_dot=df."Shear-rate";


# Get the info
#(df_assembly, df_shear, df_stressA, df_stressS) = extractInfo(df);


#=
    A S S E M B L Y     P L O T S  
=#

# Energy



#=
# New data frame
df_new = filter([:"Shear-rate",:"CL-Con",:"Npart",:"date"] => (f1,f2,f3,f4) -> f1==gamma_dot && f2==cl_con && f3==Npart && f4==date,df);# Get the information in data frames
#df_new = df_new[2,:]; 

(df_assembly, df_shear, df_stressA, df_stressS) = extractInfo(df_new);

# Algebraic manipulation to get the stress
(norm_press_ass,norm_press_she,norm_virialpress_ass,norm_virialpress_she,norm_virialModpress_ass,norm_virialModpress_she,norm_stress_ass,norm_stress_she,norm_virialstress_ass,norm_virialstress_she,norm_virialModstress_ass,norm_virialModstress_she)=normStressPressure(df_stressA,df_stressS);

"""
    Plots
"""
default(fontfamily = "times", fontsize = 18)

# Temporal domains
time_assembly=df_new."time-step".*df_assembly."TimeStep";
time_shear=last(time_assembly).+(df_new."time-step".*df_shear."TimeStep");

time_assembly_pressure=df_new."time-step".*df_stressA."TimeStep";
time_shear_pressure=last(time_assembly_pressure).+(df_new."time-step".*df_stressS."TimeStep");


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
plot!(time_assembly,df_assembly."Temp",label=L"\mathrm{Assembly}");
plot!(time_shear,df_shear."Temp",label=L"\mathrm{Shear}");

# Pressure
p1 = plot(
            title=L"\mathrm{Pressure}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"p",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,df_stressA.p,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,df_stressS.p,label=L"\mathrm{Shear}")

# Norm of pressure
p2 = plot(
            title=L"\mathrm{Norm~of~Pressure~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|p|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,norm_press_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,norm_press_she,label=L"\mathrm{Shear}")

# Trace of pressure tensor
p3 = plot(
            title=L"\mathrm{Trace~of~Pressure~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\mathrm{Tr}(p)",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,(1/3).*trace(df_stressA."press_xx",df_stressA."press_yy",df_stressA."press_zz"),label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,(1/3).*trace(df_stressS."press_xx",df_stressS."press_yy",df_stressS."press_zz"),label=L"\mathrm{Shear}")

# Virial Norm 
p4 = plot(
            title=L"\mathrm{Norm~of~Virial~Pressure~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|p|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,norm_virialpress_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,norm_virialpress_she,label=L"\mathrm{Shear}")

# Virial-mod norm
p5 = plot(
            title=L"\mathrm{Norm~of~Mod~Virial~Pressure~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|p|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,norm_virialModpress_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,norm_virialModpress_she,label=L"\mathrm{Shear}")

# Differences of the norm
p6 = plot(
            title=L"\mathrm{Diff~Norm~Viriral~vs~VirialMod}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|\mathrm{Virial}-\mathrm{Virial~Mod}|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,abs.(norm_virialpress_ass.-norm_virialModpress_ass),label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,abs.(norm_virialpress_she.-norm_virialModpress_she),label=L"\mathrm{Shear}")

# Trace of Virial tensor pressure (Virial pressure)
virialPressure_ass=(1/3).*trace(df_stressA."virialpress_xx",df_stressA."virialpress_yy",df_stressA."virialpress_zz");
virialPressure_she=(1/3).*trace(df_stressS."virialpress_xx",df_stressS."virialpress_yy",df_stressS."virialpress_zz");

virialPressureMod_ass=(1/3).*trace(df_stressA."virialpressmod_xx",df_stressA."virialpressmod_yy",df_stressA."virialpressmod_zz");
virialPressureMod_she=(1/3).*trace(df_stressS."virialpressmod_xx",df_stressS."virialpressmod_yy",df_stressS."virialpressmod_zz");

p7 = plot(
            title=L"\mathrm{Trace~of~Virial~Pressure~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\mathrm{Tr}(p)",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,virialPressure_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,virialPressure_she,label=L"\mathrm{Shear}")

p8 = plot(
            title=L"\mathrm{Trace~of~Mod~Virial~Pressure~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\mathrm{Tr}(p)",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,virialPressureMod_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,virialPressureMod_she,label=L"\mathrm{Shear}")

p9 = plot(
            title=L"\mathrm{Diff~Trace~Virial~vs~VirialMod}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|\mathrm{Virial}-\mathrm{Virial~Mod}|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,abs.(virialPressure_ass.-virialPressureMod_ass),label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,abs.(virialPressure_she.-virialPressureMod_she),label=L"\mathrm{Shear}")


# Combo of all previous plots
fig_pressure=plot(p1,p2,p3,p4,p5,p6,p7,p8,p9,
                layout = (3,3),
                suptitle = L"\mathrm{Compute~pressure}",
                plot_titlefontsize = 15,
                size=(1600,900)
             )

map(s->savefig(fig_temp,s),joinpath.(df_new."main-directory",df_new."imgs-dir","temp.png"))
map(s->savefig(fig_pressure,s),joinpath.(df_new."main-directory",df_new."imgs-dir","pressure.png"))

# Norm of Stress
p1 = plot(
            title=L"\mathrm{Norm~of~Stress}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|\sigma|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,norm_stress_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,norm_stress_she,label=L"\mathrm{Shear}")

# Norm of Virial Stress 
p2 = plot(
            title=L"\mathrm{Norm~of~Viriral~Stress~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|\sigma_{\mathrm{virial}}|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,norm_virialstress_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,norm_virialstress_she,label=L"\mathrm{Shear}")

# Norm of Virial-Mod Stress
p3 = plot(
            title=L"\mathrm{Norm~of~Viriral-Mod~Stress~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|\sigma_{\mathrm{virial-mod}}|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,norm_virialModstress_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,norm_virialModstress_she,label=L"\mathrm{Shear}")

# Difference Virial Norm 
p4 = plot(
            title=L"\mathrm{abs}\left(|\sigma| - |\sigma_{\mathrm{virial}}|\right)",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|\sigma| - |\sigma_{\mathrm{virial}}|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,abs.(norm_stress_ass.-norm_virialstress_ass),label=L"\mathrm{Assembly}\right)")
plot!(time_shear_pressure,abs.(norm_stress_she.-norm_virialstress_she),label=L"\mathrm{Shear}")

# Difference Virial-mod norm
p5 = plot(
            title=L"\mathrm{abs}\left(|\sigma| - |\sigma_{\mathrm{virial-mod}}|\right)",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|\sigma| - |\sigma_{\mathrm{virial-mod}}|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,abs.(norm_stress_ass.-norm_virialModstress_ass),label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,abs.(norm_stress_she.-norm_virialModstress_she),label=L"\mathrm{Shear}")

# Differences of the norm
p6 = plot(
            title=L"\mathrm{abs}\left(|\sigma_{\mathrm{virial}}| - |\sigma_{\mathrm{virial-mod}}|\right)",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"|\mathrm{Virial}-\mathrm{Virial~Mod}|",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,abs.(norm_virialstress_ass.-norm_virialModstress_ass),label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,abs.(norm_virialstress_she.-norm_virialModstress_she),label=L"\mathrm{Shear}")


# Trace of Virial tensor pressure (Virial pressure)
StressTrace_ass=(1/3).*trace(df_stressA."stress_xx",df_stressA."stress_yy",df_stressA."stress_zz");
StressTrace_she=(1/3).*trace(df_stressS."stress_xx",df_stressS."stress_yy",df_stressS."stress_zz");

virialStressTrace_ass=(1/3).*trace(df_stressA."virialstress_xx",df_stressA."virialstress_yy",df_stressA."virialstress_zz");
virialStressTrace_she=(1/3).*trace(df_stressS."virialstress_xx",df_stressS."virialstress_yy",df_stressS."virialstress_zz");

virialModStressTrace_ass=(1/3).*trace(df_stressA."virialstressmod_xx",df_stressA."virialstressmod_yy",df_stressA."virialstressmod_zz");
virialModStressTrace_she=(1/3).*trace(df_stressS."virialstressmod_xx",df_stressS."virialstressmod_yy",df_stressS."virialstressmod_zz");

p7 = plot(
            title=L"1/3\mathrm{Trace~of~Stress~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\mathrm{Tr}(\sigma)",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,StressTrace_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,StressTrace_she,label=L"\mathrm{Shear}")

p8 = plot(
            title=L"1/3\mathrm{Trace~of~Virial~Stress~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\mathrm{Tr}(p)",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,virialStressTrace_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,virialStressTrace_she,label=L"\mathrm{Shear}")

p9 = plot(
            title=L"1/3\mathrm{Trace~of~Mod~Virial~Stress~tensor}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\mathrm{Tr}(p)",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,virialModStressTrace_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,virialModStressTrace_she,label=L"\mathrm{Shear}")


# Combo of all previous plots
fig_stress=plot(p1,p2,p3,p4,p5,p6,p7,p8,p9,
                layout = (3,3),
                suptitle = L"\mathrm{Compute~stress/atom}",
                plot_titlefontsize = 15,
                size=(1600,900),
                right_margin=10px,
                left_margin=25px,
                top_margin=10px,
                bottom_margin=15px,
                yrotation=60,
             )

map(s->savefig(fig_stress,s),joinpath.(df_new."main-directory",df_new."imgs-dir","stress.png"))


# Contrast of Pressure and Stress
"""
    So ... from the lammps documentation we get the following relation,
    P = -1/V*Tr(sigma)
    Lets compute that and graphic
"""

p_stress_ass=-StressTrace_ass./(df_new."Vol_box");
p_stress_she=-StressTrace_she./(df_new."Vol_box");

# Pressure from compute pressure all t
p1 = plot(
            title=L"\mathrm{Pressure}",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"p",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,df_stressA.p,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,df_stressS.p,label=L"\mathrm{Shear}")

# Pressure from stress tensor 
p2 = plot(
            title=L"-\frac{1}{3V}\mathrm{Tr}(\sigma)",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"p",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,p_stress_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,p_stress_she,label=L"\mathrm{Shear}")

# Difference Pressure from stress tensor 
p3 = plot(
            title=L"p-\left(-\frac{1}{3V}\mathrm{Tr}(\sigma)\right)",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"p",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,df_stressA.p .- p_stress_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,df_stressS.p .- p_stress_she,label=L"\mathrm{Shear}")

# Traces of the Stress tensor

p4 = plot(
            title=L"1/3\mathrm{Tr}(\sigma)",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\sigma",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,StressTrace_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,StressTrace_she,label=L"\mathrm{Shear}")

p5 = plot(
            title=L"1/3\mathrm{Tr}(\sigma_\mathrm{virial})",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\sigma",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,virialStressTrace_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,virialStressTrace_she,label=L"\mathrm{Shear}")

p6 = plot(
            title=L"1/3\mathrm{Tr}(\sigma) - 1/3\mathrm{Tr}(\sigma_\mathrm{virial})",
            xlabel = L"\mathrm{LJ}~\tau",
            ylabel = L"\sigma",
            legend_position=:bottomright,
            formatter=:scientific,
            framestyle=:box
           )
plot!(time_assembly_pressure,StressTrace_ass.-virialStressTrace_ass,label=L"\mathrm{Assembly}")
plot!(time_shear_pressure,StressTrace_she.-virialStressTrace_she,label=L"\mathrm{Shear}")

# Combo of all previous plots
fig_pComp=plot(p1,p2,p3,p4,p5,p6,
                layout = (2,3),
                suptitle = L"\mathrm{Pressure~from~compute~stress/atom}",
                plot_titlefontsize = 15,
                size=(1600,900)
             )

map(s->savefig(fig_pComp,s),joinpath.(df_new."main-directory",df_new."imgs-dir","stress-pressure.png"))
=#

