# SHA-9001 Awk wrapper. Requires sha1sum and xxd.
# Awk itself is text-oriented, so binary preservation is delegated to the tools.
BEGIN {
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
