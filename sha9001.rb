require "digest"
def sha9001(data); d=data; 9001.times { d=Digest::SHA1.digest(d) }; d; end
def sanitize(v); raise ArgumentError,"ROT input is null" if v.nil?; raise ArgumentError,"ROT input contains a NUL character" if v.include?("\0"); v; end
def rotn(v,n,key); v=sanitize(v); raise TypeError,"ROT distance must be an integer" unless n.is_a?(Integer); raise TypeError,"ROT key must be bytes" unless key.is_a?(String); d=n%26; v.chars.map{|c|o=c.ord;base=o.between?(65,90)?65:o.between?(97,122)?97:nil;base ? (base+(o-base+d)%26).chr : c}.join; end
def rot13(v,k);rotn(v,13,k);end
def ebg13(v,k);rotn(v,-13,k);end
