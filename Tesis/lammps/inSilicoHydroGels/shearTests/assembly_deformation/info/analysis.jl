"""
    Script to retrieve the information from the simualations

    vorHisto_assembly: Number of edges on the faces of the Voronoi cell
    voronoiSimple_assembly: Volume, Number of faces per atom. 
"""

using Distributions
using GLMakie

include("functions.jl")

# Parameters
N_sim = 1;
pwdDir = "/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/shearTests/assembly_deformation/info/";
workdir = cd(pwdDir);

assemblyFiles_names = ("patchyParticles_assembly.dumpf", "newdata_assembly.dumpf", "voronoiSimple_assembly.dumpf", "vorHisto_assembly.fixf", "energy_assembly.fixf", "sizeCluster_assembly.fixf");
shearFiles_names = ("patchyParticles_shear.dumpf", "newdata_shear.dumpf", "voronoiSimple_shear.dumpf", "vorHisto_shear.fixf", "energy_shear.fixf", "sizeCluster_shear.fixf","stress_shear.fixf");

files = (assemblyFiles_names,shearFiles_names);

## Get the info

# Energy
data_energy = map(s->getInfoEnergy(pwdDir*s[5]),files);

# Clusters
data_clusters = map(s->getInfoCluster(pwdDir*s[6]),files);
aux_clusters = reduce(vcat,(100).*(data_clusters./sum.(data_clusters)));
#clusters_stuff = (mean(aux_clusters),std(aux_clusters));
println(aux_clusters)

# Voronoi stuff
data_voroSimple = map(s->getInfoVoroSimple(pwdDir*s[3]),files);
volume_voroSimple = reduce(hcat,map(s->s[1,:],data_voroSimple));
Nfaces_voroSimple = reduce(hcat,map(s->s[2,:],data_voroSimple));

data_voroHisto = map(s->getInfoVoroHisto(pwdDir*s[4]),files);
aux_edges = reduce(hcat,map(s->data_voroHisto[s][:,2],eachindex(data_voroHisto)));
voroHisto_mean = reduce(vcat,mean(aux_edges,dims=2));

# Stress
stress_info = getInfoStress(pwdDir*shearFiles_names[end]);

## Figures

# Energy and temperature
ta_step = data_energy[1][1,:];
T_assembly = data_energy[1][2,:];
U_assembly = data_energy[1][3,:];
K_assembly = data_energy[1][4,:];
E_assembly = U_assembly .+ K_assembly;

ts_step = last(data_energy[1][1,:]) .+ data_energy[2][1,:];
T_shear = data_energy[2][2,:];
U_shear = data_energy[2][3,:];
K_shear = data_energy[2][4,:];
E_shear = U_shear .+ K_shear;

tf = last(data_energy[1][1,:]) + last(data_energy[2][1,:]);

fig_Energy = Figure()
ax_e = Axis(fig_Energy[1,1],
        title = "Energy",
        xlabel = "Time steps [Log10]",
        ylabel = "Energy",
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
ax_t = Axis(fig_Energy[1,3],
        title = "Temperature",
        xlabel = "Time steps [Log10]",
        ylabel = "Energy",
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

    lines!(ax_e,ta_step,U_assembly,label="U_a", color = Makie.wong_colors()[1])
    lines!(ax_e,ta_step,K_assembly,label="K_a", color = Makie.wong_colors()[2])
    lines!(ax_e,ta_step,E_assembly,label="Tot_a", color = Makie.wong_colors()[3])
    lines!(ax_t,ta_step,T_assembly,label="T_a",color = Makie.wong_colors()[1])

    lines!(ax_e,ts_step,U_shear,label="U_s", color = Makie.wong_colors()[4])
    lines!(ax_e,ts_step,K_shear,label="K_s", color = Makie.wong_colors()[5])
    lines!(ax_e,ts_step,E_shear,label="Tot_s", color = Makie.wong_colors()[6])
    lines!(ax_t,ts_step,T_shear,label="T_s",color = Makie.wong_colors()[7])

fig_Energy[1,2] = Legend(fig_Energy,ax_e,"Legends",framevisible=true)
fig_Energy[1,4] = Legend(fig_Energy,ax_t,"Legends",framevisible=true)

# Stress stuff
labels_stress = ("trace","xx","yy","zz","xy","xz","yz");
fig_Stress = Figure();
ax_s = Axis(fig_Stress[1,1],
        title = "Stress components",
        xlabel = "Time steps",
        ylabel = L"\sigma_{nn}",
        titlesize = 24.0f0,
        xticklabelsize = 18.0f0,
        yticklabelsize = 18.0f0,
        xlabelsize = 20.0f0,
        ylabelsize = 20.0f0,
        xminorticksvisible = true, 
        xminorgridvisible = true,
        xminorticks = IntervalsBetween(5),
        xscale = log10,
        limits = (10e0,exp10(1+round(log10( stress_info[1,end] ))),nothing,nothing)
    )

    map(s->lines!(ax_s,stress_info[1,:],stress_info[s,:],label=labels_stress[s],color=Makie.wong_colors()[s]),2:length(labels_stress))
    lines!(ax_s,stress_info[1,:],reduce(vcat,sum(stress_info[2:4,:],dims=1)),label=labels_stress[1],color=Makie.wong_colors()[1])

fig_Stress[1,2] = Legend(fig_Stress,ax_s,"Legends",framevisible=true)

# Voronoi Stuff
labels_volume = ("Assembly","Shear");
bins_volume = 15;
fig_Voronoi = Figure();
ax_vol = Axis(fig_Voronoi[1,1],
                title = "Volume distribution per atom",
                xlabel = "Volume",
                ylabel = "Counts"
            )
ax_Nfac = Axis(fig_Voronoi[2,1],
                title = "Number of faces per atom",
                xlabel = "Number of faces",
                ylabel = "Counts"
            )
ax_edges = Axis(fig_Voronoi[3,1],
                title = "Number of edges per face",
                xlabel = "Number of edges",
                ylabel = "Counts"
            )


map(s->hist!(ax_vol,volume_voroSimple[:,s],bins=bins_volume,label=labels_volume[s],color=(Makie.wong_colors()[rand(1:7,1)[1]],0.25),strokewidth=0.5,strokecolor=(:black,0.25),normalization=:density),eachindex(volume_voroSimple[1,:]))
map(s->hist!(ax_Nfac,Nfaces_voroSimple[:,s],bins=bins_volume,label=labels_volume[s],color=(Makie.wong_colors()[rand(1:7,1)[1]],0.25),strokewidth=0.5,strokecolor=(:black,0.25),normalization=:density),eachindex(Nfaces_voroSimple[1,:]))
map(s->barplot!(ax_edges,eachindex(voroHisto_mean),aux_edges[:,s],label=labels_volume[s],color=(Makie.wong_colors()[rand(1:7,1)[1]],0.25)),eachindex(aux_edges[1,:]))

fig_Voronoi[1,2] = Legend(fig_Voronoi,ax_vol,"Legends",framevisible=true)
fig_Voronoi[2,2] = Legend(fig_Voronoi,ax_Nfac,"Legends",framevisible=true)
fig_Voronoi[3,2] = Legend(fig_Voronoi,ax_edges,"Legends",framevisible=true)


