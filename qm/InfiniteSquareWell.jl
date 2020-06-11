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
	ω = (π^2 * ħ / (2*m*a^2))
end

# ╔═╡ f81bf9d2-abb9-11ea-25f7-7ffbbace40c0
# Vary this slider to change the stationary state
@bind n Slider(1:15)

# ╔═╡ 55628b2a-abff-11ea-164a-6deb7cd70b1d
# Varying this slider won't change much for the plot above because stationary states 
# don't change with time. 
@bind t Slider(0:10)

# ╔═╡ ab687ea8-abb9-11ea-2bff-db56b90cd8d5
let 
	ψ = gen_ψ(a, n)
	E = gen_E(m, a)
	ϕ = gen_ϕ(E(n))
	prob = gen_prob((x, t) -> ψ(x)*ϕ(t))
	
	plot((x) -> prob(x, t), 0:.01:a, label=nothing)
	title!("PDF at t=$t for stationary state $n")
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

# ╔═╡ 92700f24-ac10-11ea-36c8-cda73785bdee
md"""
### Ground state and first excited state
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
	
	plot((x) -> prob.(x, t), 0:.01:a, 
					  title="PDF at t=$t for first two stationary states", 					  			  xlabel="x", ylabel="PDF", label=nothing)
end

# ╔═╡ eeaae92a-ac12-11ea-0eee-d9a22a2e2e09
function prob_first_two(x, t)
	1/a * ( sinpi(x/a)^2 + sinpi(2x/a)^2 + 2*sinpi(x/a)*sinpi(2x/a)*cos(3*ω*t))
end

# ╔═╡ 16d55dba-ac13-11ea-190a-472dee6e492a
prob_first_two(0.5, 0)

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
		 xlims=(0, a), ylims=(-1,1), zlims=(-1,2), label="Wavefunction ψ", 
		 title="Time evolution of first 2 stationary states",
		 fillrange = 0)
	plot!(x, [0 for i in x], prob.(x, t), label="PDF", fillrange=0)
end

# ╔═╡ 9038472e-ac06-11ea-047f-7f38d158b192
let 
	anim = @animate for t in 0 : ω/50 : 3ω
		plot_one_and_two_stationary(t)
	end
	gif(anim, "qm/one_and_two_stationary.gif", fps=15)
end

# ╔═╡ 8f3f1dd2-ac10-11ea-1141-1783ff0afd09
md"""
### Ground state and first 2 excited states 
"""

# ╔═╡ a9c3d172-ac10-11ea-16a8-d5bea89b6d7f
function plot_first_three_stationary(t)
	ψ₁ = gen_ψ(a, 1)
	ψ₂ = gen_ψ(a, 2)
	ψ₃ = gen_ψ(a, 3)
	E = gen_E(m, a)
	ϕ₁ = gen_ϕ(E(1))
	ϕ₂ = gen_ϕ(E(2))
	ϕ₃ = gen_ϕ(E(3))
	normalization_constant = 1/√3
	state = (x,t) -> normalization_constant*(ψ₁(x)*ϕ₁(t) + ψ₂(x)*ϕ₂(t) + ψ₃(x)*ϕ₃(t))
	prob = gen_prob(state)
	
	x = 0:0.01:a
	y = imag(state.(x, t))
	z = real(state.(x, t))
	plot(x,y,z, xaxis="x", yaxis="Imaginary component", zaxis="Real component", 
		 xlims=(0, a), ylims=(-1,1), zlims=(-1,2), label="Wavefunction ψ", 
		 title="Time evolution for first 3 stationary states", 
		 fillrange = 0)
	plot!(x, [0 for i in x], prob.(x, t), label="PDF", fillrange=0)
end

# ╔═╡ 26cac9fa-ac11-11ea-1fdc-0b66dc7aa9d6
let
	anim = @animate for t in 0 : ω/50 : 3ω
		plot_first_three_stationary(t)
	end
	gif(anim, "qm/first_three_stationary.gif", fps=15)
end

# ╔═╡ 37c1ba02-ac11-11ea-3f8f-f3dc00039d4b
md"""
### Stationary states 4, 6, and 9
"""

# ╔═╡ 5a37b438-ac11-11ea-0f0e-3faef2740785
function plot_4_6_9_stationary(t)
	ψ₄ = gen_ψ(a, 4)
	ψ₆ = gen_ψ(a, 6)
	ψ₉ = gen_ψ(a, 9)
	E = gen_E(m, a)
	ϕ₄ = gen_ϕ(E(4))
	ϕ₆ = gen_ϕ(E(6))
	ϕ₉ = gen_ϕ(E(9))
	normalization_constant = 1/√3
	state = (x,t) -> normalization_constant*(ψ₄(x)*ϕ₄(t) + ψ₆(x)*ϕ₆(t) + ψ₉(x)*ϕ₉(t))
	prob = gen_prob(state)
	
	x = 0:0.01:a
	y = imag(state.(x, t))
	z = real(state.(x, t))
	plot(x,y,z, xaxis="x", yaxis="Imaginary component", zaxis="Real component", 
		 xlims=(0, a), ylims=(-1,1), zlims=(-1,2), label="Wavefunction ψ", 
		 title="Time evolution for stationary states 4, 6, and 9", 
		 fillrange = 0)
	plot!(x, [0 for i in x], prob.(x, t), label="PDF", fillrange=0)
end

# ╔═╡ aa1d9666-ac11-11ea-36e7-253746b0a0e8
let
	anim = @animate for t in 0 : ω/200 : 3ω
		plot_4_6_9_stationary(t)
	end
	gif(anim, "qm/4_6_9_stationary.gif", fps=15)
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
# ╟─92700f24-ac10-11ea-36c8-cda73785bdee
# ╠═536959aa-abfe-11ea-252c-bb2e4e68748b
# ╠═eeaae92a-ac12-11ea-0eee-d9a22a2e2e09
# ╠═16d55dba-ac13-11ea-190a-472dee6e492a
# ╠═8d9c271a-ac01-11ea-3e94-ad2b10f57efd
# ╠═9038472e-ac06-11ea-047f-7f38d158b192
# ╟─8f3f1dd2-ac10-11ea-1141-1783ff0afd09
# ╠═a9c3d172-ac10-11ea-16a8-d5bea89b6d7f
# ╠═26cac9fa-ac11-11ea-1fdc-0b66dc7aa9d6
# ╟─37c1ba02-ac11-11ea-3f8f-f3dc00039d4b
# ╠═5a37b438-ac11-11ea-0f0e-3faef2740785
# ╠═aa1d9666-ac11-11ea-36e7-253746b0a0e8
