



anim = @animate for it ∈ 1:10:Nt
    plot(r,sol[:,it],label=string(it))
end
gif(anim,string(pwd(),"/gifDif4.gif"),fps=12)