Here's where I am right now: 

```julia
# I ran these multiple times so not profiling the JIT

#  0.000021 seconds (3 allocations: 160 bytes)
@time findfirst(Orf1ab, genome_amino_acids)
#  0.242043 seconds (7.12 k allocations: 25.287 MiB, 1.88% gc time)
@time KMP.exact_matches(Orf1ab, genome_amino_acids)
#  0.010610 seconds
@time naive(Orf1ab, genome_amino_acids)
```

I won't look at the actual algorithms yet. Let's just profile to figure out what's
slow. Let's use `ProfileView` flamegraph.

Lots of time calculating z scores, ie actually calling `z_score(i, S)`. And this
function is spending all of its time calling `length(S)`. I added a new parameter
`len` to `z_algorithm` and `z_score` and calculated `len` once in `exact_matches`, 
and now we're at `0.084681 seconds`. So I should add length to the string type?
Or how else should this be done...? We don't want to have to re-compile. I guess
it's fine.

Trying to implement custom String struct which stores length, but I couldn't figure
out what the interface to `AbstractString` was, so never mind.

Also does `const` matter? Are strings mutable in Julia? No, they're not mutable
but `const` still matters because it means Julia doesn't need to keep doing type
checks.

Okay so now: 

- `B = S[i:r]` is taking up an 1/8 of execution
- `length(B)` is taking up a bit more. Don't need to calculate this since we sliced
  so we know the length!
- And `filter(x -> x == length(P), z_scores)` is taking very long. Maybe it's
  re-computing `length(P)` each time!

Fixing the two `length()` calls gets me to 0.005 seconds!

Now, use views for strings. I think we're making copies if we just index. See
`SubString`.

Okay, after using `SubString` I'm at 0.0003 seconds. Holy crap. Awesome! It's so
fast that `ProfileView` doesn't get any samples :)