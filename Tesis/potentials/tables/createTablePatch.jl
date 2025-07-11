"""
    Script to create the table filename parameter for Patch-PAtch interaction
"""

filename = "pachTab.table";

# Create the functions
function Upatch(eps_pair,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < 1.5*sig_p 
        return round(2*eps_pair*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2),digits=2^7)
    else
        return 0.0
    end
end

function Fpatch(eps_pair,sig_p,r_c,r)
    if r < r_c
        return round(((eps_pair*sig_p)/(r^5*(r-r_c)^2))*(4*r_c^2*sig_p^3+sig_p^3*(sig_p-8*r_c).*r-2*r^5+4*r^2*sig_p^3).*exp.(((sig_p)./(r.-r_c)).+2),digits=2^7)
#4*eps_pair*(sig_p^4/r^5)*exp.((sig_p)./(r.-(1.5*sig_p)).+2) + 2*eps*(sig_p/(r-1.5*sig_p)^2)*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.((sig_p)./(r.-(1.5*sig_p)).+2)
    else
        return 0.0
    end
end

function DiffEval(eps_pair,sig_p,r)
"""
    Get the central finite difference given the value of the position and the function.
"""
    dh=1e-6;
    fo=Upatch(eps_pair,sig_p,r+dh)
    ff=Upatch(eps_pair,sig_p,r-dh)
    return (1/(2*dh))*( fo - ff );
end



# Parameters
N = 1000000;
sig = 0.4;
eps = 2.5;
rc=1.5*sig;
rmin = sig/1000;
rmax = 2*sig;
r_dom = range(rmin,rmax,length=N);

# Create the table
#info = map(s->(s,r_dom[s],Upatch(eps,sig,r_dom[s]),Fpatch(eps,sig,rc,r_dom[s])),eachindex(r_dom));

info = map(s->(s,r_dom[s],Upatch(eps,sig,r_dom[s]),-DiffEval(eps,sig,r_dom[s])),eachindex(r_dom));


# Start to write the data file
    touch(filename); # Create the file

    # Edit the file
    open(filename,"w") do f
        write(f,"DATE: 2024-07-08 UNITS: lj CONTRIBUTOR: Fco.\n\n\n")
        write(f,"POT\n")
        write(f,string("N ",N,"\n\n"))
        map(t->write(f,rstrip(join(map(s->s*" ",string.(info[t]))))*"\n" ),eachindex(info))
    end
