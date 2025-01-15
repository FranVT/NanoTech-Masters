"""
    Script to create the threebody/table filename parameter
"""

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


function SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    Potential for the swap mechanism
"""
    return round(w.*eps_jk.*U3(eps_ij,eps_jk,sig_p,r_ij).*U3(eps_ik,eps_jk,sig_p,r_ik),digits=2^7)
end


function centralDiffEval(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,r_c)
"""
    Get the central finite difference given the value of the position and the function.
"""
    dh=1e-6;
    fo=SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij+dh,r_ik,r_c)
    ff=SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij-dh,r_ik,r_c)
    return (1/(2*dh))*( fo - ff );
end


## Parameters for the file

N = 100;
M = 2*N*N*N;

eps_ij = 1.0;
eps_ik = 1.0;
eps_jk = 1.0;
sig = 0.4;
rc = 1.5*sig;
rmin = sig/1000;
rmax = 2*sig;
thi = 180/(4*N)
thf = 180 - thi;
w=15;

# Create the domains of evaluation according filename nessetities
th_dom = range(thi,thf,2*N);
r_dom = range(rmin,rmax,N);

doms = Iterators.product(r_dom,r_dom,th_dom)|>collect;



# Create tuples with the information
docs =  map(eachindex(doms)) do s
            (
                 s,
                 doms[s]...,
                 -centralDiffEval(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), 
                 -centralDiffEval(w,eps_ij,eps_ik,eps_jk,sig,doms[s][2],doms[s][1],rc), 
                 centralDiffEval(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc), 
                 0.0,
                 centralDiffEval(w,eps_ij,eps_ik,eps_jk,sig,doms[s][2],doms[s][1],rc), 
                 0.0,
                 SwapU(w,eps_ij,eps_ik,eps_jk,sig,doms[s][1],doms[s][2],rc)
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


