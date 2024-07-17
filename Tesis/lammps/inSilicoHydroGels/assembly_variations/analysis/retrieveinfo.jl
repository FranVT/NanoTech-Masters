"""
    Script to retrieve the information from the simualations

    vorHisto_assembly: Number of edges on the faces of the Voronoi cell
    voronoiSimple_assembly: Volume, Number of faces per atom. 
"""

using Distributions
using GLMakie

include("functions.jl")

# Parameters
N_sim = 50;
pwdDir = "/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/assembly_variations/";
workdir = cd(pwdDir);

files_names = ("patchyParticles_assembly.dumpf", "newdata_assembly.dumpf", "voronoiSimple_assembly.dumpf", "vorHisto_assembly.fixf", "energy_assembly.fixf", "sizeCluster_assembly.fixf");

dir_names = map(s->string("info/sim",s,"/"),1:N_sim);


## Get the info

# Clusters
data_clusters = map(s->getInfoCluster(pwdDir*s*files_names[6]),dir_names);
aux_clusters = reduce(vcat,(100).*(data_clusters./sum.(data_clusters)));
clusters_stuff = (mean(aux_clusters),std(aux_clusters));
println(clusters_stuff)

# Voronoi stuff
data_voroSimple = map(s->getInfoVoroSimple(pwdDir*s*files_names[3]),dir_names);
volume_voroSimple = reduce(hcat,map(s->s[1,:],data_voroSimple));
Nfaces_voroSimple = reduce(hcat,map(s->s[2,:],data_voroSimple));

data_voroHisto = map(s->getInfoVoroHisto(pwdDir*s*files_names[4]),dir_names);
aux_edges = reduce(hcat,map(s->data_voroHisto[s][:,2],eachindex(data_voroHisto)));
voroHisto_mean = reduce(vcat,mean(aux_edges,dims=2));

## Figures

# Voronoi Stuff
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

map(s->hist!(ax_vol,volume_voroSimple[:,s],bins = bins_volume,color=(Makie.wong_colors()[rand(1:7,1)[1]],0.5),strokewidth=0.5,strokecolor=(:black,0.05),normalization=:density),eachindex(volume_voroSimple[1,:]))
map(s->hist!(ax_Nfac,Nfaces_voroSimple[:,s],bins = bins_volume,color=(Makie.wong_colors()[rand(1:7,1)[1]],0.5),strokewidth=0.5,strokecolor=(:black,0.05),normalization=:density),eachindex(Nfaces_voroSimple[1,:]))
map(s->barplot!(ax_edges,eachindex(voroHisto_mean),aux_edges[:,s],color=(Makie.wong_colors()[rand(1:7,1)[1]],0.5)),eachindex(aux_edges[1,:]))
