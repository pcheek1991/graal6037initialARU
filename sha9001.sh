#!/usr/bin/env sh
set -eu
sha9001_file() {
  file=$1; i=0
  digest=$(sha1sum "$file" | awk '{print $1}')
  while [ "$i" -lt 9000 ]; do
    digest=$(printf '%s' "$digest" | xxd -r -p | sha1sum | awk '{print $1}')
    i=$((i + 1))
  done
  printf '%s\n' "$digest"
}
[ "$#" -eq 1 ] || { printf 'usage: %s FILE\n' "$0" >&2; exit 2; }
sha9001_file "$1"
