#=
By listing the first six primes 2,3,5,7,11,13 we can see the 6th prime is 13.
What is the 10001st prime number?
=#

# Naive - calculate all primes
function naive()
    primes = Int64[]
    i = 2
    while size(primes)[1] < 10001
        for prime in primes
            if i % prime == 0
                push!(primes, i)
                break
            end
        end
        i += 1
    end
    println(pop!(primes))
end

# @time naive() takes wayy too long

# Sieve - 0.0040 seconds
function sieve()
    n = 10001 * 20 # Primes up til here
    x = ones(n)
    x[1] = 0
    for i in 2:Int(floor(√n))
        if x[i] == 1
            for j in i^2:i:n
                x[j] = 0
            end
        end
    end
    num_primes = 0
    for (i, elem) in enumerate(x)
        if elem == 1
            num_primes += 1
            if num_primes == 10001
                println(i)
                break
            end
        end
    end
end

@time sieve()
