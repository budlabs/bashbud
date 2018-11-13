#!/usr/bin/env bash

listprojects(){
  local mode

  OFS="${IFS}"
  IFS=: ; for d in ${BASHBUD_PROJECTS_PATH//'~'/$HOME}; do
    [[ -d $d ]] && for dd in "${d}"/*; do
      [[ -f "${dd}/lib/base.sh" ]] || continue
      printf '%-12s  %s\n' "${dd##*/}" "${dd/$HOME/'~'}"
    done
  done
  IFS="${OFS}"
}
