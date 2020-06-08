#=
2520 is the smallest number that can be divided by each of the numbers from 1
to 10 without any remainder.
What is the smallest positive number that is evenly divisible by all of the
numbers from 1 to 20?
=#

# Find prime factors of 1:20 and union them - 0.000023 seconds
function union_prime_factors()
    union_factors = Dict(
        2 => 0,
        3 => 0,
        5 => 0,
        7 => 0,
        11 => 0,
        13 => 0,
        17 => 0,
        19 => 0
    )

    function loop(n)
        for i in 2:n
            if n % i == 0
                return i
            end
        end
    end

    function prime_factors(n)
        factors = Dict(
            2 => 0,
            3 => 0,
            5 => 0,
            7 => 0,
            11 => 0,
            13 => 0,
            17 => 0,
            19 => 0
        )
        while n != 1
            factor = loop(n)
            factors[factor] += 1
            n = n / factor
        end
        for (k,v) in factors
            if v > union_factors[k]
                union_factors[k] = v
            end
        end
    end

    for i in 1:20
        prime_factors(i)
    end

    lcm = 1
    for (k,v) in union_factors
        lcm *= k^v
    end
    lcm
end

println(@time union_prime_factors())
