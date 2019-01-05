#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

main(){

  local setval
  IFS=$'\n\t'

  # --new|-n  [GENERATOR]  **TARGET_DIR**
  if [[ ${__o[new]:-} = 1 ]]; then
    
    case $# in
      0 ) ERX "no directory specified" ;;
      2 ) newproject "$1" ;;
      1 ) newproject      ;;
      * ) ___printhelp    ;;
    esac

  # --bump|-b  [PROJECT_DIR]
  elif [[ ${__o[bump]:-} = 1 ]]; then
    bumpproject "${1:-$PWD}"
    
  # --link|-l [PROJECT_DIR]
  elif [[ ${__o[link]:-} = 1 ]]; then
    linkproject "${1:-$PWD}"

  # --set|-s KEY VALUE [PROJECT_DIR]
  elif [[ -n ${__o[set]:-} ]]; then

    [[ -z ${1:-} ]] \
      && ERX "no value to ${__o[set]:-} given."

    setval="$1"
    shift

    __lastarg="${!#:-}"

    [[ ${__lastarg} =~ ^--$|${0}$ ]] \
      && __lastarg="" \
      || true

    setkey "${__o[set]:-}" "$setval" "${__lastarg:-$PWD}"

  # --get|-g KEY [PROJECT_DIR]
  elif [[ -n ${__o[get]:-} ]]; then
    getkey "${__o[get]:-}" "${__lastarg:-$PWD}"

  else
    ___printhelp
  fi
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
