"""
    Script with the functions
"""

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

function forceSwap(w,eps_ij,eps_ik,eps_jk,sig_p,r_ij,r_ik)
"""
    Compute the force of the swap potential
    d/dr[U(r_ij,r_ik)], U(r_ij,r_ik) = U(r_ij)U(r_ik)
"""
    a=U3(eps_ik,eps_jk,sig_p,r_ik); 
    b=DiffU3(eps_ij,eps_jk,sig_p,r_ij);
    c=U3(eps_ij,eps_jk,sig_p,r_ij);
    d=DiffU3(eps_ik,eps_jk,sig_p,r_ik);

    return -w*eps_jk*(a*b + c*d) 

end

function Upatch(eps_pair,sig_p,r)
"""
    Auxiliary potential to create Swap Mechanism based in Patch-Patch interaction
"""
    if r < 1.5*sig_p 
        #return round(2*eps_pair*( ((sig_p^4)./((2).*r.^4)) .-1).*exp.(((sig_p)./(r.-(1.5*sig_p))).+2),digits=2^7)
        return 2*eps_pair*( sig_p^4/(2*r^4) - 1 )*exp( sig_p/(r-1.5*sig_p) + 2 )
    else
        return 0.0
    end
end

function DiffUpatchEval(eps_pair,sig_p,r)
"""
    Get the central finite difference of the patch interaction potential given the value of the position.
"""
    dh=1e-6;
    fo=Upatch(eps_pair,sig_p,r+dh)
    ff=Upatch(eps_pair,sig_p,r-dh)
    return (1/(2*dh))*( fo - ff );
end

function WCA(eps_pair,sig_p,r)
"""
    WCA potential for particles interaction
"""
    if r >sig_p*2^(1/6)
        return 0
    else
        return 4*eps_pair*( (sig_p/r)^(12) - (sig_p/r)^(6) ) + eps_pair
    end
end

function DiffWCAEval(eps_pair,sig_p,r)
"""
    Get the central finite difference of the patch interaction potential given the value of the position.
"""
    dh=1e-6;
    fo=WCA(eps_pair,sig_p,r+dh)
    ff=WCA(eps_pair,sig_p,r-dh)
    return (1/(2*dh))*( fo - ff );
end


