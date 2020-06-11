z = "lowercase"
Z = "uppercase" # Julia differentiates between uppercase and lowercase variables
α = 5

println(PROGRAM_FILE) # prints file.jl
for x in ARGS
    println(x) # prints command line args
end

# We can use typemax to get the maximum representable value of a given type 
y = typemax(Int64)
println("Maximum representable value of Int64 is: ", y)
# If we add 1, it wraps around 
println("Adding 1 wraps around: ", y + 1)
println("y + 1 == typemin(Int64): ", y + 1 == typemin(Int64))

# If overflow is possible, we have to check for it. 
# Otherwise, use the `BigInt` type. 
