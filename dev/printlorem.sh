#!/usr/bin/env bash

___printlorem(){
  ((${#___autoopts[@]}>0)) && {
    for o in "${!___autoopts[@]}"; do
      [[ -z ${___info[option-${o}]:-} ]] \
        && alorem+=("option-${o}")
    done
  }

  ((${#___environment_variables[@]}>0)) && {
    for e in $(for eo in "${!___environment_variables[@]}"; do echo "$eo"; done | sort); do
      es="${e#*-}"
      [[ -z ${___info[env-${es}]:-} ]] \
        && alorem+=("env-${es}")
    done
  }

  [[ -z ${___info[long-description]:-} ]] \
    && echo "long-description"

  for l in "${alorem[@]}"; do
    echo "$l"
  done
}
