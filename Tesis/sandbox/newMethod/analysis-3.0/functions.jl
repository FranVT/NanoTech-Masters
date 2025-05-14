"""
    Script to declare usefull functions to analyse data
"""

function norm(xx,yy,zz,xy,xz,yz)
"""
    Compute the norm of a symetric tensor
"""
    return sqrt.(xx.^2 .+ yy.^2 .+ zz.^2 .+ (2).*(xy.^2 .+ xz.^2 .+ yz.^2))
end

function trace(xx,yy,zz)
"""
    Computes the trace
"""
    return xx.+yy.+zz
end

function getDataFiles(path,file_name)
"""
    Function that retrieves data files from the path
"""
    # Read the file from the path

    return DataFrame(CSV.File(joinpath(path,file_name)))
end

function extractFixScalar(path_system,df,file_name)
"""
    Function that extracts the information of fix files that stores global scalar values
"""
    aux=split.(readlines(joinpath(path_system,file_name))," ");
    return (aux[2][2:end],reduce(hcat,map(s->parse.(Float64,s),aux[3:end])));
end

function extractFixCluster(path_system,df,file_name)
"""
    Function that extracts the information of fix mode vector files 
"""
    aux=split.(readlines(joinpath(path_system,file_name))," ");
    ind_o=4;
    nrows=[];
    data=[];

    # Initializa the stuff 
    # Get the time headder information 
    (ts,nr)=parse.(Int64,aux[ind_o]);
    # Get the ids of each cluster 
    idclust=map(s->parse.(Int64,s[2]),aux[ind_o+1:ind_o+nr]);   
    # Get the size of each cluster
    sizes=map(s->parse.(Int64,s),last.(aux[ind_o+1:ind_o+nr]));
    # Add the data into auxiliary varaible for future dataframe
    push!(data,(TimeStep=ts,NClust=nr,IDClust=idclust,SizeClust=sizes));
    
    append!(nrows,nr); # Keep track of the length of the file

    while isassigned(aux,ind_o+sum(nrows)+length(nrows))
        local ts 
        local nr
        local idclust
        local sizes
        ind=ind_o+sum(nrows)+length(nrows);
        (ts,nr)=parse.(Int64,aux[ind]);
        # Get the ids of each cluster 
        idclust=map(s->parse.(Int64,s[2]),aux[ind+1:ind+nr]);   
        # Get the size of each cluster
        sizes=map(s->parse.(Int64,s),last.(aux[ind+1:ind+nr]));
        # Add the data into auxiliary varaible for future dataframe
        push!(data,(TimeStep=ts,NClust=nr,IDClust=idclust,SizeClust=sizes));
        
        append!(nrows,nr); # Keep track of the length of the file
        
    end

    return DataFrame(data);
end

function extractFixProfile(path_system,df,file_name)
"""
    Function that extracts the information of fix mode vector files 
"""
    aux=split.(readlines(joinpath(path_system,file_name))," ");
    ind_o=4;
    nrows=[];
    data=[];

    # Initializa the stuff 
    # Get the time headder information 
    (ts,nr)=round.(Int64,parse.(Float64,aux[ind_o]));
    # Get x coordinate of spatial chunk 
    chunk_x=map(s->parse.(Float64,s[4]),aux[ind_o+1:ind_o+nr]);
    chunk_y=map(s->parse.(Float64,s[5]),aux[ind_o+1:ind_o+nr]);
    chunk_z=map(s->parse.(Float64,s[6]),aux[ind_o+1:ind_o+nr]);
    count=map(s->parse.(Float64,s[7]),aux[ind_o+1:ind_o+nr]);
    chunk_vx=map(s->parse.(Float64,s[8]),aux[ind_o+1:ind_o+nr]);
    chunk_vy=map(s->parse.(Float64,s[9]),aux[ind_o+1:ind_o+nr]);
    chunk_vz=map(s->parse.(Float64,s[10]),aux[ind_o+1:ind_o+nr]);
    chunk_dx=map(s->parse.(Float64,s[11]),aux[ind_o+1:ind_o+nr]);
    chunk_dy=map(s->parse.(Float64,s[12]),aux[ind_o+1:ind_o+nr]);
    chunk_dz=map(s->parse.(Float64,s[13]),aux[ind_o+1:ind_o+nr]);
    chunk_dd=map(s->parse.(Float64,s[14]),aux[ind_o+1:ind_o+nr]);

    # Add the data into auxiliary varaible for future dataframe
    push!(data,(TimeStep=ts,X=chunk_x,Y=chunk_y,Z=chunk_z,Count=count,vx=chunk_vx,vy=chunk_vy,vz=chunk_vz,Dx=chunk_dx,Dy=chunk_dy,Dz=chunk_dz,Dd=chunk_dd));
    
    append!(nrows,nr); # Keep track of the length of the file

    while isassigned(aux,ind_o+sum(nrows)+length(nrows))
        local ts; local nr; local count; local chunk_dd;
        local chunk_x; local chunk_y; local chunk_z;
        local chunk_vx; local chunk_vy; local chunk_vz;
        local chunk_dx; local chunk_dy; local chunk_dz; 

        ind=ind_o+sum(nrows)+length(nrows);
        (ts,nr)=round.(Int64,parse.(Float64,aux[ind_o]));
        # Get x coordinate of spatial chunk 
        chunk_x=map(s->parse.(Float64,s[4]),aux[ind_o+1:ind_o+nr]);
        chunk_y=map(s->parse.(Float64,s[5]),aux[ind_o+1:ind_o+nr]);
        chunk_z=map(s->parse.(Float64,s[6]),aux[ind_o+1:ind_o+nr]);
        count=map(s->parse.(Float64,s[7]),aux[ind_o+1:ind_o+nr]);
        chunk_vx=map(s->parse.(Float64,s[8]),aux[ind_o+1:ind_o+nr]);
        chunk_vy=map(s->parse.(Float64,s[9]),aux[ind_o+1:ind_o+nr]);
        chunk_vz=map(s->parse.(Float64,s[10]),aux[ind_o+1:ind_o+nr]);
        chunk_dx=map(s->parse.(Float64,s[11]),aux[ind_o+1:ind_o+nr]);
        chunk_dy=map(s->parse.(Float64,s[12]),aux[ind_o+1:ind_o+nr]);
        chunk_dz=map(s->parse.(Float64,s[13]),aux[ind_o+1:ind_o+nr]);
        chunk_dd=map(s->parse.(Float64,s[14]),aux[ind_o+1:ind_o+nr]);

    # Add the data into auxiliary varaible for future dataframe
        push!(data,(TimeStep=ts,X=chunk_x,Y=chunk_y,Z=chunk_z,Count=count,vx=chunk_vx,vy=chunk_vy,vz=chunk_vz,Dx=chunk_dx,Dy=chunk_dy,Dz=chunk_dz,Dd=chunk_dd));
    
        append!(nrows,nr); # Keep track of the length of the file
        
    end

    return DataFrame(data);
