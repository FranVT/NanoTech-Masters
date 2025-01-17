"""
   Statistical analysisi and graph
"""

using FileIO
using GLMakie
using LaTeXStrings
using Statistics

# Add functions to acces infromation from files
include("functions.jl")

"""
    Select the desire systems to analyse
"""

selc_phi="2500";
selc_Npart="1000";
selc_damp="5000";
selc_T="500";
selc_cCL="2000";
selc_ShearRate="1000";#string.((10,50,100));
selc_Nexp="1";#string.(1:15);

dirs=getDirs(selc_phi,selc_Npart,selc_damp,selc_T,selc_cCL,selc_ShearRate,selc_Nexp);

files_names = (
               "parameters",
               "system_assembly.fixf",
               "wca_assembly.fixf",
               "patch_assembly.fixf",
               "swap_assembly.fixf",
               "virialStress_assembly.fixf",
               "cmdisplacement_assembly.fixf",
               "system_shear.fixf",
               "wcaPair_shear.fixf",
               "patchPair_shear.fixf",
               "swapPair_shear.fixf",
               "stressVirial_shear.fixf",
               "cmdisplacement_shear.fixf",
              );


# Get the parameters of the system

file_dir=joinpath(first(dirs),first(files_names));
parameters=open(file_dir) do f
    map(s->parse(Float64,s),readlines(f))
end

parameters=(
     phi=parameters[1],
     Npart=parameters[2],
     Ncl=parameters[3],
     Nmo=parameters[4],
     Ccl=parameters[5],
     Vol=parameters[6],
     L=2*parameters[7],
     T=parameters[8],
     damp=parameters[9],
     dt_ass=parameters[10],
     N_heat=parameters[11],
     N_iso=parameters[12],
     N_savedump=parameters[13],
     N_savefix=parameters[14],
     dt_shear=parameters[15],
     shearRate=parameters[16],
     Ncycles=parameters[17],
     N_deform=parameters[18],
     N_rlx1=parameters[19],
     N_rlx2=parameters[20],
     N_rlx3=parameters[21],
     N_savestress=parameters[24]
    )



# The system energy and stuff are means of N experiments of the same system.

  
# Files per fix files per experiment
file_dir=map(s->reduce(vcat,map(r->joinpath(r,"info",s),dirs)),files_names[2:end]);

# Retrieve the information of the system

(inds,info,lbl)=getDataSystem(parameters,file_dir);

