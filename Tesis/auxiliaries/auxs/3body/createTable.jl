"""
    Script to create the threebody/table filename parameter
"""

filename = "swapMechTab.table";

# Create the functions
function U3(eps_pair,eps_3,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r <= sig_p 
        return 1.0
    elseif r >= 1.5*sig_p
        return 0.0 
    else 
        return -( 2*eps_pair*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2) )./eps_3
    end
end


function SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    Potential for the swap mechanism
"""
    return round(w.*eps_jk.*U3(eps_ij,eps_jk,sig_p,r_ij).*U3(eps_ik,eps_jk,sig_p,r_ik),digits=2^7)
end

function DiffU3(eps_pair,eps_3,sig_p,r)
"""
    Get the central finite difference given the value of the position and the function.
"""
    dh=1e-3;
    fo=U3(eps_pair,eps_3,sig_p,r+dh);
    ff=U3(eps_pair,eps_3,sig_p,r-dh);
     return (1/(2*dh))*( fo - ff );
end


function DiffEvalij(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    Get the central finite difference given the value of the position and the function.
"""
    dh=1e-3;
    fo=SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij+dh,r_ik,r_c)
    ff=SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij-dh,r_ik,r_c)
    return (1/(2*dh))*( fo - ff );
end

function DiffEvalik(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    Get the central finite difference given the value of the position and the function.
"""
    dh=1e-3;
    fo=SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik+dh,r_c)
    ff=SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik-dh,r_c)
    return (1/(2*dh))*( fo - ff );
end



function force(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    Compute the force of: d/dr[U(r_ij,r_ik)], U(r_ij,r_ik) = U(r_ij)U(r_ik)
"""
    a=U3(eps_ik,eps_jk,sig_p,r_ik); 
    b=DiffU3(eps_ij,eps_jk,sig_p,r_ij);
    c=U3(eps_ij,eps_jk,sig_p,r_ij);
    d=DiffU3(eps_ik,eps_jk,sig_p,r_ik);

    return -w*eps_jk*(a*b + c*d) 

end


## Parameters for the file

N = 100;
#M = 2*N*N*N;

eps_ij = 1.0;
eps_ik = 1.0;
eps_jk = 1.0;
sig = 0.4;
rc = 1.5*sig;
rmin = sig/1000;
rmax = 2*sig;
thi = 180/(4*N)
thf = 180 - thi;
w=2;

# Create the domains of evaluation according filename nessetities
th_dom = range(thi,thf,2*N);
r_dom = range(rmin,rmax,N);

doms = reverse.(Iterators.product(th_dom,r_dom,r_dom)|>collect);
#doms = Iterators.product(r_dom,r_dom)|>collect;


# Create tuples with the information
"""
docs =  map(eachindex(doms)) do s
            (
                 s,
                 doms[s]...,
                 -DiffEvalij(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), # Derivative with respect distance i-j
                 -DiffEvalik(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), # Derivative with respect distance i-k 
                 DiffEvalij(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), 
                 0.0,
                 DiffEvalik(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), 
                 0.0,
                 SwapU(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc)
            )
        end
"""

docs2 =  map(eachindex(doms)) do s
            (
                 s,
                 doms[s]...,
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]), # Derivative with respect distance i-j
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]), # Derivative with respect distance i-k 
                 -force(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]), 
                 0.0,
                 -force(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2]), 
                 0.0,
                 SwapU(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc)
            )
        end


"""
# Felipes version
docs =  map(eachindex(doms)) do s
            (
                 s,
                 doms[s]...,
                 0.0, #-DiffEvalij(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), # Derivative with respect distance i-j
                 -DiffEvalij(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), # Derivative with respect distance i-k 
                 0.0, #DiffEvalij(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), 
                 0.0,
                 DiffEvalij(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), 
                 0.0,
                 SwapU(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc)
            )
        end
"""


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

createTable(N,rmin,rmax,docs2,filename)


