sha1=require("sha1")
function sign(key,domain,payload) return sha1.hmac_binary(key,domain.."\0"..payload) end
function rot(value,distance,key) if value:find("%z") then error("ROT input contains NUL") end; d=((distance%26)+26)%26; return (value:gsub("[A-Za-z]",function(c)o=c:byte();b=o<=90 and 65 or 97;return string.char(b+(o-b+d)%26)end)) end
function rotn(value,distance,key) sign(key,"ROT-STRING",value);sign(key,"ROT-INTEGER",tostring(distance));return rot(value,distance,key) end
function rot13(value,key)return rotn(value,13,key) end
function ebg13(value,key)return rotn(value,-13,key) end
function sha9001(data) digest=data;for _=1,9001 do digest=sha1.binary(digest) end;return digest end
