"""
    Assigment 6 - Monte Carlo Methods

    Use a Monte-Caro algorithm to approximate the value of pi.
    Plot the error in this approximation as the number of random samples is increased from 10 to 10e6.
"""

using Random, Distributions
using Plots, LaTeXStrings

# Set the backend from graphs
gr()

# Set the seed
Random.seed!(4321)

function estimatePiMC(r,Ns)
    # Set parameters
    """
        r:      Radius of the circle
        Ns:     Number of samples
        srng:     Sample range 
        spdf:   Sample probability function
    """
    srng  = round.(Int,range(start=10,stop=1e6,length=Ns));
    spdf = Uniform(-r,r);

    # Evaluate the random varaibles
    X = map(s->rand(spdf,s),srng);
    Y = map(s->rand(spdf,s),srng);

    # Take the radius
    R = map(s->(X[s].^2 .+ Y[s].^2),1:1:Ns);

    # Get the estimated value of pi
    return (map(s->sum(R[s].<=r.^2)/srng[s],1:1:Ns ).*4, srng) 

end

r = 0.5;
Ns = 2^8;
#info = estimatePiMC(r,Ns);

# Get the error
rpi = round(pi;digits=12);
re = abs.(rpi.-round.(info[1];digits=12))/rpi;

# Plot of the error
ge = plot(
          title = L"\mathrm{Relative~error}",
          xlabel = L"N_s:\mathrm{Number~of~samples}",
          ylabel = L"\mathrm{Relative~error}",
          xlim = (info[2][1],info[2][end]),
          ylim = (0,maximum(re)),
          size = (480,480),
          #aspect_ratio = 1/1,
          formatter = :plain,
          framestyle = :box,
          minorgrid = true,
          minorgridalpha = 0.25,
          gridalpha = 0.5
         )
plot!(ge,info[2],re,label = false)
scatter!(ge,info[2],re,label=false,markersize=1.5,markercolor=:black)

savefig(ge,"relativeError.pdf")

# Plot the estimation
gp = plot()
plot!(gp,Pi)


