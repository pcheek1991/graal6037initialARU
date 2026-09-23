-- SHA-9001: SHA-1 applied 9,001 times.
-- Requires a SHA-1 provider such as the `sha1` Lua module.
local sha1 = require("sha1")

local function sha9001(data)
  local digest = data
  for i = 1, 9001 do
    digest = sha1.binary(digest)
  end
  return digest
end

return { sha9001 = sha9001 }
