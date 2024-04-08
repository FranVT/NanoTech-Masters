"""
    Assigment 6 - Monte Carlo Methods

    Use a Monte-Caro algorithm to approximate the value of pi.
    Plot the error in this approximation as the number of random samples is increased from 10 to 10e6.
"""

using Random, Distributions
using Plots, LaTeXStrings

# Set the backend from graphs
gr()

# Set the seed and the generator
rng = Xoshiro(1234)

