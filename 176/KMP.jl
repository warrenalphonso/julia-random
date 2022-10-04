module KMP
export exact_matches

const unused_char = '0'

"""
Define the z-score of an index i of string S, Z_i (S), to be the length of
the longest substring starting at index i that is a prefix of S.

Calculates the z-score at index i by direct comparison.
"""
function z_score(i::Int, S::AbstractString, len::Int)
    count = 0
    while len >= count + i && S[count+1] == S[count+i]
        count += 1
    end
    return count
end

"""
For i such that Z_i (S) > 0, define its z-box as the interval that starts
at i and ends at i + Z_i (S) - 1, inclusive. Thus, each substring prefix
defines a z-box.

Define the rightmost z-box as the z-box with the rightmost end index.

This algorithm is called the Knuth-Morris-Pratt string-searching algorithm: 
https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm

Calculates the z-scores for i = 2:|S|.
"""
function z_algorithm(S::AbstractString, len::Int)
    z_scores = Int[]
    push!(z_scores, 0) # So z_j = z_scores[j]
    l, r = 0, 0
    for i in 2:len
        z_i = 0
        if i > r
            z_i = z_score(i, S, len)
        else
            B = SubString(S, i, r)
            len_B = r - i + 1
            j = i - l + 1
            z_j = z_scores[j]
            if z_j < len_B
                z_i = z_j
            elseif z_j > len_B
                z_i = len_B
            else
                # Start comparisons after initial substring
                z_i = len_B
                while len >= i + z_i && S[i+z_i] == S[1+z_i]
                    z_i += 1
                end
            end
        end

        push!(z_scores, z_i)

        # Update l,r if needed
        if z_i > 0 && i + z_i - 1 > r
            l = i
            r = i + z_i - 1
        end
    end
    return z_scores
end

"""
To find the matches of pattern P in text T, we can create a combined string
PXT, where X is a character not in P or T. Then we call z_algorithms on PXT.
All the substrings with length |P| are exact matches of P in T.
"""
function exact_matches(P::AbstractString, T::AbstractString)
    S = P * unused_char * T
    len = length(S)
    len_P = length(P)
    z_scores = z_algorithm(S, len)
    return length(filter(x -> x == len_P, z_scores))
end
end
