"""
   Script to create figures for the poster of the winter meeting.
"""

using GLMakie
using LaTeXStrings
using Nord

"""
    Code of Reference from GLMakie documentation: https://docs.makie.org/stable/reference/generic/clip_planes#examples
"""
box = Rect3f(Point3f(-1), Vec3f(2))
sphere = Sphere(Point3f(0), 0.5f0)
points = [0.7f0 * Point3f(cos(x) * sin(y), cos(x) * cos(y), sin(x)) for x in 0:8 for y in 0:8]
clip_planes = [Plane3f(Point3f(0), Vec3f(-0.5, -1, 0))]

f = Figure(size = (900, 350))

# Hide some plots in a box
Label(f[1, 1], "No clipping", tellwidth = false)
a = LScene(f[2, 1])

mesh!(a, box, color = :gray)
meshscatter!(a, points)
mesh!(a, sphere, color = :orange)

# Add a clip plane to the box to reveal the other plots
Label(f[1, 2], "Plot based clipping", tellwidth = false)
a = LScene(f[2, 2])

# backlight = 1 enables two-sided shading
mesh!(a, Rect3f(Point3f(-1), Vec3f(2)), color = :gray, backlight = 1, clip_planes = clip_planes)
meshscatter!(a, points)
mesh!(a, sphere, color = :orange)

# Adding the clip plane to the scene will make every plot inherit them
Label(f[1, 3], "Scene based clipping", tellwidth = false)
a = LScene(f[2, 3])
a.scene.theme[:clip_planes] = clip_planes

mesh!(a, Rect3f(Point3f(-1), Vec3f(2)), color = :gray, backlight = 1)
meshscatter!(a, points, backlight = 1)
mesh!(a, sphere, color = :orange, backlight = 1)

f

# Paremeters
r_part=0.5f0;
r_patc=0.2f0;

part_or=(0,0,0);
patch1A_or=r_part.*(cos(pi/2),0,sin(pi/2));
patch2A_or=r_part.*(cos(3*pi/2),0,sin(3*pi/2));

patch1B_or=(0,0,0.46);
patch2B_or=(-0.22,-0.38,-0.15);
patch3B_or=(-0.22,0.38,-0.15);
patch4B_or=(0.43,0,-0.15);



particle=Sphere(Point3f(part_or), r_part);
patch1A=Sphere(Point3f(patch1A_or), r_patc);
patch2A=Sphere(Point3f(patch2A_or), r_patc);

patch1B=Sphere(Point3f(patch1B_or), r_patc);
patch2B=Sphere(Point3f(patch2B_or), r_patc);
patch3B=Sphere(Point3f(patch3B_or), r_patc);
patch4B=Sphere(Point3f(patch4B_or), r_patc);


mon_color=Nord.nord12;
cl_color=Nord.nord11;
patchA_color=Nord.nord9;
patchB_color=Nord.nord8;

# Monomer
fig_mon=Figure(figure_padding=0,
               size=(480,480),
               px_per_unit=0.75
              )
ax_mon=LScene(fig_mon[1,1],
              show_axis=false,
             )
Makie.Camera3D(ax_mon.scene,projectiontype=Makie.Orthographic)


mesh!(ax_mon,particle,color=mon_color)
mesh!(ax_mon,patch1A,color=patchA_color)
mesh!(ax_mon,patch2A,color=patchA_color)
rotate_cam!(ax_mon.scene,(0,0,45))

# Cross Linker
fig_cl=Figure(size=(480,480))
ax_cl=LScene(fig_cl[1,1],
              show_axis=false,
             )
Makie.Camera3D(ax_cl.scene,projectiontype=Makie.Orthographic)


mesh!(ax_cl,particle,color=cl_color)
mesh!(ax_cl,patch1B,color=patchB_color)
mesh!(ax_cl,patch2B,color=patchB_color)
mesh!(ax_cl,patch3B,color=patchB_color)
mesh!(ax_cl,patch4B,color=patchB_color)


rotate_cam!(ax_cl.scene,(45,45,45))

# Central Particles A
fig_cpA=Figure(figure_padding=0,
               size=(480,480),
               px_per_unit=0.75
              )
ax_cpA=LScene(fig_cpA[1,1],
              show_axis=false,
             )
Makie.Camera3D(ax_cpA.scene,projectiontype=Makie.Orthographic)

mesh!(ax_cpA,particle,color=mon_color)
rotate_cam!(ax_cpA.scene,(0,0,45))

# Central Particles B
fig_cpB=Figure(figure_padding=0,
               size=(480,480),
               px_per_unit=0.75
              )
ax_cpB=LScene(fig_cpB[1,1],
              show_axis=false,
             )
Makie.Camera3D(ax_cpB.scene,projectiontype=Makie.Orthographic)

mesh!(ax_cpB,particle,color=cl_color)
rotate_cam!(ax_cpB.scene,(0,0,45))

# Patch A
fig_pA=Figure(figure_padding=0,
               size=(480,480),
               px_per_unit=0.75
              )
ax_pA=LScene(fig_pA[1,1],
              show_axis=false,
             )
Makie.Camera3D(ax_pA.scene,projectiontype=Makie.Orthographic)

mesh!(ax_pA,Sphere(Point3f(part_or),r_patc),color=patchA_color)
rotate_cam!(ax_pA.scene,(0,0,45))

# Patch B
fig_pB=Figure(figure_padding=0,
               size=(480,480),
               px_per_unit=0.75
              )
ax_pB=LScene(fig_pB[1,1],
              show_axis=false,
             )
Makie.Camera3D(ax_pB.scene,projectiontype=Makie.Orthographic)

mesh!(ax_pB,Sphere(Point3f(part_or),r_patc),color=patchB_color)
rotate_cam!(ax_pB.scene,(0,0,45))






