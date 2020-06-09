# Performance docs say that annotating types when updating global variables
# is faster.

x = rand(1000)

function annotate_loop_global()
    s = 0.0
    for i in x::Vector{Float64}
        s += i
    end
    s
end

@time annotate_loop_global()

function loop_global()
    s = 0.0
    for i in x
        s += i
    end
    s
end

@time loop_global() # About 40 times slower...

function loop_local()
    s = 0.0
    y = x
    for i in y
        s += i
    end
    s
end
@time loop_local()

function loop_local(y)
    s = 0.0
    for i in y
        s += i
    end
    s
end
@time loop_local(x)
