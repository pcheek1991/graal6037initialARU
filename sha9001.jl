#!/usr/bin/env julia
using SHA
if length(ARGS) != 1
    error("usage: julia sha9001.jl FILE")
end
function sha9001_file(path)
    digest = sha1(read(path))
    for _ in 1:9000
        digest = sha1(digest)
    end
    digest
end
println(bytes2hex(sha9001_file(ARGS[1])))
