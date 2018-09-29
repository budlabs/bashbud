#!/bin/env bash

listprojects(){
  local mode

  OFS="${IFS}"
  IFS=:; for d in ${BASHBUD_ALL_SCRIPTS_PATH//'~'/$HOME}; do
    [[ -d $d ]] && for dd in "${d}"/*; do
      [[ ! -d $dd ]] && continue
      if [[ -f "${dd}/lib/bblib.sh" ]]; then
        if [[ -f ${dd}/${dd##*/}.dev ]]; then
          mode=public
        elif [[ -f "${dd}/lib/bblib.dev" ]]; then
          mode=private
        else
          mode=develop
        fi
        printf '%-12s  %-10s  %s\n' "${dd##*/}" "$mode" "${dd/$HOME/'~'}"
      fi
    done
  done
  IFS="${OFS}"
}
