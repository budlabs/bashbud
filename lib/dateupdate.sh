#!/usr/bin/env bash

dateupdate(){

  local f bump

  f="${!#:-}"
  bump=0

  [[ -f $f ]] && [[ manifest.md = "${f##*/}" ]] && {

    while getopts cub option; do
      case "${option}" in
        c ) dtu+=("created") ;;
        u ) dtu+=("updated") ;;
        b ) bump=1 ;;
        *) exit 1 ;;
      esac
    done

    trg=${#dtu[@]}
    ((trg>1)) \
      && srch="^created:$|^updated:$" \
      || srch="^${dtu[0]}:\$"


    awk \
      -i inplace \
      -v bump="$bump" \
      -v today="$(date +"${BASHBUD_DATEFORMAT}")" \
      -v trg="$trg" \
      -v srch="$srch" '
        bump == 1 && $1 == "version:" {
          newver=$2 + 0.001
          sub($2,newver,$0)
          bump=0
        }
        fnd != trg && $1 ~ srch {sub($2,today,$0);fnd++}
        {print}
    ' "$f"
  }

}