# Total Energy
fig_energy=Figure(size=(1920,1080));
ax_leg=Axis(fig_energy[1:3,3],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_full=Axis(fig_energy[1,1:2],
               title=L"\mathrm{Total~Energy~of~Full~simulation}",
               xlabel=L"\mathrm{Time~steps~}\log_{10}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               xscale=log10
              )
ax_assembly=Axis(fig_energy[2,1:2],
               title=L"\mathrm{Total~Energy~of~Assembly~simulation}",
               xlabel=L"\mathrm{Time~steps~}\log_{10}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               xscale=log10
              )
ax_shear=Axis(fig_energy[3,1:2],
               title=L"\mathrm{Total~Energy~of~Shear~simulation}",
               xlabel=L"\mathrm{Time~steps~}\log_{10}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true,
               xscale=log10
              )

#vspan!(ax_full,0,last(inds.heat),ymin=-100000,ymax=0,alpha=0.5)
lines!(ax_full,info.energy)
vlines!(ax_full,last(inds.heat),color=:black,linestyle=:dash)
vlines!(ax_full,last(inds.isothermal),color=:orange,linestyle=:dash)

lines!(ax_assembly,info.energy[inds.assembly])
vlines!(ax_assembly,last(inds.heat),color=:black,linestyle=:dash)

lines!(ax_shear,inds.shear,info.energy[inds.shear])
vlines!(ax_shear,first(inds.rlx1),color=:black,linestyle=:dash)
vlines!(ax_shear,first(inds.rlx2),color=:black,linestyle=:dash)
vlines!(ax_shear,first(inds.rlx3),color=:black,linestyle=:dash)
vlines!(ax_shear,first(inds.rlx4),color=:black,linestyle=:dash)
vlines!(ax_shear,first(inds.deform1),color=:blue,linestyle=:dash)
vlines!(ax_shear,first(inds.deform2),color=:blue,linestyle=:dash)
vlines!(ax_shear,first(inds.deform3),color=:blue,linestyle=:dash)
vlines!(ax_shear,first(inds.deform4),color=:blue,linestyle=:dash)

lines!(ax_leg,0,0,label=latexstring("\\dot{\\gamma}:~",lbl.shearRate,"~%\\mathrm{CL}:~",100*lbl.clCon))

Legend(fig_energy[1:3,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )


# Potential Energy
fig_potential=Figure(size=(1920,1080));
ax_leg=Axis(fig_potential[1:2,3],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_wca=Axis(fig_potential[1,1:2],
               title=L"\mathrm{WCA~Energy~of~isothermal~and~shear~simulation}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_patch=Axis(fig_potential[2,1:2],
               title=L"\mathrm{Patch~Energy~of~isothermal~and~shear~simulation}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true              
              )
ax_swap=Axis(fig_potential[3,1:2],
               title=L"\mathrm{Swap~Energy~of~isothermal~and~shear~simulation}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Energy}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )

dom=reduce(vcat,[inds.isothermal,inds.shear]);

lines!(ax_wca,dom,info.wca[first(inds.isothermal):end])
vlines!(ax_wca,last(inds.isothermal),color=:orange,linestyle=:dash)
vlines!(ax_wca,first(inds.rlx1),color=:black,linestyle=:dash)
vlines!(ax_wca,first(inds.rlx2),color=:black,linestyle=:dash)
vlines!(ax_wca,first(inds.rlx3),color=:black,linestyle=:dash)
vlines!(ax_wca,first(inds.rlx4),color=:black,linestyle=:dash)
vlines!(ax_wca,first(inds.deform1),color=:blue,linestyle=:dash)
vlines!(ax_wca,first(inds.deform2),color=:blue,linestyle=:dash)
vlines!(ax_wca,first(inds.deform3),color=:blue,linestyle=:dash)
vlines!(ax_wca,first(inds.deform4),color=:blue,linestyle=:dash)



lines!(ax_patch,dom,info.patch[first(inds.isothermal):end])
lines!(ax_patch,dom,info.patch[first(inds.isothermal):end].+info.swap[first(inds.isothermal):end])
lines!(ax_patch,dom,info.pot[first(inds.isothermal):end])



vlines!(ax_patch,last(inds.isothermal),color=:orange,linestyle=:dash)
vlines!(ax_patch,first(inds.rlx1),color=:black,linestyle=:dash)
vlines!(ax_patch,first(inds.rlx2),color=:black,linestyle=:dash)
vlines!(ax_patch,first(inds.rlx3),color=:black,linestyle=:dash)
vlines!(ax_patch,first(inds.rlx4),color=:black,linestyle=:dash)
vlines!(ax_patch,first(inds.deform1),color=:blue,linestyle=:dash)
vlines!(ax_patch,first(inds.deform2),color=:blue,linestyle=:dash)
vlines!(ax_patch,first(inds.deform3),color=:blue,linestyle=:dash)
vlines!(ax_patch,first(inds.deform4),color=:blue,linestyle=:dash)


lines!(ax_swap,dom,info.swap[first(inds.isothermal):end])
vlines!(ax_swap,last(inds.isothermal),color=:orange,linestyle=:dash)
vlines!(ax_swap,first(inds.rlx1),color=:black,linestyle=:dash)
vlines!(ax_swap,first(inds.rlx2),color=:black,linestyle=:dash)
vlines!(ax_swap,first(inds.rlx3),color=:black,linestyle=:dash)
vlines!(ax_swap,first(inds.rlx4),color=:black,linestyle=:dash)
vlines!(ax_swap,first(inds.deform1),color=:blue,linestyle=:dash)
vlines!(ax_swap,first(inds.deform2),color=:blue,linestyle=:dash)
vlines!(ax_swap,first(inds.deform3),color=:blue,linestyle=:dash)
vlines!(ax_swap,first(inds.deform4),color=:blue,linestyle=:dash)

lines!(ax_leg,0,0,label=latexstring("\\dot{\\gamma}:~",lbl.shearRate,"~%\\mathrm{CL}:~",100*lbl.clCon))

Legend(fig_potential[1:3,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )


# Stress
fig_stress=Figure(size=(1920,1080));
ax_leg=Axis(fig_stress[1:2,3],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_norm=Axis(fig_stress[1,1:2],
               title=L"\mathrm{Norm~of~Virial~Stress~tensor~of~full~simulation}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_xy=Axis(fig_stress[2,1:2],
               title=L"xy~\mathrm{component~of~Virial~Stress~of~full~simulation}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_xx=Axis(fig_stress[3,1:2],
               title=L"xx~\mathrm{component~of~Virial~Stress~of~full~simulation}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )

lines!(ax_norm,info.norm)
vlines!(ax_norm,first(inds.isothermal_s),color=:orange,linestyle=:dash)
vlines!(ax_norm,last(inds.isothermal_s),color=:orange,linestyle=:dash)
vlines!(ax_norm,first(inds.rlx1_s),color=:black,linestyle=:dash)
vlines!(ax_norm,first(inds.rlx2_s),color=:black,linestyle=:dash)
vlines!(ax_norm,first(inds.rlx3_s),color=:black,linestyle=:dash)
vlines!(ax_norm,first(inds.rlx4_s),color=:black,linestyle=:dash)
vlines!(ax_norm,first(inds.deform1_s),color=:blue,linestyle=:dash)
vlines!(ax_norm,first(inds.deform2_s),color=:blue,linestyle=:dash)
vlines!(ax_norm,first(inds.deform3_s),color=:blue,linestyle=:dash)
vlines!(ax_norm,first(inds.deform4_s),color=:blue,linestyle=:dash)

lines!(ax_xy,info.XY)
vlines!(ax_xy,first(inds.isothermal_s),color=:orange,linestyle=:dash)
vlines!(ax_xy,last(inds.isothermal_s),color=:orange,linestyle=:dash)
vlines!(ax_xy,first(inds.rlx1_s),color=:black,linestyle=:dash)
vlines!(ax_xy,first(inds.rlx2_s),color=:black,linestyle=:dash)
vlines!(ax_xy,first(inds.rlx3_s),color=:black,linestyle=:dash)
vlines!(ax_xy,first(inds.rlx4_s),color=:black,linestyle=:dash)
vlines!(ax_xy,first(inds.deform1_s),color=:blue,linestyle=:dash)
vlines!(ax_xy,first(inds.deform2_s),color=:blue,linestyle=:dash)
vlines!(ax_xy,first(inds.deform3_s),color=:blue,linestyle=:dash)
vlines!(ax_xy,first(inds.deform4_s),color=:blue,linestyle=:dash)


lines!(ax_xx,info.XX)
vlines!(ax_xx,first(inds.isothermal_s),color=:orange,linestyle=:dash)
vlines!(ax_xx,last(inds.isothermal_s),color=:orange,linestyle=:dash)
vlines!(ax_xx,first(inds.rlx1_s),color=:black,linestyle=:dash)
vlines!(ax_xx,first(inds.rlx2_s),color=:black,linestyle=:dash)
vlines!(ax_xx,first(inds.rlx3_s),color=:black,linestyle=:dash)
vlines!(ax_xx,first(inds.rlx4_s),color=:black,linestyle=:dash)
vlines!(ax_xx,first(inds.deform1_s),color=:blue,linestyle=:dash)
vlines!(ax_xx,first(inds.deform2_s),color=:blue,linestyle=:dash)
vlines!(ax_xx,first(inds.deform3_s),color=:blue,linestyle=:dash)
vlines!(ax_xx,first(inds.deform4_s),color=:blue,linestyle=:dash)


lines!(ax_leg,0,0,label=latexstring("\\dot{\\gamma}:~",lbl.shearRate,"~%\\mathrm{CL}:~",100*lbl.clCon))

Legend(fig_stress[1:3,3],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )


# Deformations and Relax intervals
fig_def_rlx=Figure(size=(1920,1080));
ax_leg=Axis(fig_def_rlx[1:2,5],limits=(0.01,0.1,0.01,0.1));
hidespines!(ax_leg)
hidedecorations!(ax_leg)
ax_def_norm=Axis(fig_def_rlx[1,1:2],
               title=L"\mathrm{Deformations~Norm~of~Virial~Stress}",
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_norm=Axis(fig_def_rlx[1,3:4],
               title=L"\mathrm{Relax~intervals~Norm~of~Virial~Stress}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_def_xy=Axis(fig_def_rlx[2,1:2],
               title=L"\mathrm{Deformations}~xy~\mathrm{component~of~Virial~Stress}",
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_xy=Axis(fig_def_rlx[2,3:4],
               title=L"\mathrm{Relax~intervals}~xy~\mathrm{component~of~Virial~Stress}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_def_xx=Axis(fig_def_rlx[3,1:2],
               title=L"\mathrm{Deformations}~xx~\mathrm{component~of~Virial~Stress}",
               xlabel=L"\mathrm{Strain}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )
ax_rlx_xx=Axis(fig_def_rlx[3,3:4],
               title=L"\mathrm{Relax~intervals}~xx~\mathrm{component~of~Virial~Stress}",
               xlabel=L"\mathrm{Time~steps}",
               ylabel=L"\mathrm{Stress}",
               titlesize=24.0f0,
               xticklabelsize=18.0f0,
               yticklabelsize=18.0f0,
               xlabelsize=20.0f0,
               ylabelsize=20.0f0,
               xminorticksvisible=true,
               xminorgridvisible=true
              )

aux_parm=(
          dt=parameters[15],
          shear_rate=parameters[16],
          h=2*parameters[7]
        );

strain_fct=parameters[25]*aux_parm.dt*aux_parm.shear_rate;#*aux_parm.h;

aux_def=reduce(vcat,[inds.deform1_s,inds.deform2_s,inds.deform3_s,inds.deform4_s]);
aux_rlx=reduce(vcat,[inds.rlx1_s,inds.rlx2_s,inds.rlx3_s,inds.rlx4_s]);


lines!(ax_def_norm,strain_fct.*(1:1:length(aux_def)),info.norm[aux_def])
#vlines!(ax_def_norm,last(inds.deform1_s),color=:black,linestyle=:dash)
#vlines!(ax_def_norm,last(inds.deform2_s),color=:black,linestyle=:dash)
#vlines!(ax_def_norm,last(inds.deform3_s),color=:black,linestyle=:dash)
#vlines!(ax_def_norm,last(inds.deform4_s),color=:black,linestyle=:dash)

lines!(ax_rlx_norm,info.norm[aux_rlx])
#vlines!(ax_rlx_norm,last(inds.deform1_s),color=:black,linestyle=:dash)
#vlines!(ax_rlx_norm,last(inds.deform2_s),color=:black,linestyle=:dash)
#vlines!(ax_rlx_norm,last(inds.deform3_s),color=:black,linestyle=:dash)
#vlines!(ax_rlx_norm,last(inds.deform4_s),color=:black,linestyle=:dash)


lines!(ax_def_xy,strain_fct.*(1:1:length(aux_def)),info.XY[aux_def])
lines!(ax_rlx_xy,info.XY[aux_rlx])

lines!(ax_def_xx,strain_fct.*(1:1:length(aux_def)),info.XX[aux_def])
lines!(ax_rlx_xx,info.XX[aux_rlx])


lines!(ax_leg,0,0,label=latexstring("\\dot{\\gamma}:~",lbl.shearRate,"~%\\mathrm{CL}:~",100*lbl.clCon))

Legend(fig_def_rlx[1:3,5],ax_leg,
       framevisible=true,
       halign=:center,
       orientation=:vertical,
       title=L"\mathrm{Legends}",
       patchsize=(35,35)
      )


