#= 
If we list all the natural numbers below 10 that are multiples of 3 or 5, we 
get 3, 5, 6, and 9. The sum of these multiples is 23. Find the sum of all the 
multiples of 3 or 5 below 1000. 
=#

# Naive - looks at all 1000 terms
total = 0
for i in 1:999
    if i % 3 == 0 || i % 5 == 0
        global total += i
    end
end
println(total)

# Only consider the important terms - 333 + 200 + 65 terms
println(sum(0:3:999) + sum(0:5:999) - sum(0:15:999))
