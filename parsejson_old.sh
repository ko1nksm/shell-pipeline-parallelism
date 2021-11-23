#!/usr/bin/env bash

set -eu
export LC_ALL=C
AWK=${AWK:-awk}
{
    echo "bash version: ${BASH_VERSION:-not bash!}"
    echo "awk: $(command -v "$AWK")"
    echo ""
} >&2

tr() {
    f="${FUNCNAME[1]}        "
    TIMEFORMAT="${f:0:8} tr : real %3lR  user %3lU  sys %3lS  cpu %P%%"
    time command tr "$@"
}

awk() {
    f="${FUNCNAME[1]}        "
    TIMEFORMAT="${f:0:8} awk: real %3lR  user %3lU  sys %3lS  cpu %P%%"
    time command "$AWK" "$@"
}

tokenize() {
    tr -d '\r\n\t\v' | tr '"' '\n' | awk '
    {
        if (match($0, /(^|[^\\])(\\\\)*\\$/)) {
            printf "%s\042", $0
        } else {
            print $0
        }
    }' | awk '
    {
        if ((NR % 2) == 0) {
            print "\042" $0 "\042"
        } else {
            gsub(/[ \r\n\t\v]/, "")
            gsub(/([][{}:,]|[^][{}:,]+)/, "&\n")
            printf "%s", $0
        }
    }
    '
}

parse() {
    awk -v SEP="." -v ROOT='@' -f jsoncallbacks.awk -f jsonparser.awk
}

line=$'---------------------------------------------------------------------------\n'
TIMEFORMAT="${line}         ALL: real %3lR  user %3lU  sys %3lS  cpu %P%%"
time tokenize | parse 
