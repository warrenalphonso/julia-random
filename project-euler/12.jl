#=
What is the value of the first triangle number to have over five hundred divisors?
=#
import Base.Iterators
import Primes

# Naive: compute each triangular number and count its factors
triangular_number = 0
for i in Iterators.countfrom(1)
    global triangular_number += 1
    factors =
end