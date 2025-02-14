
function LJf(pos,sP,re,ae,energy)
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
"""
    
    # Number of particles
    aux = length(pos[1,:]);

    # Get the distance between the particles
    dif = map( l->map( s->pos[:,l]-pos[:,s],collect(l+1:1:aux) ),collect(1:1:aux-1) );
    dist = map( itt->  sqrt.(sum.(map( it->dif[itt][it].^2,collect(1:1:aux-itt) ))) ,collect(1:1:aux-1) );

    # Norm of the force
    LJ = map( s->((energy)./dist[s]).*( 4*re*((sP)./dist[s]).^re - 4*ae.*((sP)./dist[s]).^ae ), collect(1:1:aux-1));

    # Reshape the array of arrays to a matrix
    part = zeros(aux,aux-1);
    map( s->part[s+1:end,s] = LJ[s], collect(1:aux-1));
    map(s->part[s,s:end] = LJ[s],collect(1:aux-1));

    # Get the angle for x and y components and rechape the array of arrays to a matrix
    th = map( r-> map( s->atan( dif[r][s][2], dif[r][s][1] ),collect(1:1:aux-r) ), collect(1:1:aux-1) );
    ang = zeros(aux,aux-1);
    map( s->ang[s+1:end,s] = th[s], collect(1:aux-1));
    map(s->ang[s,s:end] = th[s],collect(1:aux-1));

    # Get the x and y compoents of the force
    LJx = reshape(sum(part.*cos.(ang),dims=2),1,aux);
    LJy = reshape(sum(part.*sin.(ang),dims=2),1,aux);

return [LJx; LJy]

end
