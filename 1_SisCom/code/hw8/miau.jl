"""
    Script thet Chat GPT create whit the following prompt:
    Create a script in julia that compute the wave equation with absorbing boundary condition using finite differences in two sptial dimensions and one temporal dimension
"""

using Plots

# Define parameters
nx = 100  # Number of grid points in x-direction
ny = 100  # Number of grid points in y-direction
nt = 1000 # Number of time steps
c = 1.0   # Wave speed
dx = 1.0  # Grid spacing in x-direction
dy = 1.0  # Grid spacing in y-direction
dt = 0.1  # Time step size

# Define absorbing boundary region
absorption_width = 10
absorption_strength = 0.1

# Initialize wavefields
u = zeros(nx, ny) # Current time step
u_next = zeros(nx, ny) # Next time step
u_prev = zeros(nx, ny) # Previous time step

# Initialize plots
display(heatmap(u, aspect_ratio=:equal, c=:balance, color=:balance, clim=(-1, 1), xlims=(1, nx), ylims=(1, ny)))

# Function to update wavefield
function update_wavefield()
    for i in 2:nx-1
        for j in 2:ny-1
            u_next[i, j] = 2 * u[i, j] - u_prev[i, j] +
                (c^2 * dt^2 / dx^2) * (u[i+1, j] + u[i-1, j] - 2 * u[i, j]) +
                (c^2 * dt^2 / dy^2) * (u[i, j+1] + u[i, j-1] - 2 * u[i, j])
        end
    end
    
    # Apply absorbing boundary conditions
    for i in 1:nx, j in 1:ny
        if i <= absorption_width || i >= nx - absorption_width || j <= absorption_width || j >= ny - absorption_width
            u_next[i, j] *= 1 - absorption_strength
        end
    end
    
    # Update wavefields for next time step
    u_prev, u, u_next = u, u_next, u_prev
end

# Main simulation loop
for t in 1:nt
    update_wavefield()
    # Plot every 10 time steps
    if t % 10 == 0
        heatmap(u, aspect_ratio=:equal, c=:balance, color=:balance, clim=(-1, 1), xlims=(1, nx), ylims=(1, ny))
        display(plot!)
    end
end
