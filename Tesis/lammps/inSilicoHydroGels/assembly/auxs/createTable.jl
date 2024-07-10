"""
    Script to create the threebody/table filename parameter
"""

workdir = cd("/home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/assembly/")
filename = "swapMechTab.table";

# Create the functions
function U3(eps_pair,eps_3,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < sig_p 
        return 1.0
    elseif r >= 1.5*sig_p
        return 0.0 
    else 
        return -( 2*eps_pair*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2) )./eps_3
    end
end


function SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    Potential for the swap mechanism
"""
    return w.*eps_jk.*U3(eps_ij,eps_jk,sig_p,r_ij).*U3(eps_ik,eps_jk,sig_p,r_ik)
end

function Forceij(eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    -d/drij SwapU
"""
    if r_ij < sig_p || r_ik < sig_p
        return 0.0
    elseif r_ij >= 1.5*sig_p || r_ik >= 1.5*sig_p
        return 0.0 
    else 
        t1 = (eps_ij*eps_ik/eps_jk)*( (sig_p^4/r_ij^5)*((sig_p^4/(2*r_ik^4))-1) )*( 8*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        t2 = (eps_ij*eps_ik/eps_jk)*( (sig_p/(r_ij-1.5*sig_p)^2)*((sig_p^4/(2*r_ij^4))-1)*((sig_p^4/(2*r_ik^4))-1) )*( 4*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        return t1+t2
    end
end

function Forceik(eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    -d/drij SwapU
"""
    if r_ij < sig_p || r_ik < sig_p
        return 0.0
    elseif r_ij >= 1.5*sig_p || r_ik >= 1.5*sig_p 
        return 0.0
    else
        t1 = (eps_ij*eps_ik/eps_jk)*( (sig_p^4/r_ik^5)*((sig_p^4/(2*r_ij^4))-1) )*( 8*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        t2 = (eps_ij*eps_ik/eps_jk)*( (sig_p/(r_ik-1.5*sig_p)^2)*((sig_p^4/(2*r_ij^4))-1)*((sig_p^4/(2*r_ik^4))-1) )*( 4*exp(4+(sig_p/(r_ij-1.5*sig_p))+(sig_p/(r_ik-1.5*sig_p))) )
        return t1+t2
    end
end

## Parameters for the file

N = 50;
M = 2*N*N*N;

eps_ij = 10.0;
eps_ik = 10.0;
eps_jk = 10.0;
sig = 0.4;
rmin = sig-sig/10;
rmax = 1.499*sig;
thi = 180/(4*N)
thf = 180 - thi;

# Create the domains of evaluation according filename nessetities
th_dom = range(thi,thf,2*N);
r_dom = range(rmin,rmax,N);

doms = reduce(vcat,Iterators.product(r_dom,r_dom,th_dom));

# Create tuples with the information
docs =  map(eachindex(doms)) do s
            (
                 s,
                 doms[s]...,
                 -Forceij(eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]),
                 -Forceik(eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]),
                 Forceij(eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]),
                 0.0,
                 Forceik(eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]),
                 0.0,
                 SwapU(1.0,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2])
            )
        end

function createTable(N,rmin,rmax,info,filename)
"""
    Create the table for threebody/table filename input as follows:
        ind rij rik th fi1 fi2 fj1 fj2 fk1 fk2 e
        ind rij rik th fi1 fi2 -fi1 0 -fi2 0 e
        ind rij rik th fij fik -fij 0 -fik 0 e
"""
# map(s-> string("    ",s," ",masses[s],"\n"),1:atom_type);

    # Start to write the data file
    touch(filename); # Create the file

    # Edit the file
    open(filename,"w") do f
        write(f,"SEC1\n")
        write(f,string("N ",N," rmin ",rmin," rmax ",rmax,"\n\n"))
        map(t->write(f,rstrip(join(map(s->s*" ",string.(info[t]))))*"\n" ),eachindex(info))
    end
end

createTable(N,rmin,rmax,docs,filename)
