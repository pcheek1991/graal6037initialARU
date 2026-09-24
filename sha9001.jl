#!/usr/bin/env julia
using SHA
length(ARGS) == 1 || error("usage: julia sha9001.jl FILE")
digest = sha1(read(ARGS[1]))
for _ in 1:9000; digest = sha1(digest); end
println(bytes2hex(digest))
