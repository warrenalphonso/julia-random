# Maybe the best usecase for Julia's performance coming from type information is arrays
using BenchmarkTools

# Column elements are stored together in memory in Julia. Column major.
# Generalizes to higher dimensions, last dimension is stored togehter
function col_iter(x)
    s = zero(eltype(x))
    for i in 1:size(x, 2)
        for j in 1:size(x, 1)
            s += x[j, i]^2
            x[j, i] = s
        end
    end
    return s
end

function row_iter(x)
    s = zero(eltype(x))
    for j in 1:size(x, 1)
        for i in 1:size(x, 2)
            s += x[j, i]^2
            x[j, i] = s
        end
    end
    return s
end

@btime col_iter(rand(1000, 1000))
@btime row_iter(rand(1000, 1000))

# If you want row-wise iteration, do an adjoint first
a = rand(1000, 1000)
b = a'

@btime col_iter($b)
@btime row_iter($b)

# Two things need to be done when creating an array: allocate memory and fill it
# fill does both
@btime fill(1, 1000, 1000)

# Filling memory is expensive and undef keyword means don't fill
@btime Array{Int64}(undef, 1000, 1000)

