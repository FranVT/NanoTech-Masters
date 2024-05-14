

heatmap(r,r,sol[:,:,end],clims=(-1,1))

plot(r,sol[:,Nr÷2,end])

plot(sol[:,Nr÷2,10])


anim = @animate for it ∈eachindex(t)
    heatmap(r,r,sol[:,:,it],clims=(-1,1))
end
gif(anim,string(pwd(),"/gifWave.gif"),fps=12)
