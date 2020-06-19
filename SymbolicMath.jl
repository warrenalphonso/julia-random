### A Pluto.jl notebook ###
# v0.9.10

using Markdown

# ╔═╡ ba32ace0-b264-11ea-207f-89236fda980e
using SymPy

# ╔═╡ 308df070-b26a-11ea-08ec-d972de9432ce
using Plots

# ╔═╡ df8c1094-b269-11ea-37ff-43c9cb38e61b
md"""
# Symbolic computing in Julia 
"""

# ╔═╡ 6abc7c6c-b265-11ea-0b37-9762635eb4f3
# Instantiate x as a symbolic variable
@vars x,y

# ╔═╡ 9351bc80-b265-11ea-0d3f-d942f5d39eea
# We can pass symbolic variables into functions
begin 
	f(x) = exp(-x^2 / 2)
	f(x)
end

# ╔═╡ b3df965e-b265-11ea-010c-0b246d0f19fd
# We can substitute a value for a symbol like so
begin 
	g = exp(-x^2 / 2) # This is NOT a function! It's a symbolic expression with x
	g(x=>1) # Subbing in 1 for x 
end

# ╔═╡ e093f816-b265-11ea-1b49-dbcd6c2dd1f3
# But even when we sub in a value for a symbol, we still have a "symbolic expression"
typeof( g(x=>1) )

# ╔═╡ 3978e3c4-b266-11ea-3d42-cd1a4dde28aa
# To get the `julia` version of a symbolic expression, use the function `N`
N( g(x=>1) )

# ╔═╡ 1b2565f6-b26a-11ea-1e9f-bfd1b9ce4129
md"""
## Simplifying and solving complex equations 
"""

# ╔═╡ 4f28a100-b266-11ea-2bd6-fddbad462fc2
# SymPy can simplify terms 
(x+1) + (x+2) + (x+3)

# ╔═╡ 6b7eac80-b268-11ea-38b8-136059656d36
sin(x)^2 + cos(x)^2

# ╔═╡ 77252b04-b268-11ea-201d-556c4bdf1bd5
# To fully simplify, use the `simplify` function
simplify( sin(x)^2 + cos(x)^2 )

# ╔═╡ 81dbe2b8-b268-11ea-29c5-25e73840a3f5
p = expand( (x-1)*(x-2)*(x-3)*(x^2 + x + 1) )

# ╔═╡ a17979a8-b268-11ea-030e-4bb2f5a25641
# SymPy can factor 
factor(p)

# ╔═╡ aa40a022-b268-11ea-2e1e-ed0d9343ce44
# SymPy can find the roots 
roots(p)

# ╔═╡ e35507cc-b268-11ea-2daa-53547a519a0b
# To solve for one variable with another one we can specify it in the `solve` function 
out = solve( x^2 + y^2 -1, y )

# ╔═╡ 234dd9f8-b269-11ea-113f-271674b6d73b
# This solves it symbolically. Let's evaluate it at x = 1/2
subs.(out, x, 1/2)

# ╔═╡ 4a093616-b269-11ea-1b66-2f522a1eaf87
# Solving system of equations 
begin 
	eq1 = x+y-1
	eq2 = x-y+1
	solve([eq1, eq2], [x,y])
end

# ╔═╡ 64cf12ac-b269-11ea-13ed-7557ad62606f
N(solve( exp(x) - x^4, x ))

# ╔═╡ 278c6dec-b26a-11ea-32c2-1595d00e00cc
md"""
## Graphing symbolic expressions 
"""

# ╔═╡ 345f0392-b26a-11ea-274a-893ca0aa4b05
plot(x^2-2x+3, -1, 3)

# ╔═╡ 3e8ceda2-b26a-11ea-19d4-4dcd2866eb8e
md"""
## Evaluating the limit of expressions
"""

# ╔═╡ 4d1f0fee-b26a-11ea-242d-0b0772845d7d
# The `limit` function has 3 inputs: the function to compute the limit of, the variable
# whose limit is being taken, and the value the limit tends toward
limit( sin(x)/x, x, 0)

