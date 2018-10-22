#!/usr/bin/env bash

listprojects(){
  local mode

  OFS="${IFS}"
  IFS=: ; for d in ${BASHBUD_PROJECTS_PATH//'~'/$HOME}; do
    [[ -d $d ]] && for dd in "${d}"/*; do
      [[ ! -d $dd ]] && continue
      if [[ -f "${dd}/lib/base.sh" ]]; then
        if [[ -f "${dd}/lib/base.dev" ]]; then
          mode=develop
        else
          mode=private
        fi
        printf '%-12s  %-10s  %s\n' "${dd##*/}" "$mode" "${dd/$HOME/'~'}"
      fi
    done
  done
  IFS="${OFS}"
}
