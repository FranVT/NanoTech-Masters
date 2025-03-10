"""
    Functions for the plots 
"""

# Thermal State 

function pdfThermal(alpha,n)
"""
    alpha = omega/T;
"""
    hbar = 1.0545571726*10^(-34);
    kb = 1.38066488*10^(-23);
    return exp.(-((hbar/kb)*alpha).*n).*(1-exp(-(hbar/kb)*alpha))
end

function omegaT_ratio(mean_n)
"""
    Gives the omega/T ratio given the mean of the thermal photon distribution
"""
    hbar = 1.0545571726*10^(-34);
    kb = 1.38066488*10^(-23);
    return (kb/hbar)*log(1/mean_n + 1)
end
