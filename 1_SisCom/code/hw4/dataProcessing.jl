
using CSV, DataFrames
using  Plots, LaTeXStrings

Temp = CSV.read("temperature.csv", DataFrame; header=2,delim=" ")
eP = CSV.read("potential.csv", DataFrame; header=2,delim=" ")
eK = CSV.read("kinetic.csv", DataFrame; header=2,delim=" ")

TempD = CSV.read("temperatureDihedral.csv", DataFrame; header=2,delim=" ")
ePD = CSV.read("potentialDihedral.csv", DataFrame; header=2,delim=" ")
eKD = CSV.read("kineticDihedral.csv", DataFrame; header=2,delim=" ")

nt = Temp[!,1];
T = Temp[!,2];
U = eP[!,2];
K = eK[!,2];

ntD = TempD[!,1];
TD = TempD[!,2];
UD = ePD[!,2];
KD = eKD[!,2];

gTemp = plot(
    title = L"\mathrm{Temperature}",
    titlelocation = :center,
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    xlabel = L"\mathrm{Nt}", ylabel = L"T",
    size = (480,480),
    #aspect_ratio = 1,
    formatter = :plain,
    minorgrid = true,
    minorgridalpha = 0.5,
    gridalpha = 0.5,
    framestyle = :box
)

plot!(gTemp,nt,T,label = L"\mathrm{Temperature~Angles}")
plot!(gTemp,ntD,TD,label = L"\mathrm{Temperature~Dihedral}")

savefig(gTemp,"temperatureComparison.pdf")

pE = plot(
    title = L"\mathrm{Energy}",
    titlelocation = :center,
    titlefontsize = 12, tickfontsize = 8, labelfontsize = 13,
    xlabel = L"\mathrm{Nt}", ylabel = L"K,U,E_{T}",
    size = (480,480),
    #aspect_ratio = 1,
    formatter = :plain,
    minorgrid = true,
    minorgridalpha = 0.5,
    gridalpha = 0.5,
    framestyle = :box,
    legend_position=:topleft
)

plot!(pE,nt,U,label=L"U_\mathrm{Angle}")
plot!(pE,nt,K,label=L"K_\mathrm{Angle}")
plot!(pE,nt,U+K,label=L"U+K_\mathrm{Angle}")

plot!(pE,ntD,UD,label=L"U_\mathrm{Dihedral}")
plot!(pE,ntD,KD,label=L"K_\mathrm{Dihedral}")
plot!(pE,ntD,UD+KD,label=L"U+K_\mathrm{Dihedral}")


savefig(pE,"energyComparison.pdf")
