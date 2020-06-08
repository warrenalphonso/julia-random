### A Pluto.jl notebook ###
# v0.9.4

using Markdown

# ╔═╡ f2ada1c0-a953-11ea-0717-4d51340b3186
md"""
# Tasks 

Tasks allow us to suspend execution of some computation and start another, with the ability to pick up where we left off at. 

Unlike functions:

1. Switching tasks doesn't use any space so we can "nest" many switches without using up lots of the stack. 
2. Switching can occur in any order unlike functions which have to finish calling to return control to the caller. 

Julia gives us a `Channel` constructor which returns a FIFO queue. We'll create a "producer task" which produces values via `put!`, which adds values to a `Channel` then waits for another task, and `take!` which gets contents of an `IOBuffer`. 
"""

# ╔═╡ 0a1aeb6c-a954-11ea-1968-f7cddf9aea8a
function producer(c::Channel)
	put!(c, "start")
	for n=1:4
		put!(c, 2n)
	end
	put!(c, "stop")
end

# ╔═╡ 5eee54fa-a955-11ea-37ae-b9b106d40d0e
chn1 = Channel(producer)

# ╔═╡ 645fcab8-a955-11ea-04ce-c53817ae25d8
take!(chn1)

# ╔═╡ 68f2a834-a955-11ea-028c-8318df3f0b0a
take!(chn1)

# ╔═╡ 6bb05f1a-a955-11ea-2ff7-7d6008cd2111
take!(chn1)

# ╔═╡ 6f5a9240-a955-11ea-2aff-cd7d29c8ccf0
take!(chn1)

# ╔═╡ 7493d686-a955-11ea-009a-f3eb6375de59
take!(chn1)

# ╔═╡ 71acabe6-a955-11ea-299a-335fbef22468
take!(chn1)

# ╔═╡ 7a9c0e66-a955-11ea-182d-99009058cb76
take!(chn1)

# ╔═╡ 7cbe8784-a955-11ea-20ca-9ff03b6d35d9
md"""
`take!` and `put!` invoke `yieldto(task, value)` which switches to a different task and is the core of Task's power. 
"""

# ╔═╡ 9fdb4a72-a955-11ea-1a98-b97d847cc674


# ╔═╡ Cell order:
# ╟─f2ada1c0-a953-11ea-0717-4d51340b3186
# ╠═0a1aeb6c-a954-11ea-1968-f7cddf9aea8a
# ╠═5eee54fa-a955-11ea-37ae-b9b106d40d0e
# ╠═645fcab8-a955-11ea-04ce-c53817ae25d8
# ╠═68f2a834-a955-11ea-028c-8318df3f0b0a
# ╠═6bb05f1a-a955-11ea-2ff7-7d6008cd2111
# ╠═6f5a9240-a955-11ea-2aff-cd7d29c8ccf0
# ╠═7493d686-a955-11ea-009a-f3eb6375de59
# ╠═71acabe6-a955-11ea-299a-335fbef22468
# ╠═7a9c0e66-a955-11ea-182d-99009058cb76
# ╠═7cbe8784-a955-11ea-20ca-9ff03b6d35d9
# ╠═9fdb4a72-a955-11ea-1a98-b97d847cc674
