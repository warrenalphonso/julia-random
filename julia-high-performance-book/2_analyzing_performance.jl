# @time wraps any Julia expression
@time rand(100)
@time for i in 1:10_000
    x = sin.(rand(1000))
end

# @timev gives more info
@timev sum(rand(1000))

# Julia's profiler. Need to `Profile.clear()` between `@profile` calls
using Profile
using Statistics

function randmsq()
    x = rand(10_000, 1_000)
    y = mean(x .^ 2, dims=1)
    return y
end

@profile randmsq()
Profile.print()
Profile.clear()

using ProfileView
ProfileView.view()

# BenchmarkTools.jl for repeated trials 
using BenchmarkTools
@benchmark sqrt.(rand(10))