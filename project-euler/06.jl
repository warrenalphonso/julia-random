#=
The sum of the squares of the first ten natural numbers is 385.
The square of the sum of the first ten natural numbers is 3025, so the difference
is 2640.
Find the difference between the sum of the squares of the first hundred natural
numbers and the square of the sum.
=#

# Naive - 0.00008 seconds
function naive()
    sum_squares = 0
    for i in 1:100
        sum_squares += i^2
    end
    println(sum(1:100)^2 - sum_squares)
end

@time naive()

# Slightly faster using sum of arithmetic sequence - about the same time
function arithmetic_series()
    sum_squares = 0
    for i in 1:100
        sum_squares += i^2
    end
    println((101 / 2 * 100)^2 - sum_squares)
end

@time arithmetic_series()

# Try using types - about the same. Probably because we already use a Int64
function types()
    sum_squares::Int32 = 0
    for i::Int32 in 1:100
        sum_squares += i^2
    end
    println(sum(1:100)^2 - sum_squares)
end

@time types()
