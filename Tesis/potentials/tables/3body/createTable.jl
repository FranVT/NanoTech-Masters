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

    nothing
end

function Upatch(eps_pair,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < 1.5*sig_p 
        return round(2*eps_pair*( (1/2)*(sig_p/r)^4 - 1 )*exp( sig_p/(r-1.5*sig_p) + 2 ),digits=2^7)
    else
        return 0.0
    end
end

function U3(eps_pair,eps_3,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r <= sig_p 
        return 1.0
    elseif r >= 1.5*sig_p
        return 0.0 
    else 
        return -(1/eps_3)*Upatch(eps_pair,sig_p,r)
    end
end

function SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
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

function forceSwap(w,eps_ij,eps_ik,eps_jk,sig_p,r_1,r_2)
"""
    Compute the force of the swap potential
    d/dr[U(r_ij)U(r_ik)] = U(r_ik)d/dr[U(r_ij)] + U(r_ij)d/dr[U(r_ik)]
"""
    a=U3(eps_ik,eps_jk,sig_p,r_2); 
    b=DiffU3(eps_ij,eps_jk,sig_p,r_1);
    c=U3(eps_ij,eps_jk,sig_p,r_1);
    d=DiffU3(eps_ik,eps_jk,sig_p,r_2);

    return -w*eps_jk*(a*b + c*d) 

end

function force(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,th)
"""
    Function that computes the f_i1 and f_i2 for lammps force projection tot the plane formed by the vector distances r_ij, r_ik and r_jk
"""
    th = deg2rad(th);
    r_jk = sqrt(r_ij^2+r_ik^2-2*r_ij*r_ik*cos(th));

    f_i=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik);
    f_j=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_jk);
    f_k=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_p,r_ik,r_jk);

    f_i1=f_i;
    f_i2=f_i*cos(th);
   
    f_j1=-f_i1;
    f_j2=f_j*(1-cos(th));

    f_k1=-f_i2;
    f_k2=-f_j2;

    eng=SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik) + SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_jk) + SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ik,r_jk)
    eng=round(eng/3,digits=2^7)

    return (f_i1,f_i2,f_j1,f_j2,f_k1,f_k2,eng)
end

function force2(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik,th)
"""
    Function that computes the f_i1 and f_i2 for lammps force projection tot the plane formed by the vector distances r_ij, r_ik and r_jk
"""
    th = deg2rad(th);
    r_jk = sqrt(r_ij^2+r_ik^2-2*r_ij*r_ik*cos(th));

    f_i=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik);
    f_j=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_jk);
    f_k=forceSwap(w,eps_ij,eps_ik,eps_jk,sig_p,r_ik,r_jk);

    f_i1=f_i;
    f_i2=f_i*cos(th);
   
    f_j1=f_j;
    f_j2=f_j*(1-cos(th));

    f_k1=f_k*cos(th);
    f_k2=f_k*(1-cos(th));

    eng=SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik) + SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_jk) + SwapU(w,eps_ij,eps_ik,eps_jk,sig_p,r_ik,r_jk)
    eng=round(eng/3,digits=2^7)

    return (f_i1,f_i2,f_j1,f_j2,f_k1,f_k2,eng)
end


## Parameters for the file

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
w=3;

filename1 = string("swapMechTab1_w",w,".table");
filename2 = string("swapMechTab2_w",w,".table");

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
                 force2(w,eps_ij,eps_ik,eps_jk,sig,doms1[s]...)...
            )
        end;

docs2 =  map(eachindex(doms2)) do s
            (
                 s,
                 doms2[s]...,
                 force2(w,eps_ij,eps_ik,eps_jk,sig,doms2[s]...)...
            )
        end;

createTable(N,rmin,rmax,docs1,filename1)
createTable(N,rmin,rmax,docs2,filename2)

nothing
