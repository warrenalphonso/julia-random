#=
The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17. 
Find the sum of all the primes below two million.
=# 

# Sieve of Eratosthenes 
function sieve(n) 
    x = ones(n)
    x[1] = 0
    for i in 2:Int(floor(√n))
	if x[i] == 1
	    for j in i^2:i:n
		x[j] = 0
	    end
	end
    end
    x
end

# Naive 
function sum_primes(n)
    total = 0
    x = sieve(n)
    for (i, elem) in enumerate(x)
	if elem == 1
	    total += i
	end
    end
    total 
end

@time const total = sum_primes(2_000_000)
println(total)
