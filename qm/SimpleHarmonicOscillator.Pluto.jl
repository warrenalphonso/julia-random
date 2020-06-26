### A Pluto.jl notebook ###
# v0.9.9

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ 2eff8472-ac60-11ea-3c6a-431d27291d35
begin 
	using Plots
	using PlutoUI
	using ForwardDiff
end

# ╔═╡ 1176d9f8-ac60-11ea-2383-07382f381d8d
md"""
# Quantum simple harmonic oscillator 

The classical simple harmonic oscillator is governed by Hooke's law: 

$$F = -kx \rightarrow m \frac{d^2 x}{dt^2} = -kx$$

which has the solution $x(t) = A \sin (\omega t) + B \cos (\omega t)$ where $\omega = \sqrt{\frac{k}{m}}$. 

It has the potential energy function 

$$V(x) = \frac{1}{2} k x^2 = \frac{1}{2} m \omega^2 x^2$$
"""

# ╔═╡ 3ef51504-ac60-11ea-1fe2-4109b75f3596
begin
	const h = 6.626_070_15e-34
	const ħ = h / 2π
	const k = 1e-32
	const m = 1e-34
	const ω = √(k / m)
end

# ╔═╡ 4b54a620-ac60-11ea-144b-178ea827724e
md"""
## Defining creation and annihilation operators 
"""

# ╔═╡ 0ea62a12-ac62-11ea-10b6-fb38bb010883
# I'm using the ForwardDiff library to do differentiation for momentum 
const raising = (ψ) -> (x) -> 1/√(2*ħ*m*ω) * (
	-ħ * ForwardDiff.derivative(ψ, x) + m*ω*x*ψ(x) )

# ╔═╡ 8d218a0c-ac68-11ea-1d80-b3971b6831ef
const lowering = (ψ) -> (x) -> 1/√(2*ħ*m*ω) * (
	ħ * ForwardDiff.derivative(ψ, x) + m*ω*x*ψ(x) )

# ╔═╡ b7bd4c1a-ac68-11ea-0243-9d1de6857fe0
const ψ₀ = (x) -> ( (m*ω) / (π*ħ) )^(1/4) * exp( (-m*ω*x^2) / (2*ħ) )

# ╔═╡ 1cae86ca-ac69-11ea-3d79-8bf63dbd37fa
# Function for time-dependence of stationary state 
const gen_ϕ = (E) -> (t) -> exp(-im*E*t/ħ)

# ╔═╡ 26b94b0a-ac69-11ea-2e1e-97e8535643c0
# Funtion for nth energy value 
const gen_E = (n) -> ħ*ω*(n + 1/2)

# ╔═╡ 78f1561a-ac69-11ea-1c30-95e88aff5018
# Function to get probability of finding particle at position x at time t 
gen_prob(ψ) = (x,t) -> real( conj(ψ(x,t)) * ψ(x,t) )

# ╔═╡ 609d386e-ac6d-11ea-2813-d98da654982f
md"""
## Plotting stationary states 
"""

# ╔═╡ f02c1266-ac68-11ea-3391-5d6e2c491d91
function plot_ground(t) 
	ϕ = gen_ϕ(gen_E(0))
	state = (x,t) -> ψ₀(x)*ϕ(t)
	prob = gen_prob(state)
	
	x = -1:0.01:1
	y = imag(state.(x, t))
	z = real(state.(x, t))
	plot(x,y,z, xaxis="x", yaxis="Imaginary component", zaxis="Real component", 
		 xlims=(-1,1), ylims=(-1,1), zlims=(-1,2), 
		 label="Wavefunction ψ", 
		 title="Time evolution of ground state",
		 fillrange = 0)
	plot!(x, [0 for i in x], prob.(x, t), label="PDF", fillrange=0)
end

# ╔═╡ 842994fc-ac69-11ea-2eab-2f66ccd65b10
let 
	anim = @animate for t in 0 : ω/50 : ω
		plot_ground(t)
	end
	gif(anim, fps=15)
	#gif(anim, "qm/assets/SHO_stationary_0.gif", fps=15)
end

# ╔═╡ e55de9ac-ac6a-11ea-14cf-bdffee0e99df
md"""
## Normalizing creation and annihilation operators 
"""

# ╔═╡ 49a32484-ac6b-11ea-09e2-993714685182
# Generates nth stationary state while maintaining normalization
function gen_ψₙ(n, ψ = ψ₀) 
	if n === 0 
		ψ
	else
		gen_ψₙ(n-1, (x) -> 1/√n * raising(ψ)(x))
	end
end

# ╔═╡ 045106e8-ac6c-11ea-3589-83562a532e5b
gen_ψₙ(1)

# ╔═╡ 9cf344b2-ac6c-11ea-2c56-41fe92461ba3
# Vary this slider to change the stationary state
@bind n Slider(0:5)

# ╔═╡ 71811278-ac6c-11ea-0eac-4d4f3bd75334
function plot_stationary(t) 
	ϕ = gen_ϕ(gen_E(n))
	state = (x,t) -> gen_ψₙ(n)(x)*ϕ(t)
	prob = gen_prob(state)
	
	x = -2:0.01:2
	y = imag(state.(x, t))
	z = real(state.(x, t))
	plot(x,y,z, xaxis="x", yaxis="Imaginary component", zaxis="Real component", 
		 xlims=(-3,3), ylims=(-1,1), zlims=(-1,2), 
		 label="Wavefunction ψ", 
		 title="Time evolution of stationary state $n",
		 fillrange = 0)
	plot!(x, [0 for i in x], prob.(x, t), label="PDF", fillrange=0)
end

# ╔═╡ a90ca43c-ac6c-11ea-3361-bd79c7612887
let 
	anim = @animate for t in 0 : ω/50 : ω
		plot_stationary(t)
	end
	gif(anim, fps=15)
	#gif(anim, "qm/assets/SHO_single_stationary.gif", fps=15)
end

# ╔═╡ 59e62922-ac6d-11ea-1eeb-93c41c597838
md"""
## Linear combinations of stationary states 
"""

# ╔═╡ Cell order:
# ╟─1176d9f8-ac60-11ea-2383-07382f381d8d
# ╠═2eff8472-ac60-11ea-3c6a-431d27291d35
# ╠═3ef51504-ac60-11ea-1fe2-4109b75f3596
# ╟─4b54a620-ac60-11ea-144b-178ea827724e
# ╠═0ea62a12-ac62-11ea-10b6-fb38bb010883
# ╠═8d218a0c-ac68-11ea-1d80-b3971b6831ef
# ╠═b7bd4c1a-ac68-11ea-0243-9d1de6857fe0
# ╠═1cae86ca-ac69-11ea-3d79-8bf63dbd37fa
# ╠═26b94b0a-ac69-11ea-2e1e-97e8535643c0
# ╠═78f1561a-ac69-11ea-1c30-95e88aff5018
# ╟─609d386e-ac6d-11ea-2813-d98da654982f
# ╠═f02c1266-ac68-11ea-3391-5d6e2c491d91
# ╠═842994fc-ac69-11ea-2eab-2f66ccd65b10
# ╟─e55de9ac-ac6a-11ea-14cf-bdffee0e99df
# ╠═49a32484-ac6b-11ea-09e2-993714685182
# ╠═045106e8-ac6c-11ea-3589-83562a532e5b
# ╠═71811278-ac6c-11ea-0eac-4d4f3bd75334
# ╠═9cf344b2-ac6c-11ea-2c56-41fe92461ba3
# ╠═a90ca43c-ac6c-11ea-3361-bd79c7612887
# ╟─59e62922-ac6d-11ea-1eeb-93c41c597838
