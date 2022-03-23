using CairoMakie
using ColorSchemes

const α  = 1e-4                                                   # Diffusivity
const L  = 0.1                                                    # Length
const M  = 66                                                     # No.of steps
const Δx = L/(M-1)                                                # x-grid spacing
const Δt = Δx^2 / 2.0 * α                                         # Largest stable time step

function diffuse!(du, u,p,t)
    dj = view(du, 2:M-1)
    di  = view(u, 2:M-1)
    di1 = view(u, 1:M-2)
    di2 = view(u, 3:M)                                           # Stencil Computations                                         
  
    @. dj = α * (di1 - 2 * di + di2)/Δx^2                        # Apply diffusion
    du[1] = 0
    du[end] = 0                                                  # update boundary condition: Dirichlet 
end
u     = zeros(M)                                                # zeros Matrix          

fig , pltpbj = plot(u; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
figure = (resolution = (600, 400), font = "CMU Serif"),
        axis =  ( xlabel ="Spatial steps (M)", ylabel ="Temp(°C)", backgroundcolor = :white,
        xlabelsize = 15, ylabelsize = 15))
        Colorbar(fig[1,2], limits = (0, 5),label = "Heat conduction")
display(fig)


u[28:38] .= 5                                               # heat cell
 
fig , pltpbj = plot(u; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
figure = (resolution = (600, 400), font = "CMU Serif"),
        axis =  ( xlabel ="Spatial steps (M)", ylabel ="Temp(°C)", backgroundcolor = :white,
        xlabelsize = 15, ylabelsize = 15))
        Colorbar(fig[1,2], limits = (0, 5),label = "Heat conduction")
display(fig)

using DifferentialEquations, DiffEqGPU

tspan = (0.0, 1.0)
prob = ODEProblem(diffuse!, u, tspan)
sol =solve(prob)

for i =  2 : length(sol)
    fig , pltpbj = plot(sol.u[i]; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
    figure = (resolution = (600, 400), font = "CMU Serif"),
        axis =  ( xlabel ="Spatial steps (M)", ylabel ="Temp(°C)", backgroundcolor = :white,
        xlabelsize = 15, ylabelsize = 15))
        Colorbar(fig[1,2], limits = (0, 5),label = "Heat conduction")
display(fig)
end