using BioSequences

# 4^3 = 64 codons, so each codon will be an on-bit in UInt64
struct CodonSet <: AbstractSet{RNACodon}
    x::UInt64
end

CodonSet() = CodonSet(UInt64(0))

# Since each codon will have one bit on
Base.length(x::CodonSet) = count_ones(x.x)

# To add a codon, we convert to an integer and set its nth bit
function push(s::CodonSet, x::RNACodon)
    bits_shifted = reinterpret(UInt64, x) & 63 # Shift by at most 63
    CodonSet(s.x | (Uint64(1) << bits_shifted))
end

Base.in(c::RNACodon, s::CodonSet) = isodd(s.x >>> (reinterpret(UInt64, c) & 63))

x = CodonSet(55);
# @code_native debuginfo=:none push(x, mer"AAA"r)

function Base.iterate(x::CodonSet, s::UInt64=x.x)
    iszero(s) ? nothing : (reinterpret(RNACodon, trailing_zeros(s)), s % (s - 1))
end

CodonSet(itr) = foldl(push, itr, init=CodonSet())

function Base.union(a::CodonSet, b::Vararg{CodonSet})
    mapreduce(i -> i.x, |, b, init=a.x)
end

for (name, f) in [(:union, |), (:intersect, &), (:symdiff, ⊻)]
    @eval function Base.$(name)(a::CodonSet, b::Vararg{CodonSet})
        CodonSet(mapreduce(i -> i.x, $f, b, init=a.x))
    end
end

Base.setdiff(a::CodonSet, b::Vararg{CodonSet}) = CodonSet(a.x & ~(union(b...).x))

Base.isempty(s::CodonSet) = iszero(s.x)
Base.issubset(a::CodonSet, b::CodonSet) = isempty(setdiff(a, b))
delete(s::CodonSet, x::RNACodon) = setdiff(s, CodonSet((x,)))
Base.filter(f, s::CodonSet) = CodonSet(Iterators.filter(f, x))