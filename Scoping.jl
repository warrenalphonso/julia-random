#=
There are 2 main scopes in Julia: global and local.
global: module, REPL,
local: for, while, try-catch-finally, let, functions,

begin and if blocks are a little weird as we'll see later.
Julia uses lexical scoping: a funcitn's scope inherits from where it was defined.
=#

for i = 1:10
    z = i
end
# z is not defined globally

for i = 1:10
    z = i
    global z
end
z  # Works - we could have switched order of z = i and global z

# Inner local scopes update their parent scopes
for i = 1:5
    z = i
    for j = 1:10
        z = 0
    end
    println(z) # Prints all 0's
end

# But we can force the inner local scope to define its own variable with `local`
for i = 1:5
    z = i
    for j = 1:10
        local z = 0
    end
    println(z) # Prints 1:5
end

# Reading global values happens automatically but we need the `global` keyword
# to write. Modifying global variables is bad practice.

# Unlike Python, nested functiosn modify parent's local variables
function yo()
    x = 5
    function hi()
        x = 10
    end
    hi()
    x
end
yo()

# The reason for this behavior is so we can have closures like so:
let state = 0
    global counter() = (state += 1)
end
counter()
counter()
state

# Let blocks allocate new variables each time they run
x, y, z = -1, -1, -1
let x = 1, z # We defined z so let won't look in global scope
    println(x)
    println(y)
    println(z) # Errors
end

# Here's an example of where we need let's scoping
Fs = Vector{Any}(undef, 2); i = 1
while i <= 2
    Fs[i] = () -> i
    global i += 1
end
# Both 3
Fs[1]()
Fs[2]()

i = 1
while i <= 2
    let i = i
        Fs[i] = () -> i
    end
    global i += 1
end
Fs[1]()
Fs[2]()

# Only use the const declaration for global variables  - it helps the compiler
# optimize. The compiler can check if local variables are constant easily so
# no need to tell it.

const a, b = 1, 2
