# Idiomatic Julia code uses lots of small functions and function call overhead is
# very low. Why? I think just because of automatic inlining?
using BenchmarkTools

# Global variables are slow because they can be written at any time so specialized
# functions can't assume their type and
p = 2
function pow_array(x::Vector{T}) where {T<:Number}
    s = zero(eltype(x))
    for y in x
        s += y^p
    end
    return s
end

@btime pow_array(rand(100))

# 10x faster
const p_const = 3
function pow_array_fixed(x::Vector{T}) where {T<:Number}
    s = zero(eltype(x))
    for y in x
        s += y^p_const
    end
    return s
end

@btime pow_array_fixed(rand(100))

# Inlining!
# Julia will automatically inline some small function. Also there are some optimizations
# that only work within a single function body, so inlining makes the body bigger
# and allows more optimization
# Check this out: https://docs.julialang.org/en/v1/devdocs/inference/#The-inlining-algorithm-(inline_worthy)
# there are some heuristics to inline based on estimating the runtime cost
# If estimated cost is not so big compared to time it would take to issue the call,
# inlining happens.

function f(x)
    a = x * 5
    b = a + 3
    return b
end

function g()
    total = 0
    for i = 1:10_000
        total += f(i)
    end
    total
end

# Notice just one function. @code_typed shows AST after type inference and inlining
@code_typed g()

peakflops()

# Generated functions: @generated re-writes function when types change
# Example: count number of cells in multi-dimensional array

function prod_dim(x::Array{T,N}) where {T,N}
    s = 1
    for i = 1:N
        s *= size(x, i)
    end
    return s
end

const x = rand(10, 5, 5, 5, 6, 7, 8, 9, 1)
@btime prod_dim(x)

# But notice that number of iterations in our function is number of dimensions in
# array *which is known as a type param*

@generated function prod_dim_gen(x::Array{T,N}) where {T,N}
    ex = :(1)
    for i in 1:N
        ex = :(size(x, $i) * $ex)
    end
    return ex
end

@btime prod_dim_gen(x)

@code_lowered prod_dim_gen(x) # No loop