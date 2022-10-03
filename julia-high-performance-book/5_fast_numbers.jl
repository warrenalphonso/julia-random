# Int type alias represents actual integer type used by system, eg Int64
Sys.WORD_SIZE == 64
Int == Int64

# Types whose representation are a set of bits are called bits types and are optimized
# How?
isbitstype(Float64)

# Julia uses machine arithmetic for basic operations, so bounds checks aren't done
x = typemax(Int64)
x + 1 < x

x = rand(Int32)
y = rand(Int32)

using BenchmarkTools

# We can use BigInt if we need to mess with very big integers but they're slow
@btime BigInt(y)
# This times creation of BigInts and multiplication
@btime BigInt(y) * BigInt(x)
# This only times the multiplication of BigInts. See ?@btime and ?@benchmark
@btime $(BigInt(y)) * $(BigInt(x))
@btime $(Int64(y)) * $(Int64(x))
