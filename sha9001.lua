-- SHA-9001 plus Lua _G-compatible DIM/MID runtime registry.
local sha1 = require("sha1")
local function rot13(s) return (s:gsub("[A-Za-z]", function(c) local base=(c:byte()<=90) and 65 or 97; return string.char(base+(c:byte()-base+13)%26) end)) end
local function sha9001(data, filename)
  local digest=data
  for n=1,9001 do digest=sha1.binary(digest); local h=sha1.hex(digest); _G["DIM "..filename]=h; _G["MID "..filename..":"..n]=rot13(h) end
  return digest
end
return { sha9001=sha9001, rot13=rot13 }
