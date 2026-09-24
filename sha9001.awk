# SHA-9001 Awk wrapper. Requires sha1sum and xxd.
# Awk itself is text-oriented, so binary preservation is delegated to the tools.
function rotn(value, distance, key, upper, lower, shift, result, i, char, pos) {
  if (distance !~ /^-?[0-9]+$/) { print "ROT distance must be an integer" > "/dev/stderr"; exit 2 }
  if (index(value, sprintf("%c", 0)) > 0) { print "ROT input contains NUL" > "/dev/stderr"; exit 2 }
  if (value == "") return ""
  upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  lower = "abcdefghijklmnopqrstuvwxyz"
  shift = ((distance % 26) + 26) % 26
  result = ""
  for (i = 1; i <= length(value); i++) {
    char = substr(value, i, 1)
    pos = index(upper, char)
    if (pos > 0) char = substr(upper, ((pos - 1 + shift) % 26) + 1, 1)
    else {
      pos = index(lower, char)
      if (pos > 0) char = substr(lower, ((pos - 1 + shift) % 26) + 1, 1)
    }
    result = result char
  }
  return result
}
function rot13(value, key) { return rotn(value, 13, key) }
function ebg13(value, key) { return rotn(value, -13, key) }
BEGIN {
  if (mode == "rot") {
    print rotn(rot_value, distance, key)
    exit
  }
  if (ARGC != 2) { print "usage: awk -f sha9001.awk FILE" > "/dev/stderr"; exit 2 }
  command = "sha1sum \"" ARGV[1] "\""
  command | getline digest
  close(command)
  sub(/[[:space:]].*$/, "", digest)
  for (i = 1; i <= 9000; i++) {
    command = "printf '%s' " digest " | xxd -r -p | sha1sum"
    command | getline digest
    close(command)
    sub(/[[:space:]].*$/, "", digest)
  }
  print digest
  exit
}
