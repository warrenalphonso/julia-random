#= 
The prime factors of 13195 are 5, 7, 13, and 29. What is the largest prime 
factor of the number 600851475143?
=#

# Naive - calculate all prime factors 
# log_2(sqrt(600851475143)) == 20 
# Pretty sure this is still O(√N) right?
num = 600851475143
factors = Int32[]
for i in 2:√num
    if num % i == 0
	push!(factors, i)
	while num % i == 0
	    global num /= i
	end
    end
end
println(pop!(factors))

# Calculate all prime numbers up to √N and check if divisible 
# Using the Sieve of Eratosthenes to calculate prime numbers
num = 600851475143
sieve = fill(true, Int(floor(√num)))
for i in 2:Int(floor(num^.25))
    if sieve[i]
	for k in 0:num
	    j = i^2 + k*i
	    if j ≤ Int(floor(√num))
		sieve[j] = false
	    else
		break
	    end
	end
    end
end

primes = Int32[]
for i in 2:Int(floor(√num))
    if sieve[i]
	push!(primes, i)
    end
end

for prime in sort(primes, rev=true)
    if num % prime == 0
	println(prime)
	break
    end
end

