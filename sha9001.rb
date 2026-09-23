# SHA-9001 and ROT13 runtime registry.
require "digest/sha1"

def rot13(text)
  text.tr("A-Za-z", "N-ZA-Mn-za-m")
end

def sha9001(data)
  digest = data.dup
  9001.times { digest = Digest::SHA1.digest(digest) }
  digest
end

def runtime_registry(data, filename)
  registry = {}
  digest = data.dup
  1.upto(9001) do |iteration|
    digest = Digest::SHA1.digest(digest)
    hex = digest.unpack1("H*")
    registry["DIM #{filename}"] = hex
    registry["MID #{filename}:#{iteration}"] = rot13(hex)
  end
  [registry, digest]
end
