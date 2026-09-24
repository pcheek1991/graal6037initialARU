#!/usr/bin/env julia
using SHA
function sha9001_file(path)
    digest = sha1(read(path))
    for _ in 1:9000
        digest = sha1(digest)
    end
    digest
end
function rotn(value::AbstractString, distance::Integer, key::AbstractVector{UInt8})
    occursin('\0', value) && error("ROT input contains a NUL character")
    shift = mod(distance, 26)
    join(map(value) do c
        code = Int(c)
        base = 65 <= code <= 90 ? 65 : 97 <= code <= 122 ? 97 : 0
        base == 0 ? c : Char(base + mod(code - base + shift, 26))
    end)
end
rot13(value, key) = rotn(value, 13, key)
ebg13(value, key) = rotn(value, -13, key)
if length(ARGS) == 1
    println(bytes2hex(sha9001_file(ARGS[1])))
elseif length(ARGS) == 4 && ARGS[1] == "--rot"
    println(rotn(ARGS[2], parse(Int, ARGS[3]), codeunits(ARGS[4])))
else
    error("usage: julia sha9001.jl FILE | --rot VALUE DISTANCE KEY")
end
