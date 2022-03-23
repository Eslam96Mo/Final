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

u=zeros(M)
du= similar(u)          

fig , pltpbj = plot(u; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
figure = (resolution = (600, 400), font = "CMU Serif"),
axis = ( xlabel = "spatial steps(M)", ylabel = "Temp(°C)", backgroundcolor = :white,
    xlabelsize = 22, ylabelsize = 22))
    Colorbar(fig[1,2], label = "Heat conduction")  
display(fig)

u[28:38] .= 5                                             # heat Cell 
 
fig , pltpbj = plot(u; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
figure = (resolution = (600, 400), font = "CMU Serif"),
axis = ( xlabel = "spatial steps(M)", ylabel = "Temp(°C)", backgroundcolor = :white,
    xlabelsize = 22, ylabelsize = 22))
    Colorbar(fig[1,2], label = "Heat conduction")
display(fig)



for i in 1:1000                                                                  # Apply the diffuse 1000 time to let the heat spread a long the rod       
    diffuse!(du, u,0,0)
    u = u + Δt * du
    if i % 20 == 0
    fig , pltpbj = plot(u; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
    figure = (resolution = (600, 400), font = "CMU Serif"),
    axis = ( xlabel = "spatial steps(M)", ylabel = "Temp(°C)", backgroundcolor = :white,
        xlabelsize = 22, ylabelsize = 22))
        Colorbar(fig[1,2], label = "Heat conduction")
    display(fig)
    end
end