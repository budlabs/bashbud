#!/usr/bin/env bash

# --set|-s KEY VALUE [PROJECT_DIR]
setkey(){

  local key="$1"
  local value="$2"
  local projectdir="${3/'~'/$HOME}"

  [[ -f "$projectdir/manifest.md" ]] \
    || ERX "$projectdir doesn't contain manifest.md"


  awk -i inplace -v key="$key" -v val="$value" '
    $1 ~ key ":" {
      $0=gensub(/(.+:\s*)(.+)/,"\\1" val,"g",$0)
    }
    {print}
    ' "$projectdir/manifest.md"
}