# ╔═╡ 8322daf8-b26a-11ea-0043-9f6b4a5b422e
# To specify infinity, use oo
limit( 1/x, x, oo )

# ╔═╡ 5ffa992e-b26c-11ea-00de-4f4a35f3fe90
# Find the limit of the following function as x goes to 0
h(x) = 1/( x^(log(log(log(log(1/x)))) - 1))

# ╔═╡ d9df8dd0-b26c-11ea-230e-d1c7157e9d0b
# First we'll do it numerically - seems to be going to 0
begin
	xs = (0.1).^(10:20)
	fxs = map(h, xs)
	[xs fxs]
end

# ╔═╡ f9dfd23e-b26c-11ea-296d-0ff6ae30dd8a
# Now we'll do it symbolically - we get ∞ !
limit( h, x, 0 )

# ╔═╡ 51dd7cfc-b26d-11ea-1281-e74ad3214210
md"""
## Derivatives 
"""

# ╔═╡ 8b541784-b26d-11ea-008c-7987858201a7
# The `diff` function has inputs: symbolic expression to differentiate, variable to 
# differentiate, and an optional integer for number of derivatives 
j = exp(exp(x))

# ╔═╡ aa8e6aa0-b26d-11ea-371c-9163d49e8d79
diff(j, x)

# ╔═╡ ad429c4e-b26d-11ea-3ca5-f95781821d39
diff(j, x, 3)

# ╔═╡ b110b702-b26d-11ea-2f5f-c59e5cf7a3f7
# SymPy can do integratin too, but it's not as powerful as other libraries

# ╔═╡ Cell order:
# ╟─df8c1094-b269-11ea-37ff-43c9cb38e61b
# ╠═ba32ace0-b264-11ea-207f-89236fda980e
# ╠═6abc7c6c-b265-11ea-0b37-9762635eb4f3
# ╠═9351bc80-b265-11ea-0d3f-d942f5d39eea
# ╠═b3df965e-b265-11ea-010c-0b246d0f19fd
# ╠═e093f816-b265-11ea-1b49-dbcd6c2dd1f3
# ╠═3978e3c4-b266-11ea-3d42-cd1a4dde28aa
# ╟─1b2565f6-b26a-11ea-1e9f-bfd1b9ce4129
# ╠═4f28a100-b266-11ea-2bd6-fddbad462fc2
# ╠═6b7eac80-b268-11ea-38b8-136059656d36
# ╠═77252b04-b268-11ea-201d-556c4bdf1bd5
# ╠═81dbe2b8-b268-11ea-29c5-25e73840a3f5
# ╠═a17979a8-b268-11ea-030e-4bb2f5a25641
# ╠═aa40a022-b268-11ea-2e1e-ed0d9343ce44
# ╠═e35507cc-b268-11ea-2daa-53547a519a0b
# ╠═234dd9f8-b269-11ea-113f-271674b6d73b
# ╠═4a093616-b269-11ea-1b66-2f522a1eaf87
# ╠═64cf12ac-b269-11ea-13ed-7557ad62606f
# ╟─278c6dec-b26a-11ea-32c2-1595d00e00cc
# ╠═308df070-b26a-11ea-08ec-d972de9432ce
# ╠═345f0392-b26a-11ea-274a-893ca0aa4b05
# ╟─3e8ceda2-b26a-11ea-19d4-4dcd2866eb8e
# ╠═4d1f0fee-b26a-11ea-242d-0b0772845d7d
# ╠═8322daf8-b26a-11ea-0043-9f6b4a5b422e
# ╠═5ffa992e-b26c-11ea-00de-4f4a35f3fe90
# ╠═d9df8dd0-b26c-11ea-230e-d1c7157e9d0b
# ╠═f9dfd23e-b26c-11ea-296d-0ff6ae30dd8a
# ╟─51dd7cfc-b26d-11ea-1281-e74ad3214210
# ╠═8b541784-b26d-11ea-008c-7987858201a7
# ╠═aa8e6aa0-b26d-11ea-371c-9163d49e8d79
# ╠═ad429c4e-b26d-11ea-3ca5-f95781821d39
# ╠═b110b702-b26d-11ea-2f5f-c59e5cf7a3f7
