#!/usr/bin/env bash

# --get|-g KEY [PROJECT_DIR]
getkey(){

  local found
  local key="$1"
  local projectdir="${2/'~'/$HOME}"

  [[ -f "$projectdir/manifest.md" ]] \
    || ERX "$projectdir doesn't contain manifest.md"

  found="$(awk -v key="$key" '
    $1 ~ key ":" {print gensub($1 "\\s*","","g",$0)}
    /^[.]{3}$/ {exit}
    ' "$projectdir/manifest.md"
  )"

  [[ -n $found ]] \
    && echo "$found" \
    || return 1
}
