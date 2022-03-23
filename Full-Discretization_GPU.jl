using CUDA
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

u_GPU=CUDA.zeros(M)
du_GPU = similar(u_GPU)          

fig , pltpbj = plot(u_GPU; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
figure = (resolution = (600, 400), font = "CMU Serif"),
        axis =  ( xlabel ="Spatial steps (M)", ylabel ="Temp(°C)", backgroundcolor = :white,
        xlabelsize = 15, ylabelsize = 15))
        Colorbar(fig[1,2], limits = (0, 5),label = "Heat conduction")
display(fig)

u_GPU[32:33] .= 50                                               # heat Source 
 
fig , pltpbj = plot(u_GPU; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
figure = (resolution = (600, 400), font = "CMU Serif"),
        axis =  ( xlabel ="Spatial steps (M)", ylabel ="Temp(°C)", backgroundcolor = :white,
        xlabelsize = 15, ylabelsize = 15))
        Colorbar(fig[1,2], limits = (0, 5),label = "Heat conduction")
display(fig)



for i in 1:1000                                                                  # Apply the diffuse 1000 time to let the heat spread a long the rod       
    diffuse!(du_GPU, u_GPU,0,0)
    u_GPU = u_GPU + Δt * du_GPU
if i % 20 == 0
fig , pltpbj = plot(u_GPU; colormap  = :viridis ,markersize = 5, linestyle = ".-", 
    figure = (resolution = (600, 400), font = "CMU Serif"),
        axis =  ( xlabel ="Spatial steps (M)", ylabel = "Temp(°C)", backgroundcolor = :white,
        xlabelsize = 15, ylabelsize = 15))
        Colorbar(fig[1,2], limits = (0, 5),label = "Heat conduction")
display(fig)
    end
end
