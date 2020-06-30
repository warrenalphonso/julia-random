#=
There are 2 main ways to solve the TISE for SHO: algebraically and analytically.
They both serve to generate different solutions, so I should make functions that
can work with both.
=#
module SHO
include("./constants.jl")
include("./SHO_Algebraic.jl")
using .Constants
using .SHO_Algebraic

function gen_ϕ(E)
    (t) -> exp(-im*E*t/ħ)
end

function gen_E(n)
    ħ*ω*(n + 1/2)
end

function gen_prob(ψ)
    (x,t) -> real( conj(ψ(x,t)) * ψ(x,t) )
end

end # Module
