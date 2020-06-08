#=
A palindromic number reads the same both ways. The largest palindrome made from
the product of two 2-digit numbers is 9009 = 91 × 99.
Find the largest palindrome made from the product of two 3-digit numbers.
=#

function checkPalindrome(n)
    str = "$n"
    rev = reverse(str)
    return str == rev
end

# Naive - 0.00195 seconds
function checkAll()
    max = 0
    for i in 999:-1:100
        for j in 999:-1:100
            if i*j > max && checkPalindrome(i*j)
                max = i*j
            end
        end
    end
    max
end

# Slightly less naive - can't think of a better solution - 0.000706 seconds
function breakEarly()
    max = 0
    for i in 999:-1:100
        if 999 * i < max
            break
        end
        for j in 999:-1:100
            if i * j < max
                break
            elseif checkPalindrome(i*j)
                max = i*j
            end
        end
    end
    max
end

@time checkAll()
@time breakEarly()
