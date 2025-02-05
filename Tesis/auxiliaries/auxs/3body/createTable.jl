"""
    Script to create the threebody/table filename parameter
"""

function createTable(N,rmin,rmax,info,filename)
"""
    Create the table for threebody/table filename input as follows:
        ind rij rik th fi1 fi2 fj1 fj2 fk1 fk2 e
        ind rij rik th fi1 fi2 -fi1 0 -fi2 0 e
        ind rij rik th fij fik -fij 0 -fik 0 e
"""

    # Start to write the data file
    touch(filename); # Create the file

    # Edit the file
    open(filename,"w") do f
        write(f,"SEC1\n")
        write(f,string("N ",N," rmin ",rmin," rmax ",rmax,"\n\n"))
        map(t->write(f,rstrip(join(map(s->s*" ",string.(info[t]))))*"\n" ),eachindex(info))
    end
end


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

filename1 = "swapMechTab1.table";
filename2 = "swapMechTab2.table";

N = 100;

eps_ij = 1.0;
eps_ik = 1.0;
eps_jk = 1.0;
sig = 0.4;
rc = 1.5*sig;
rmin = sig/1000;
rmax = 2*sig;
thi = 180/(4*N)
thf = 180 - thi;
w=5;

# Create the domains of evaluation according filename nessetities
th_dom = range(thi,thf,2*N);
r_dom = range(rmin,rmax,N);

doms1 = reduce(vcat,reverse.(Iterators.product(th_dom,r_dom,r_dom)|>collect));
doms2 = reduce(vcat,map(s-> reshape(reverse.(Iterators.product(th_dom,r_dom[s:end],r_dom[s])),2*N*(N-(s-1)),1) ,eachindex(r_dom)));

# Create tuples with the information
# For Patch_j = Patch_k
docs1 =  map(eachindex(doms1)) do s
            (
                 s,
                 doms1[s]...,
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms1[s][1],doms1[s][2]), 
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms1[s][1],doms1[s][2]), 
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms1[s][1],doms1[s][2]), 
                 0.0,
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms1[s][1],doms1[s][2]), 
                 0.0,
                 SwapU(w,eps_ij,eps_ik,eps_jk,sig,doms1[s][1],doms1[s][2],rc)
            )
        end

# For Patch_j != Patch_k
docs2 =  map(eachindex(doms2)) do s
            (
                 s,
                 doms2[s]...,
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms2[s][1],doms2[s][2]), 
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms2[s][1],doms2[s][2]), 
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms2[s][1],doms2[s][2]), 
                 0.0,
                 force(w,eps_ij,eps_ik,eps_jk,sig,doms2[s][1],doms2[s][2]), 
                 0.0,
                 SwapU(w,eps_ij,eps_ik,eps_jk,sig,doms2[s][1],doms2[s][2],rc)
            )
        end

createTable(N,rmin,rmax,docs1,filename1)
createTable(N,rmin,rmax,docs2,filename2)


