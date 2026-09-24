local sha1=require("sha1")
local function sign(key,domain,payload) return sha1.hmac_binary(key,domain.."\0"..payload) end
local function rot(value,distance,key) if value:find("%z") then error("ROT input contains NUL") end; local d=((distance%26)+26)%26; return (value:gsub("[A-Za-z]",function(c)local o=c:byte();local b=o<=90 and 65 or 97;return string.char(b+(o-b+d)%26)end)) end
local function rotn(value,distance,key) sign(key,"ROT-STRING",value);sign(key,"ROT-INTEGER",tostring(distance));return rot(value,distance,key) end
local function rot13(value,key)return rotn(value,13,key) end
local function ebg13(value,key)return rotn(value,-13,key) end
local function sha9001(data) local digest=data;for _=1,9001 do digest=sha1.binary(digest) end;return digest end
return {sha9001=sha9001,rot13=rot13,ebg13=ebg13,rotn=rotn}
