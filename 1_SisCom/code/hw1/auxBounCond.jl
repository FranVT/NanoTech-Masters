function BoundCond(pos,wx,wy,sP,re,ae,energy)
    """
    Function to get the Lennard-Jones force for n particles
    pos:        Array of position       [x1,y1 x2,y2 ... xn,yn]
    sP:         Particle size
    re:         Repuslive exponent
    ae:         Attractive exponent
    energy:     Energy

"""
"""
pos = vR
sP = sigmaP
re = reip
ae = aeip
energy = epsP
wx = wx1
wy = wy1
"""
    
    # Number of particles
    aux = length(pos[1,:])

    # Get the distance between the particles with the wall
    difx = reshape(pos[1,:] .- wx,1,aux)
    dify = reshape(pos[2,:] .- wy,1,aux)

    LJx = ((energy)./difx).*( 4*re*((sP)./difx).^re - 4*ae.*((sP)./difx).^ae )
    LJy = ((energy)./dify).*( 4*re*((sP)./dify).^re - 4*ae.*((sP)./dify).^ae )

return [LJx; LJy]

end
