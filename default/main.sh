#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

main(){

  IFS=$'\n\t'

  if [[ ${__o[help]:-} = 1 ]]; then
    ___printhelp
  elif [[ ${__o[version]:-} = 1 ]]; then
    ___printversion
  fi
  
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
