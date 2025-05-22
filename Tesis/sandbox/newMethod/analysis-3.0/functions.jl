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

    Nexp=df."Nexp";
    # Get the number of experiments done with the same shear
    path_shear=map(s->joinpath(path_shear,string("Exp",s)),1:first(Nexp));

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
    #clust_shear=map(s->extractFixCluster(s,df,df."file8"...),path_shear);

    # Extract the information from the profiles file
    #profile_shear=map(s->extractFixProfile(s,df,df."file9"...),path_shear)


    # Compute the averages of the Nexperiments
    system_shear=reduce(.+,system_shear)./Nexp
    stress_shear=reduce(.+,stress_shear)./Nexp


    return (system_shear,stress_shear) #,clust_shear,profile_shear)

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


function plotsAssembly(id,path,assembly_dat,system_assembly,stress_assembly)
"""
    Function that creates the assembly plots and store them in a given directory.
"""

    # Time domains
    time_system_assembly=assembly_dat."save-fix".*assembly_dat."time-step".*system_assembly."TimeStep";
    time_shear_assembly=assembly_dat."time-step".*stress_assembly."TimeStep";

    # Total energy, temperature, potential and kinetic energy
    fig_system_assembly=plot_systemAssembly(time_system_assembly,system_assembly,"Assembly");

    # Stress stuff
    fig_stress_assembly=plot_stressAssembly(time_shear_assembly,stress_assembly)

    # Save the figures
    savefig(fig_system_assembly,joinpath(path,string(id,"-system_assembly.png")))
    savefig(fig_stress_assembly,joinpath(path,string(id,"-stress_assembly.png")))

    println("Assembly figures stored")

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

function plot_stressShearComp(stress_shear,cycle,strain,title)
"""
    Compare the full Stress with the virial Stress
"""


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