end


function extractInfoAssembly(path_system,df)
"""
    Function that reads the files and extract all the information
    file0 -> system_assembly
    file1 -> stress_assembly
    file2 -> clust_assembly
    file3 -> profiles_assembly
    file4 -> traj_assembly
    file5 -> data.hydrogel
"""

    # Extract info from system system
    (headers,info)=extractFixScalar(path_system,df,df."file0"...);
    system_assembly=DataFrame(info',headers);

    # Extract info from stress
    (headers,info)=extractFixScalar(path_system,df,df."file1"...);
    stress_assembly=DataFrame(info',headers);

    # Extract info from the cluster files
    clust_assembly=extractFixCluster(path_system,df,df."file2"...);

    # Extract the information from the profiles file
    profile_assembly=extractFixProfile(path_system,df,df."file3"...)

    return (system_assembly,stress_assembly,clust_assembly,profile_assembly)

end


function extractInfoShear(path_shear,df)
"""
    Function that reads the files and extract all the information
    file6 -> system_shear
    file7 -> stress_shear
    file8 -> clust_shear
    file9 -> profiles_shear
    file10 -> traj_shear
    file11 -> data.FirstShear
"""

    # Get the number of experiments done with the same shear
    path_shear=map(s->joinpath(path_shear,string("Exp",s)),1:df."Nexp"[1]);

    # Extract info from system system
    #map(s->,path_shear);
    #system_shear=map(s->DataFrame(s',headers),info);

    system_shear=map(path_shear) do s
        (headers,info)=extractFixScalar(s,df,df."file6"...);
        DataFrame(info',headers)
    end


    # Extract info from stress
    stress_shear=map(path_shear) do s
        (headers,info)=extractFixScalar(s,df,df."file7"...);
        DataFrame(info',headers)
    end

    # Extract info from the cluster files
    clust_shear=map(s->extractFixCluster(s,df,df."file8"...),path_shear);

    # Extract the information from the profiles file
    profile_shear=map(s->extractFixProfile(s,df,df."file9"...),path_shear)

    return (system_shear,stress_shear,clust_shear,profile_shear)

end


function plot_systemAssembly(time,df,title)
"""
    Function that create a figure with:
    - Temperature
    - Total Energy
    - Potential Energy
    - Kinetic Energy
"""

# Total Energy
p1 = plot(
            title=L"\mathrm{Total~Energy}",
            xlabel = L"\mathrm{Time~steps}~\log",
            ylabel = L"'J'",
            xscale=:log,
            framestyle=:box,
            legend=false
           )
plot!(time,df."v_eT")

p2 = plot(
            title=L"\mathrm{Temperature}",
            xlabel = L"\mathrm{Time~steps}~\log",
            ylabel = L"'K'",
            xscale=:log,
            framestyle=:box,
            legend=false
           )
plot!(time,df."c_t")

p3 = plot(
            title=L"\mathrm{Kinetic~Energy}",
            xlabel = L"\mathrm{Time~steps}~\log",
            ylabel = L"'J'",
            xscale=:log,
            framestyle=:box,
            legend=false
           )
plot!(time,df."c_ek")

p4 = plot(
            title=L"\mathrm{Potential~Energy}",
            xlabel = L"\mathrm{Time~steps}~\log",
            ylabel = L"'J'",
            xscale=:log,
            framestyle=:box,
            legend=false
           )
plot!(time,df."c_ep")

# Combo of all previous plots
fig_system=plot(p1,p2,p3,p4,
                layout = (2,2),
                suptitle = latexstring(string("\\mathrm{",title,"}")),
                plot_titlefontsize = 15,
                size=(1600,900),
                right_margin=10px,
                left_margin=30px,
                top_margin=10px,
                bottom_margin=15px
             )

    return fig_system
end

function plot_stressAssembly(time_shear,stress_assembly)
"""
    Graph of the stress during assembly
"""
p1 = plot(
            title=L"\mathrm{Stress~Norm}",
            xlabel = L"\mathrm{Time}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(time_shear,norm(stress_assembly."c_stress[1]",stress_assembly."c_stress[2]",stress_assembly."c_stress[3]",stress_assembly."c_stress[4]",stress_assembly."c_stress[5]",stress_assembly."c_stress[6]"))

p2 = plot(
            title=L"\mathrm{Stress}~\sigma_{xy}",
            xlabel = L"\mathrm{Time}",
            ylabel = L"\sigma",
            framestyle=:box,
            legend=false
           )
plot!(time_shear,stress_assembly."c_stress[4]")

p3 = plot(
            title=L"\mathrm{Virial~Stress~Norm}",
            xlabel = L"\mathrm{Time}",
            ylabel = L"\sigma",
            framestyle=:box,
            legend=false
           )
plot!(time_shear,norm(stress_assembly."c_stressVirial[1]",stress_assembly."c_stressVirial[2]",stress_assembly."c_stressVirial[3]",stress_assembly."c_stressVirial[4]",stress_assembly."c_stressVirial[5]",stress_assembly."c_stressVirial[6]"))

p4 = plot(
            title=L"\mathrm{Virial~Stress}~\sigma_{xy}",
            xlabel = L"\mathrm{Time}",
            ylabel = L"\sigma",
            framestyle=:box,
            legend=false
           )
plot!(time_shear,stress_assembly."c_stressVirial[4]")



# Combo of all previous plots
fig_stress=plot(p1,p2,p3,p4,
                layout = (2,2),
                suptitle = latexstring(string("\\mathrm{","Assembly~Stress~and~Virial~Stress","}")),
                plot_titlefontsize = 15,
                size=(1600,900),
                right_margin=10px,
                left_margin=30px,
                top_margin=10px,
                bottom_margin=15px
             )

    return fig_stress
end


function plot_systemShear(time,df,title)
"""
    Function that create a figure with:
    - Temperature
    - Total Energy
    - Potential Energy
    - Kinetic Energy
"""

# Total Energy
p1 = plot(
            title=L"\mathrm{Total~Energy}",
            xlabel = L"\mathrm{Time~steps}~\log",
            ylabel = L"'J'",
            xscale=:log,
            framestyle=:box,
            legend=false
           )
plot!(time,df."v_eT")

p2 = plot(
            title=L"\mathrm{Temperature}",
            xlabel = L"\mathrm{Time~steps}~\log",
            ylabel = L"'K'",
            xscale=:log,
            framestyle=:box,
            legend=false
           )
plot!(time,df."c_td")

p3 = plot(
            title=L"\mathrm{Kinetic~Energy}",
            xlabel = L"\mathrm{Time~steps}~\log",
            ylabel = L"'J'",
            xscale=:log,
            framestyle=:box,
            legend=false
           )
plot!(time,df."c_ek")

p4 = plot(
            title=L"\mathrm{Potential~Energy}",
            xlabel = L"\mathrm{Time~steps}~\log",
            ylabel = L"'J'",
            xscale=:log,
            framestyle=:box,
            legend=false
           )
plot!(time,df."c_ep")

# Combo of all previous plots
fig_system=plot(p1,p2,p3,p4,
                layout = (2,2),
                suptitle = latexstring(string("\\mathrm{",title,"}")),
                plot_titlefontsize = 15,
                size=(1600,900),
                right_margin=10px,
                left_margin=30px,
                top_margin=10px,
                bottom_margin=15px
             )

    return fig_system
end



#=
"""
    Plots
"""
default(fontfamily = "times", fontsize = 18)

# Temporal domains
time_shear=shear_dat."time-step".*system_shear."TimeStep";
time_shear_stress=shear_dat."time-step".*system_shear."TimeStep";


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


# Algebraic manipulation to get the stress
(norm_press_ass,norm_press_she,norm_virialpress_ass,norm_virialpress_she,norm_virialModpress_ass,norm_virialModpress_she,norm_stress_ass,norm_stress_she,norm_virialstress_ass,norm_virialstress_she,norm_virialModstress_ass,norm_virialModstress_she)=normStressPressure(df_stressA,df_stressS);




=#


