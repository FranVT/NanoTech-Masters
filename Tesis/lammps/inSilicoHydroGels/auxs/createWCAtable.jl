"""
    Create table potential for WCA
"""

filename = "wcaTab.table";

# Create the functions
function Upatch(eps_pair,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < 2^(1/6)*sig_p 
        return 4*eps_pair*( ((sig_p^12)./(r.^12)) .- ((sig_p^6)./(r.^6)) ) .+ eps_pair 
    else
        return 0.0
    end
end

function Fpatch(eps_pair,sig_p,r)
    if r < 2^(1/6)*sig_p
        return -4*eps_pair*( -((12).*(sig_p^12)./(r.^13)) .+ ((6).*(sig_p^6)./(r.^7)) )
    else
        return 0.0
    end
end

# Parameters
N = 1000;
sig = 0.4;
eps = 1.0;
rmin = 0.000001;
rmax = 1.5*sig;
r_dom = range(rmin,rmax,length=N);

# Create the table
info = map(s->(s,r_dom[s],Upatch(eps,sig,r_dom[s]),Fpatch(eps,sig,r_dom[s])),eachindex(r_dom));

# Start to write the data file
    touch(filename); # Create the file

    # Edit the file
    open(filename,"w") do f
        write(f,"DATE: 2024-09-27 UNITS: lj CONTRIBUTOR: Fco.\n\n\n")
        write(f,"POT\n")
        write(f,string("N ",N,"\n\n"))
        map(t->write(f,rstrip(join(map(s->s*" ",string.(info[t]))))*"\n" ),eachindex(info))
    end
