"""
    Script to apply the measurements of stuff
    Code by: Fco. Vazquez
    Quantum computation
    Last modification: Oct 13
"""

# Definition of the following states
"""
    Computational basis:
    |0> = (1,0) and |1> = (0,1) 
    
    States to measure
    |s1> = |0>
    |s2> = 1/sqrt(2)(|0> + |1>)

    Measurement operators
    E1 = sqrt(2)/(1+sqrt(2))|1><1|
    E2 = sqrt(2)/(2+2sqrt(2))(|0>-|1>)(<0|-<1|)
    E3 = I - E1 - E2
"""

# Computational basis
b0 = [1,0];
b1 = [0,1];

# States to measure
s1 = b0;
s2 = b1;
s3 = 1/sqrt(2).*(b0 + b1);

# To store the states in a tuple for future computation
states = (s1,s2,s3);

# Operators of the measurements
cm = sqrt(2)/(1+sqrt(2));
E1 = cm.*b1.*b1';
E2 = (cm/2).*(b0 - b1).*(b0' - b1');
E3 = I - E1 - E2;

# To store the measurements in a tuple for future computation
operators = (E1,E2,E3);


# Computing the probabilities
prob = map(l-> map(m->l'*m*l,operators),states);

# Test the numeric error
totalProb = sum.(prob);


