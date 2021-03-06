#= 
Each new term in the Fibonacci sequence is generated by adding the previous 
two terms. By starting with 1 and 2, the first 10 terms will be: 
1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
By considering the terms in the Fibonacci sequence whose values do not exceed 
four million, find the sum of the even-valued terms. 
=# 

# Naive 
limit = 4000000
total = 0
prev = 0
curr = 1
while curr ≤ limit
    if curr % 2 == 0
	global total += curr 
    end
    global prev, curr = curr, prev + curr
end
println(total)

# Every 3rd Fibonacci number is even so let's only calculate those 
total = 0 
prev = 1
curr = 2
while curr ≤ limit
    global total += curr 
    # Calculate next even number 
    global prev, curr = prev + 2curr, 2prev + 3curr
end
println(total)
