# Inheritance is done via :<
# Here's how Real is actually defined in Julia: 
# https://github.com/JuliaLang/julia/blob/58118253c63da7d67b9ddf326d3d3d47738e36d2/base/boot.jl#L210
abstract type MyReal <: Number end

# Composite types (aka structs)
struct Pixel
    x::Int64
    y::Int64
end

p = Pixel(5, 5)
p.x

# But you should try to parameterize types, eg hardcoding Int64 is bad
# This parameter is usually another type, but can also be a constant so that LLVM
# can use when compiling. Eg, Array{T, N} where N is num dims so we can maybe unroll
struct ParameterizedPixel{T}
    x::T
    y::T
end

p2 = ParameterizedPixel{Int32}(5, 5)

# Type stability: type of return value should depend only on types of inputs, not values
function pos(x)
    if x < 0
        return 0
    else
        return x
    end
end

pos(-1)
pos(2.5)

# code_warntype
@code_warntype pos(2.5)

# A common way to support type stability is to isolate the part of your function
# that changes type based on input into another function, and let multiple dispatch
# decide which version of that function to call.
# This is technically not the same since we're not always returning Int64 0
function pos_fixed(x)
    if x < 0
        return zero(x)
    else
        return x
    end
end

@code_warntype pos_fixed(-1.0)

# Julia's pretty good at optimizing type stability for simple functions. Not much
# difference here:
using BenchmarkTools

@btime pos(-2.5)
@btime pos_fixed(-2.5)

# Don't change variable type in a loop. 10x faster
# Bonus: checking out @simd macro for unrolling
function simdsum(x)
    s = 0
    @simd for v in x
        s += v
    end
    return s
end

function simdsum_fixed(x)
    s = zero(eltype(x))
    @simd for v in x
        s += v
    end
    return s
end

const a = rand(10_000)
@btime simdsum(a)
@btime simdsum_fixed(a)
