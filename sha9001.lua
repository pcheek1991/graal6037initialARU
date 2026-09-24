function rot(value,distance,key) if value==nil then error("ROT input is null") end; if value:find("%z") then error("ROT input contains NUL") end; d=((distance%26)+26)%26; return (value:gsub("[A-Za-z]",function(c)o=c:byte();b=o<=90 and 65 or 97;return string.char(b+(o-b+d)%26)end)) end
function rotn(value,distance,key) if type(distance)~="number" or distance%1~=0 then error("ROT distance must be an integer") end; if type(key)~="string" then error("ROT key must be bytes") end; return rot(value,distance,key) end
function rot13(value,key)return rotn(value,13,key) end
function ebg13(value,key)return rotn(value,-13,key) end
function sha9001(data) sha1=require("sha1");digest=data;for _=1,9001 do digest=sha1.binary(digest) end;return digest end
