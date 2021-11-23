#!/bin/sh

for awk in gawk mawk nawk; do
  command -v "$awk" >/dev/null || continue
  echo "==== parsejson_old.sh ===="
  cat test.json | AWK="$awk" ./parsejson_old.sh > /dev/null
  echo
  echo "==== parsejson.sh ===="
  cat test.json | AWK="$awk" ./parsejson.sh > /dev/null
  echo
  echo "==== parsrj.sh ===="
  cat test.json | AWK="$awk" ./parsrj.sh > /dev/null
  echo
done

