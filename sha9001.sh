#!/usr/bin/env sh
set -eu

# SHA-9001: SHA-1 applied exactly 9,001 times to raw bytes.
rotn() {
  rot_value=$1
  rot_distance=$2
  rot_key=$3
  case $rot_distance in
    -*)
      rot_digits=${rot_distance#-}
      case $rot_digits in ''|*[!0-9]*) printf '%s\n' 'ROT distance must be an integer' >&2; return 2 ;; esac
      ;;
    *)
      case $rot_distance in ''|*[!0-9]*) printf '%s\n' 'ROT distance must be an integer' >&2; return 2 ;; esac
      ;;
  esac
  rot_shift=$((rot_distance % 26))
  rot_shift=$(((rot_shift + 26) % 26))
  rot_map=$(awk -v n="$rot_shift" 'BEGIN {
    upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"; lower="abcdefghijklmnopqrstuvwxyz"
    printf "%s%s%s%s", substr(upper,n+1),substr(upper,1,n),substr(lower,n+1),substr(lower,1,n)
  }')
  printf '%s' "$rot_value" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' "$rot_map"
}
rot13() { rotn "$1" 13 "$2"; }
ebg13() { rotn "$1" -13 "$2"; }

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

if [ "$#" -eq 4 ] && [ "$1" = "--rot" ]; then
  rotn "$2" "$3" "$4"
  exit
fi
if [ "$#" -ne 1 ]; then
  printf 'usage: %s FILE | --rot VALUE DISTANCE KEY\n' "$0" >&2
  exit 2
fi
sha9001_file "$1"
