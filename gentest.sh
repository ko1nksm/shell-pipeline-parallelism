#!/bin/sh

file=${1:-example.json}
num=${2:-10}

json="$(cat "$file")"
i=0

echo "["
while [ "$i" -lt "$num" ]; do
  [ "$i" -gt 0 ] && echo ","
  printf '%s\n' "$json"
  i=$((i + 1))
done
echo "]"
