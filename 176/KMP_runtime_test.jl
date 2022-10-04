include("./KMP.jl")
using .KMP

# Defining a naive string search algorithm 
function naive(P::String, T::String)
    count = 0
    for i in 1:length(T)-length(P)
        found = true
        for j in 1:length(P)
            if P[j] != T[i+j]
                found = false
                break
            end
        end
        if found
            count += 1
        end
    end
end

#=
I'm using the Wuhan-Hu-1 genome from https://www.ncbi.nlm.nih.gov/nuccore/MN908947.3
after reading this blog post: https://csvoss.com/a-mechanists-guide-to-the-coronavirus-genome
=#
f = open("./176/data/WuhanHu1.txt")
genome = read(f, String)
# Remove spaces and newlines 
genome = filter(c -> c != ' ' && c != '\n' && tryparse(Int, string(c)) == nothing, genome)
# This is an RNA virus so T -> U
genome = map(c -> c == 't' ? 'u' : c, genome)
genome = uppercase(genome)
# Genome was missing one tiny "A" which took me like 2 hours to figure out!!
y = 4402
genome = genome[1:266+3*(y-1)-1] * "A" * genome[266+3*(y-1):end]


#= 
The Orf1ab protein is known to be present in this strand. Its amino acid 
sequence is in data/Orf1ab.txt, but we'll need a codon -> amino acid mapping.
I'll make this myself by using https://en.wikipedia.org/wiki/Genetic_code#RNA_codon_table
=#
codon_lookup = Dict(
    "UUU" => 'F',
    "UUC" => 'F',
    "UUA" => 'L',
    "UUG" => 'L',
    "CUU" => 'L',
    "CUC" => 'L',
    "CUA" => 'L',
    "CUG" => 'L',
    "AUU" => 'I',
    "AUC" => 'I',
    "AUA" => 'I',
    "AUG" => 'M',
    "GUU" => 'V',
    "GUC" => 'V',
    "GUA" => 'V',
    "GUG" => 'V', "UCU" => 'S',
    "UCC" => 'S',
    "UCA" => 'S',
    "UCG" => 'S',
    "CCU" => 'P',
    "CCC" => 'P',
    "CCA" => 'P',
    "CCG" => 'P',
    "ACU" => 'T',
    "ACC" => 'T',
    "ACA" => 'T',
    "ACG" => 'T',
    "GCU" => 'A',
    "GCC" => 'A',
    "GCA" => 'A',
    "GCG" => 'A', "UAU" => 'Y',
    "UAC" => 'Y',
    "UAA" => "?",
    "UAG" => '?',
    "CAU" => 'H',
    "CAC" => 'H',
    "CAA" => 'Q',
    "CAG" => 'Q',
    "AAU" => 'N',
    "AAC" => 'N',
    "AAA" => 'K',
    "AAG" => 'K',
    "GAU" => 'D',
    "GAC" => 'D',
    "GAA" => 'E',
    "GAG" => 'E', "UGU" => 'C',
    "UGC" => 'C',
    "UGA" => '?',
    "UGG" => 'W',
    "CGU" => 'R',
    "CGC" => 'R',
    "CGA" => 'R',
    "CGG" => 'R',
    "AGU" => 'S',
    "AGC" => 'S',
    "AGA" => 'R',
    "AGG" => 'R',
    "GGU" => 'G',
    "GGC" => 'G',
    "GGA" => 'G',
    "GGG" => 'G'
)

# Convert RNA into amino acid sequence 
function RNA_to_amino_acids(rna::String)
    amino_acids = ""
    for i in 2:3:length(rna)-2
        codon = uppercase(rna[i:i+2])
        amino_acids *= codon_lookup[codon]
    end
    return amino_acids
end

genome_amino_acids = RNA_to_amino_acids(genome)

const const_genome_amino_acids = genome_amino_acids

f = open("./176/data/Orf1ab.txt")
Orf1ab = read(f, String)
Orf1ab = filter(c -> c != ' ' && c != '\n' && tryparse(Int, string(c)) == nothing, Orf1ab)
Orf1ab = uppercase(Orf1ab)

const const_orf = Orf1ab

#  0.000021 seconds (3 allocations: 160 bytes)
@time findfirst(Orf1ab, genome_amino_acids)
#  0.000336 seconds (13 allocations: 476.656 KiB)
@time KMP.exact_matches(Orf1ab, genome_amino_acids)
#  0.010610 seconds
@time naive(Orf1ab, genome_amino_acids)

# Well, KMP did terribly. Wow, Julia's native string search is really good!

using Profile
using ProfileView
Profile.clear()
@profile KMP.exact_matches(Orf1ab, genome_amino_acids)
@profile naive(Orf1ab, genome_amino_acids)
ProfileView.view()