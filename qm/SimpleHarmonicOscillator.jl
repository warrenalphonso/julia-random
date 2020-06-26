using Plots
using ForwardDiff

const h = 6.626_070_15e-34
const ħ = h / 2π
const k = 1e-32
const m = 1e-34
const ω = √(k / m)

@doc raw"""
    raising(ψ)

Takes as input a wavefunction ψ and returns the result of applying the
raising operator to it: a₊ψ.

``a_+ = \sqrt{\frac{m \omega}{2 \hbar}}``
"""
raising(ψ) = (x) -> 1 / √(2*ħ*m*ω) * (
    -ħ * ForwardDiff.derivative(ψ, x) + m*ω*x*ψ(x) )

lowering(ψ) = (x) -> 1 / √(2*ħ*m*ω) * (
    ħ * ForwardDiff.derivative(ψ, x) + m*ω*x*ψ(x) )

@doc "Ground state of SHO"
ψ₀(x) = ( (m*ω) / (π*ħ) )^(1/4) * exp( (-m*ω*x^2) / (2*ħ) )

@doc """Generate time-dependence from energy."""
gen_ϕ(E) = (t) -> exp(-im*E*t/ħ)

@doc "Get energy of nth SHO stationary state."
gen_E(n) = ħ*ω*(n + 1/2)

@doc "Get probability distribution of ψ."
gen_prob(ψ) = (x,t) -> real( conj(ψ(x,t)) * ψ(x,t) )


# Plotting ground state
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

anim = @animate for t in 0 : ω/50 : ω
	plot_ground(t)
end
gif(anim, fps=15)
#gif(anim, "qm/assets/SHO_stationary_0.gif", fps=15)


# Normalizing creation and annihilation operators
function gen_ψ_n(n, ψ=ψ₀)
	if n === 0
		ψ
	else
		gen_ψ_n(n-1, (x) -> 1/√n * raising(ψ)(x))
	end
end

@time gen_ψ_n(100) # Can I make allocations constant?

n = 5

function plot_stationary(t)
	ϕ = gen_ϕ(gen_E(n))
	state = (x,t) -> gen_ψ_n(n)(x)*ϕ(t)
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

anim = @animate for t in 0 : ω/50 : ω
	plot_stationary(t)
end
gif(anim, fps=15)
#gif(anim, "qm/assets/SHO_single_stationary.gif", fps=15)


# Linear combinations of stationary states
