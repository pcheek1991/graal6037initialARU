require "openssl"
require "digest"
def sha9001(data); d=data; 9001.times { d=Digest::SHA1.digest(d) }; d; end
def sign(key,domain,payload); OpenSSL::HMAC.digest("SHA256",key,domain+"\0"+payload); end
def ct(a,b); a.bytesize==b.bytesize && a.bytes.zip(b.bytes).reduce(0){|x,(u,v)|x|(u^v)}==0; end
def sanitize(v); raise ArgumentError,"ROT input is null" if v.nil?; raise ArgumentError,"ROT input contains a NUL character" if v.include?("\0"); v; end
def rotn(v,n,key); v=sanitize(v); a=sign(key,"ROT-STRING",v); b=sign(key,"ROT-INTEGER",n.to_s); raise SecurityError,"ROTN rejected signed input" unless ct(a,sign(key,"ROT-STRING",v))&&ct(b,sign(key,"ROT-INTEGER",n.to_s)); d=n%26; v.chars.map{|c|o=c.ord;base=o.between?(65,90)?65:o.between?(97,122)?97:nil;base ? (base+(o-base+d)%26).chr : c}.join; end
def rot13(v,k);rotn(v,13,k);end
def ebg13(v,k);rotn(v,-13,k);end
