### A Pluto.jl notebook ###
# v0.9.7

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
gen_prob(ψ) = (x) -> conj(ψ(x)) * ψ(x)

# ╔═╡ e8fbd416-abb6-11ea-2d8b-f3614b2702be
md"""
## Plotting stationary states 

The probability of finding a particle in a stationary state at a certain position stays constant with respect to time, as we can see in the graphic. 
"""

# ╔═╡ a849fc4e-abb7-11ea-0847-2190d7ccd188
begin
	a = 2
	m = 1
end

# ╔═╡ f81bf9d2-abb9-11ea-25f7-7ffbbace40c0
# Vary this slider to change the stationary state
@bind n Slider(1:15)

# ╔═╡ ab687ea8-abb9-11ea-2bff-db56b90cd8d5
begin 
	ψ = gen_ψ(a, n)
	E = gen_E(m, a)
	prob = gen_prob(ψ)
end

# ╔═╡ 85eca3ac-abb9-11ea-0d80-f7c53bd7b92f
begin
	plot(prob, 0:.01:a)
	xlabel!("x")
	ylabel!("Probability")
end

# ╔═╡ 0e0549d2-abbb-11ea-0ee0-cfbd662a355c
n

# ╔═╡ 253859d2-abbb-11ea-1f4a-cdd7201b4fba
md"""
## Linear combinations of stationary states 

We don't get much interesting behavior in stationary states, but if we take a linear combination of stationary states, we suddenly get variation with respect to time in the probability density. 
"""

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
# ╠═85eca3ac-abb9-11ea-0d80-f7c53bd7b92f
# ╠═f81bf9d2-abb9-11ea-25f7-7ffbbace40c0
# ╠═0e0549d2-abbb-11ea-0ee0-cfbd662a355c
# ╟─253859d2-abbb-11ea-1f4a-cdd7201b4fba
