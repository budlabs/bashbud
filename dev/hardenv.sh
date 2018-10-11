#!/bin/env bash

___hardenv(){
  local e es lst
  ((${#___environment_variables[@]}>0)) && {
    
    lst="$(
      for eo in "${!___environment_variables[@]}"; do 
        echo "$eo"
      done | sort
    )"

    for e in ${lst}; do
      es="${e#*-}"
      printf ': \"${%s:=%s}\"\n' \
        "$es" "${___environment_variables[$e]}"
    done
  }
}
