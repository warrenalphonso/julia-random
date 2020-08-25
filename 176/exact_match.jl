unused_char = '0'

function z_score(i::Int, S::String)
    """
    Define the z-score of an index i of string S, Z_i (S), to be the length of
    the longest substring starting at index i that is a prefix of S.

    Calculates the z-score at index i by direct comparison.
    """
    count = 0
    while length(S) >= count + i && S[count + 1] == S[count + i]
        count += 1
    end
    return count
end

function z_algorithm(S::String)
    """
    For i such that Z_i (S) > 0, define its z-box as the interval that starts
    at i and ends at i + Z_i (S) - 1, inclusive. Thus, each substring prefix
    defines a z-box.

    Define the rightmost z-box as the z-box with the rightmost end index.

    Calculates the z-scores for i = 2:|S|.
    """
    z_scores = Int[]
    push!(z_scores, 0) # So z_j = z_scores[j]
    l,r = 0, 0
    for i in 2:length(S)
        z_i = 0
        if i > r
            z_i = z_score(i, S)
        else
            B = S[i:r]
            j = i - l + 1
            z_j = z_scores[j]
            if z_j < length(B)
                z_i = z_j
            elseif z_j > length(B)
                z_i = length(B)
            else
                # Start comparisons after initial substring
                # extra = 0
                # while length(S) >= r + 1 + extra && S[r + 1 + extra] == S[length(B) + extra]
                #     extra += 1
                # end
                # z_i = length(B) + extra

                z_i = length(B) 
                while length(S) >= i + z_i && S[i + z_i] == S[1 + z_i]
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

function exact_matches(P::String, T::String)
    """
    To find the matches of pattern P in text T, we can create a combined string
    PXT, where X is a character not in P or T. Then we call z_algorithms on PXT.
    All the substrings with length |P| are exact matches of P in T.
    """
    S = P * unused_char * T
    z_scores = z_algorithm(S)
    return length( filter(x -> x == length(P), z_scores) )
end

exact_matches("axyaxz", "xaxyaxyaxz")
