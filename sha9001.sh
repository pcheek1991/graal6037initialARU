#!/usr/bin/env sh
set -eu

# SHA-9001: SHA-1 applied exactly 9,001 times to raw bytes.
sha9001_file() {
  file=$1
  i=0
  digest=$(sha1sum "$file" | awk '{print $1}')
  while [ "$i" -lt 9000 ]; do
    digest=$(printf '%s' "$digest" | xxd -r -p | sha1sum | awk '{print $1}')
    i=$((i + 1))
  done
  printf '%s\n' "$digest"
}

if [ "$#" -ne 1 ]; then
  printf 'usage: %s FILE\n' "$0" >&2
  exit 2
fi
sha9001_file "$1"
