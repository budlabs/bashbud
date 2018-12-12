#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

main(){
  local trgdir

  IFS=$'\n\t'


  if [[ ${__o[new]:-} = 1 ]]; then
    case $# in
      1 ) ERX "no directory specified" ;;
      3 ) newproject2 "$1" ;;
    esac
  elif [[ -n ${__o[bump]:-} ]]; then
    bumpproject "${__o[bump]}"
  elif [[ -z ${__o[*]:-} ]] && [[ -z "${__lastarg:-}" ]]; then
    listprojects
  elif [[ -n ${__o[lorem]:-} ]]; then
    letslorem "${__o[lorem]}"
  else
    ___printhelp
    exit
  fi
}

source init.sh #bashbud
main "${@:-}" #bashbud
