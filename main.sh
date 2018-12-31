#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

main(){

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
    
  elif [[ ${__o[version]:-} = 1 ]]; then
    ___printversion
  else
    ___printhelp
  fi
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
