### A Pluto.jl notebook ###
# v0.9.9

using Markdown

# ╔═╡ 565a38e4-af5a-11ea-2d28-e712da830606
using LinearAlgebra

# ╔═╡ 11fd69f6-af59-11ea-0616-5bff9e145cb3
const a = 5 + 3im

# ╔═╡ 3440a302-af59-11ea-1c9d-4d205cfd902f
a' # Adjoint

# ╔═╡ 61800c4a-af59-11ea-0711-4d6fcddaadec
b = (a=3, b=3)

# ╔═╡ a0553f4e-af59-11ea-304f-05d4d9ee6f65
b.a

# ╔═╡ 596e902a-af5a-11ea-082b-b1153fcc9539
c = [1. 2.; 3. 4]

# ╔═╡ 6c06d6ca-af5a-11ea-1c39-c972b4a5773f
qr(c)

# ╔═╡ Cell order:
# ╠═11fd69f6-af59-11ea-0616-5bff9e145cb3
# ╠═3440a302-af59-11ea-1c9d-4d205cfd902f
# ╠═61800c4a-af59-11ea-0711-4d6fcddaadec
# ╠═a0553f4e-af59-11ea-304f-05d4d9ee6f65
# ╠═565a38e4-af5a-11ea-2d28-e712da830606
# ╠═596e902a-af5a-11ea-082b-b1153fcc9539
# ╠═6c06d6ca-af5a-11ea-1c39-c972b4a5773f
