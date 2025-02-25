"""
    Script that create the plots
"""

# Packages
using Distributions
using Plots, LaTeXStrings
using FileIO, JLD 

# Path to acces the information
path = "/home/Fran/gitRepos/NanoTech-Masters/1_SisCom/data/data_hk6_4";

# Auxiliary functions
function retrieveInfo(ϕ)
"""
    Function that retrieve the information of the Poisson Process
"""

    # Memory allocation
    j_pa = zeros(values[3],values[4]);
    j_na = zeros(values[3],values[4]);
    ja = zeros(values[3],values[4]);

    for it ∈ 1:values[4]
        # Load the currents
        j_1= load(string(path,"/",Int(ϕ*10000),"j_p",it,".jld"),"j_p");
        j_2 = load(string(path,"/",Int(ϕ*10000),"j_n",it,".jld"),"j_n");

        # Data manipulation
        j_pa[:,it] = j_1./parms[1];
        j_na[:,it] = j_2./parms[1];
        ja[:,it] = j_pa[:,it] .- j_na[:,it];
    end

    return (j_pa,j_na,ja)

end

function allData()
"""
    Get the data set of all the simulations
"""
    # Packing fraction 
    ϕ = 1/80:1/80:1;

    # Memory allocation
    j_pp = zeros(values[3],length(ϕ));
    j_pn = zeros(values[3],length(ϕ));
    j_p = zeros(values[3],length(ϕ));

    # Retrieve function
    for itp = 1:length(ϕ) 
        (j_pa,j_na,ja) = retrieveInfo(ϕ[itp]);
        
        j_pp[:,itp] = mean(cumsum(j_pa,dims=1),dims=2);
        j_pn[:,itp] = mean(cumsum(j_na,dims=1),dims=2);
        j_p[:,itp] = mean(cumsum(ja,dims=1),dims=2);
    end

    return (ϕ,j_pp,j_pn,j_p)
end


# Load the parameters
parms = load(string(path,"/",Int(1/80*10000),"parameters.jld"),"parms");
values = load(string(path,"/",Int(1/80*10000),"values.jld"),"values");

#(ϕ,j_p,j_n,j) = allData();

#"""
# Plots 
g = plot(
         #title = L"\mathrm{Current~vs~packing~fraction}",
         xlabel = L"ϕ:~\mathrm{Packing~fraction}",
         ylabel = L"j:~\mathrm{Current}",
         xlims = (0,1),
         ylims = (0,1),
         size = (480,480),
         aspect_ratio = 1/1,
         formatter = :plain,
         framestyle = :box,
         minorgrid = true,
         gridalpha = 0.5,
         minorgridalpha = 0.25,
         legend_position = :top,
         legend_column = 3
        );
plot!(g,collect(ϕ),(parms[4]).*ϕ.*((1).-ϕ),linewidth=1.5,label=L"j_+(\phi)" )
plot!(g,collect(ϕ),(parms[5]).*ϕ.*((1).-ϕ),linewidth=1.5,label=L"j_-(\phi)")
plot!(g,collect(ϕ),(parms[4]-parms[5]).*ϕ.*((1).-ϕ),linewidth=1.5,label=L"j_t(\phi)" )
scatter!(g,collect(ϕ),j_p[end,:]/5,markersize = 2.5,markeralpha = 0.6,label=L"j_+")
scatter!(g,collect(ϕ),j_n[end,:]/5,markersize = 2.5,markeralpha = 0.6,label=L"j_-")
scatter!(g,collect(ϕ),j[end,:]/5,markersize = 2.5,markeralpha = 0.6,label=L"j_t")

savefig(g,"current_packingfraction.pdf")

#j[end,:]./((parms[4]-parms[5]).*ϕ.*((1).-ϕ))
#"""

# Plots 
#plot(values[2]*collect(1:values[3]),j_p)
#plot!(values[2]*collect(1:values[3]),j_n)
#plot!(values[2]*collect(1:values[3]),j)
