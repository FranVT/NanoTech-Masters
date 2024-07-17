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
N_clusters = length.(data_clusters);
aux_cluster = data_clusters/sum(data_clusters,dims=2);
Maxsize_clusters = maximum.(data_clusters);
Minsize_clusters = minimum.(data_clusters);
clusters_stuff = (mean(Maxsize_clusters),mean(Minsize_clusters),mean(Maxsize_clusters./sum(data_clusters[1])));


# Voronoi stuff
data_voroSimple = map(s->getInfoVoroSimple(pwdDir*s*files_names[3]),dir_names);
volume_voroSimple = reduce(hcat,map(s->s[1,:],data_voroSimple));
Nfaces_voroSimple = reduce(hcat,map(s->s[2,:],data_voroSimple));

data_voroHisto = map(s->getInfoVoroHisto(pwdDir*s*files_names[4]),dir_names);
voroHisto_mean = mean(reduce(hcat,map(s->data_voroHisto[s][:,2],eachindex(data_voroHisto))),dims=2)

## Figures
"""
# Clusters
bins_clusters = 100;
fig_Clusters = Figure();
ax_Clusters = Axis(fig_Clusters[1,1], 
                    title = "Number of clusters"
                )

hist(fig_Clusters[1,1],N_clusters,bins = bins_clusters,
    strokewidth = 0.5,
    strokecolor = :black,
    color = :values
    )
hist(fig_Clusters[1,2],Maxsize_clusters,bins = bins_clusters,
    strokewidth = 0.5,
    strokecolor = :black,
    color = :values
    )

# Voronoi Stuff
"""