p1 = plot(
              title=L"\sigma_{xy}~\mathrm{all}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,xy[cycle])

p2 = plot(
            title=L"\sigma_{xy}~\mathrm{virial}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,xy_virial[cycle])

p3 = plot(
            title=L"\mathrm{Stress~Norm}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,norm_stress[cycle])

p4 = plot(
            title=L"\mathrm{Stress~Norm~Virial}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,norm_stressVirial[cycle])

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

function plot_pressShearComp(stress_shear,cycle,strain,title)
"""
    Compare the full pressure with the virial pressure
"""

xx=stress_shear."c_press[1]";
yy=stress_shear."c_press[2]";
zz=stress_shear."c_press[3]";
xy=stress_shear."c_press[4]";
xz=stress_shear."c_press[5]";
yz=stress_shear."c_press[6]";

norm_stress=norm(xx,yy,zz,xy,xz,yz);

xx_virial=stress_shear."c_pressVirial[1]";
yy_virial=stress_shear."c_pressVirial[2]";
zz_virial=stress_shear."c_pressVirial[3]";
xy_virial=stress_shear."c_pressVirial[4]";
xz_virial=stress_shear."c_pressVirial[5]";
yz_virial=stress_shear."c_pressVirial[6]";

norm_stressVirial=norm(xx_virial,yy_virial,zz_virial,xy_virial,xz_virial,yz_virial);

p1 = plot(
              title=L"\sigma_{xy}~\mathrm{all}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,xy[cycle])

p2 = plot(
            title=L"\sigma_{xy}~\mathrm{virial}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,xy_virial[cycle])

p3 = plot(
            title=L"\mathrm{Press~Norm}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,norm_stress[cycle])

p4 = plot(
            title=L"\mathrm{Press~Norm~Virial}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,norm_stressVirial[cycle])

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


function plot_stress_pressShear(L,stress_shear,cycle,strain,title)
"""
    Compare the stress and pressure 
"""

xx=stress_shear."c_stress[1]";
yy=stress_shear."c_stress[2]";
zz=stress_shear."c_stress[3]";
xy=stress_shear."c_stress[4]";
xz=stress_shear."c_stress[5]";
yz=stress_shear."c_stress[6]";

trace_stress=-trace(xx,yy,zz);

xx_virial=stress_shear."c_stressVirial[1]";
yy_virial=stress_shear."c_stressVirial[2]";
zz_virial=stress_shear."c_stressVirial[3]";
xy_virial=stress_shear."c_stressVirial[4]";
xz_virial=stress_shear."c_stressVirial[5]";
yz_virial=stress_shear."c_stressVirial[6]";

trace_stressVirial=-trace(xx,yy,zz);

xx=stress_shear."c_press[1]";
yy=stress_shear."c_press[2]";
zz=stress_shear."c_press[3]";
xy=stress_shear."c_press[4]";
xz=stress_shear."c_press[5]";
yz=stress_shear."c_press[6]";

norm_press=norm(xx,yy,zz,xy,xz,yz);

xx_virial=stress_shear."c_pressVirial[1]";
yy_virial=stress_shear."c_pressVirial[2]";
zz_virial=stress_shear."c_pressVirial[3]";
xy_virial=stress_shear."c_pressVirial[4]";
xz_virial=stress_shear."c_pressVirial[5]";
yz_virial=stress_shear."c_pressVirial[6]";

norm_pressVirial=norm(xx,yy,zz,xy,xz,yz);

p1 = plot(
            title=L"\mathrm{Pressure}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
#plot!(strain,norm_press[cycle])
plot!(strain,stress_shear."c_p")

p2 = plot(
            title=L"-\frac{1}{3V}\mathrm{Tr}(\sigma)~\mathrm{atom}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,trace_stress[cycle]./(3*L^3))

p3 = plot(
            title=L"\mathrm{Virial~Pressure}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,norm_pressVirial[cycle])

p4 = plot(
          title=L"-\frac{1}{3V}\mathrm{Tr}(\sigma)~\mathrm{Virial~atom}",
            xlabel = L"\mathrm{Strain}",
            ylabel = L"\sigma",
            legend=false,
            framestyle=:box
           )
plot!(strain,trace_stressVirial[cycle]./(3*L^3))

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

function plotsShear(id,path,L,shear_dat,system_shear,stress_shear)
"""
    Holap
"""

    # Time domain
    #to=first(system_shear."TimeStep")+1; 
    time_system_shear=shear_dat."save-fix".*shear_dat."time-step".*system_shear."TimeStep"

    # Strain domain

    # Indixes for the shear moments
    aux=shear_dat."time-step".*shear_dat."Shear-rate".*shear_dat."save-stress";
    # Time steps per set of deformations
    N_deform=shear_dat."Max-strain".*shear_dat."N_def";
    # Time steps stored due to time average/Total of index per deformation cycle
    ind_cycle=div.(N_deform,shear_dat."save-stress",RoundDown);

    cycle=(1:1:length(stress_shear."TimeStep"));


    # Create strain and time domains
    strain=aux[1].*cycle;

    # Total energy, temperature, potential and kinetic energy
    fig_system_shear=plot_systemShear(time_system_shear,system_shear,"Shear")

    # Stress stuff
    fig_stress_atom_shear=plot_stressShearComp(stress_shear,cycle,strain,"Stress~Atom")
       
    fig_pressure_shear=plot_pressShearComp(stress_shear,cycle,strain,"Pressure")

    fig_comp_stress_press=plot_stress_pressShear(L,stress_shear,cycle,strain,"Comparation~of~compute~pressure~with~compute~stress-atom")

    # Save the figures
    savefig(fig_system_shear,joinpath(path,string(id,"-system_shear-rate",shear_dat."Shear-rate"...,".png")))
    savefig(fig_stress_atom_shear,joinpath(path,string(id,"-stressAtomShear_shear-rate",shear_dat."Shear-rate"...,".png")))
    savefig(fig_pressure_shear,joinpath(path,string(id,"-pressureShear_shear-rate",shear_dat."Shear-rate"...,".png")))
    savefig(fig_comp_stress_press,joinpath(path,string(id,"-compStressPress_shear-rate",shear_dat."Shear-rate"...,".png")))

    println("Shear figures stored")

end





#=
"""
    Plots
"""
default(fontfamily = "times", fontsize = 18)

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


