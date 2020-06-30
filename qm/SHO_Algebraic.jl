#=
This module solves the SHO TISE algebraically by introducing ladder operators.
The struct I use will have to accept ω and m for sure. What if I store an array
whose 1st element is ψ₀ and whenever I do struct[i] it checks if the array has
an ith element, and if not generates it by calling raising and storing the
intermediate results.
=#
module SHO_Algebraic

include("./constants.jl")
using ForwardDiff
using .Constants
export raising, lowering, ψ₀

function raising(ψ)
    (x) -> 1 / √(2*ħ*m*ω) * ( -ħ * ForwardDiff.derivative(ψ, x) + m*ω*x*ψ(x) )
end

function lowering(ψ)
    (x) -> 1 / √(2*ħ*m*ω) * ( ħ * ForwardDiff.derivative(ψ, x) + m*ω*x*ψ(x) )
end

function ψ₀(x)
     ( (m*ω) / (π*ħ) )^(1/4) * exp( (-m*ω*x^2) / (2*ħ) )
end

end # Module 
