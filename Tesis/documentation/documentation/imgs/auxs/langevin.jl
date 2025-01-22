"""
    Script to see the relations of friction and viscouse force sin langevin thermostat.
"""

using GLMakie

kB=1;
T=0.05;
dt=0.001;

## Create the ranges
m=range(0.5,10,length=25);
damp=range(0.001,1,length=1000);

## Evaluation of the terms 
#Ff=-m./damp;
#Fr=sqrt.((kB*T.*m)./(dt.*damp));

Ff_hm=map(sm->map(sd->-sm/sd,damp),m);
Fr_hm=map(sm->map(sd->sqrt.((kB*T.*sm)./(dt.*sd)),damp),m);


## Figures
figLangHM=Figure(size=(1920,1080))
axLanghm=Axis(figLangHM[1,1:2],
               title=L"\mathrm{Langevin~m/damp}",
               xlabel=L"\mathrm{damp}",
               ylabel=L"\mathrm{mass}",
               #limits=(first(m),last(m),nothing,nothing),
               titlesize = 24.0f0,
               xticklabelsize = 18.0f0,
               yticklabelsize = 18.0f0,
               xlabelsize = 20.0f0,
               ylabelsize = 20.0f0,
               xminorticksvisible = true, 
               xminorgridvisible = true
              )
hm=heatmap!(axLanghm,damp,m,reduce(hcat,Ff_hm))
Colorbar(figLangHM[:, end+1], hm)

figLang=Figure(size=(1920,1080))

axLang_m = Axis(figLang[1,1:2],
               title=L"\mathrm{Langevin~thermostat}",
               xlabel=L"\mathrm{mass}",
               ylabel=L"F",
               limits=(first(m),last(m),nothing,nothing),
               titlesize = 24.0f0,
               xticklabelsize = 18.0f0,
               yticklabelsize = 18.0f0,
               xlabelsize = 20.0f0,
               ylabelsize = 20.0f0,
               xminorticksvisible = true, 
               xminorgridvisible = true
              )
lines!(axLang_m,m,Ff,label=L"F_f")
lines!(axLang_m,m,Fr,label=L"F_r")

axislegend(axLang_m,position=:rt)

axLang_d = Axis(figLang[2,1:2],
               title=L"\mathrm{Langevin~thermostat}",
               xlabel=L"\mathrm{damp}",
               ylabel=L"F",
               limits=(first(damp),last(damp),nothing,nothing),
               titlesize = 24.0f0,
               xticklabelsize = 18.0f0,
               yticklabelsize = 18.0f0,
               xlabelsize = 20.0f0,
               ylabelsize = 20.0f0,
               xminorticksvisible = true, 
               xminorgridvisible = true
              )
lines!(axLang_d,damp,Ff,label=L"F_f")
lines!(axLang_d,damp,Fr,label=L"F_r")

axislegend(axLang_d,position=:rt)

axLang = Axis(figLang[1,3:4],
               title=L"\mathrm{Langevin~thermostat}",
               xlabel=L"F_f",
               ylabel=L"F_r",
               limits=(first(Ff),last(Ff),nothing,nothing),
               titlesize = 24.0f0,
               xticklabelsize = 18.0f0,
               yticklabelsize = 18.0f0,
               xlabelsize = 20.0f0,
               ylabelsize = 20.0f0,
               xminorticksvisible = true, 
               xminorgridvisible = true
              )
lines!(axLang,Ff,Fr,label=L"F_f")

axLangT = Axis(figLang[2,3:4],
               title=L"\mathrm{Langevin~thermostat}",
               xlabel=L"F_f",
               ylabel=L"F_r",
               limits=(nothing,nothing,nothing,nothing),
               titlesize = 24.0f0,
               xticklabelsize = 18.0f0,
               yticklabelsize = 18.0f0,
               xlabelsize = 20.0f0,
               ylabelsize = 20.0f0,
               xminorticksvisible = true, 
               xminorgridvisible = true
              )
lines!(axLangT,Ff.+Fr,label=L"F_f")

