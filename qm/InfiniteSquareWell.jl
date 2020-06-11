### A Pluto.jl notebook ###
# v0.9.8

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ a21d6070-abb4-11ea-1eac-012c549a6ddd
begin 
	using Plots
	using PlutoUI
end

# ╔═╡ 157e319a-abac-11ea-1feb-abd64534887b
md"""
# Visualizing wavefunctions in the infinite square well
"""

# ╔═╡ 286d3dee-abab-11ea-1c66-ff8e29b94114
const h = 6.626_070_15e-34

# ╔═╡ 76cd95ce-abab-11ea-379e-cf0ff8dca675
const ħ = h / 2pi

# ╔═╡ 144448b6-abac-11ea-2c6f-89e7f11ee504
md"""
The Schrodinger equation is 

$$i \hbar \frac{\partial \Psi}{\partial t} = - \frac{\hbar^2}{2m} \frac{\partial^2 \Psi}{\partial x^2} + V \Psi$$

If we assume that $\Psi(x, t) = \psi(x) \phi(t)$, then we get the time-independent Schrodinger equation

$$- \frac{\hbar^2}{2m} \frac{d^2 \psi}{dx^2} + V \psi = E \psi$$

Then the time-dependent version of this *stationary state* is 

$$\Psi(x, t) = \psi(x) e^{-i Et / \hbar}$$
"""

# ╔═╡ d978aae6-abac-11ea-28a1-db47ea594749
# Function for nth stationary state 
const gen_ψ(a, n) = (x) -> √(2/a) * sinpi(n*x/a)

# ╔═╡ bb2fe374-abb6-11ea-3ffb-635dda2838af
# Function for time-dependence of stationary state 
const gen_ϕ(E) = (t) -> exp(-im*E*t/ħ)

# ╔═╡ 66f37014-abb6-11ea-001f-d52cbffe020e
# Funtion for nth energy value 
const gen_E(m, a) = (n) -> (n^2 * π^2 * ħ^2)/(2 * m * a^2)

# ╔═╡ 1a51e348-abb7-11ea-056f-ef297ec19c80
# Function to get probability of finding particle at position x at time t 
gen_prob(ψ) = (x,t) -> real( conj(ψ(x,t)) * ψ(x,t) )

# ╔═╡ e8fbd416-abb6-11ea-2d8b-f3614b2702be
md"""
## Plotting stationary states 

The probability of finding a particle in a stationary state at a certain position stays constant with respect to time, as we can see in the graphic. 
"""

# ╔═╡ a849fc4e-abb7-11ea-0847-2190d7ccd188
begin
	a = 2
	m = 1e-34
	ω = (π^2 * ħ / (2*m*a^a))
end

# ╔═╡ f81bf9d2-abb9-11ea-25f7-7ffbbace40c0
# Vary this slider to change the stationary state
@bind n Slider(1:15)

# ╔═╡ 55628b2a-abff-11ea-164a-6deb7cd70b1d
# Varying this slider won't change much for the plot above because stationary states 
# don't change with time. But it will affect the plot below. 
@bind t Slider(0:10)

# ╔═╡ ab687ea8-abb9-11ea-2bff-db56b90cd8d5
let 
	ψ = gen_ψ(a, n)
	E = gen_E(m, a)
	ϕ = gen_ϕ(E(n))
	prob = gen_prob((x, t) -> ψ(x)*ϕ(t))
	
	plot((x) -> prob(x, t), 0:.01:a)
	title!("Probability density at t=0")
	xlabel!("x")
	ylabel!("Probability")
end

# ╔═╡ 0e0549d2-abbb-11ea-0ee0-cfbd662a355c
(n, t)

# ╔═╡ 253859d2-abbb-11ea-1f4a-cdd7201b4fba
md"""
## Linear combinations of stationary states 

We don't get much interesting behavior in stationary states, but if we take a linear combination of stationary states, we suddenly get variation with respect to time in the probability density. 
"""

# ╔═╡ 536959aa-abfe-11ea-252c-bb2e4e68748b
let 
	ψ₁ = gen_ψ(a, 1)
	ψ₂ = gen_ψ(a, 2)
	E = gen_E(m, a)
	ϕ₁ = gen_ϕ(E(1))
	ϕ₂ = gen_ϕ(E(2))
	normalization_constant = 1/√2 
	state = (x, t) -> normalization_constant * ( ψ₁(x)*ϕ₁(t) + ψ₂(x)*ϕ₂(t) )
	prob = gen_prob(state)
	
	plot((x) -> prob(x, t), 0:.01:a)
	
end

# ╔═╡ 8d9c271a-ac01-11ea-3e94-ad2b10f57efd
function plot_one_and_two_stationary(t) 
	ψ₁ = gen_ψ(a, 1)
	ψ₂ = gen_ψ(a, 2)
	E = gen_E(m, a)
	ϕ₁ = gen_ϕ(E(1))
	ϕ₂ = gen_ϕ(E(2))
	normalization_constant = 1/√2 
	state = (x, t) -> normalization_constant * ( ψ₁(x)*ϕ₁(t) + ψ₂(x)*ϕ₂(t) )
	prob = gen_prob(state)
	
	x = 0:0.01:a
	y = imag(state.(x, t))
	z = real(state.(x, t))
	plot(x,y,z, xaxis="x", yaxis="Imaginary component", zaxis="Real component", 
		 xlims=(0, a), ylims=(-1,1), zlims=(-1,1), label="Wavefunction ψ", 
		 fillrange = 0)
	plot!(x, [0 for i in x], prob.(x, t), label="PDF", fillrange=0)
end

# ╔═╡ 9038472e-ac06-11ea-047f-7f38d158b192
let 
	anim = @animate for t in 0 : ω/50 : 3ω
		plot_one_and_two_stationary(t)
	end
	gif(anim, "one_and_two_stationary.gif", fps=15)
end

# ╔═╡ Cell order:
# ╟─157e319a-abac-11ea-1feb-abd64534887b
# ╠═a21d6070-abb4-11ea-1eac-012c549a6ddd
# ╠═286d3dee-abab-11ea-1c66-ff8e29b94114
# ╠═76cd95ce-abab-11ea-379e-cf0ff8dca675
# ╟─144448b6-abac-11ea-2c6f-89e7f11ee504
# ╠═d978aae6-abac-11ea-28a1-db47ea594749
# ╠═bb2fe374-abb6-11ea-3ffb-635dda2838af
# ╠═66f37014-abb6-11ea-001f-d52cbffe020e
# ╠═1a51e348-abb7-11ea-056f-ef297ec19c80
# ╟─e8fbd416-abb6-11ea-2d8b-f3614b2702be
# ╠═a849fc4e-abb7-11ea-0847-2190d7ccd188
# ╠═ab687ea8-abb9-11ea-2bff-db56b90cd8d5
# ╠═f81bf9d2-abb9-11ea-25f7-7ffbbace40c0
# ╠═55628b2a-abff-11ea-164a-6deb7cd70b1d
# ╠═0e0549d2-abbb-11ea-0ee0-cfbd662a355c
# ╟─253859d2-abbb-11ea-1f4a-cdd7201b4fba
# ╠═536959aa-abfe-11ea-252c-bb2e4e68748b
# ╠═8d9c271a-ac01-11ea-3e94-ad2b10f57efd
# ╠═9038472e-ac06-11ea-047f-7f38d158b192
