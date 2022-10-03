# Julia runtime produces LLVM intermediate representation. LLVM generates machine
# instructions from that. 
# Julia compiler is pretty normal. All it does really well is type inference so 
# that multiple dispatch works well with a dynamic language. The language's semantics
# help LLVM out a lot.