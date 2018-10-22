#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

main(){
  local trgdir

  IFS=$'\n\t'

  if [[ -n ${__o[new]:-} ]]; then
    newproject "${__o[new]:-}"
    # trgdir="$HOME/tmp/bb2/$__new"
    
  elif [[ -n ${__o[bump]:-} ]]; then
    bumpproject "${__o[bump]}"
  elif [[ -n ${__o[mode]:-} ]]; then

    if [[ -z ${__lastarg:-} ]]; then
      setmode "${__o[mode]:-}" toggle
    else
      setmode "${__lastarg}" "${__o[mode]:-}"
    fi
    
  elif [[ -n ${__o[publish]:-} ]]; then
    publishproject
  elif [[ -z ${__o[*]:-} ]] && [[ -z "${__lastarg:-}" ]]; then
    listprojects
  elif [[ -n ${__o[lorem]:-} ]]; then
    letslorem "${__o[lorem]}"
  elif ((${__o[lib]:-0}==1)); then
    composelib "$___dir"
  fi
}
___source="$(readlink -f "${BASH_SOURCE[0]}")" #bashbud
___dir="$(cd "$(dirname "${___source}")" && pwd)" #bashbud
. "${___dir}/lib/base.sh" #bashbud
BASHBUD_PROJECTS_PATH+=":${___dir%/*}" #bashbud

main "${@:-}"
