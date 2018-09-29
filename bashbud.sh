#!/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

main(){
  local trgdir

  IFS=$'\n\t'
  BASHBUD_ALL_SCRIPTS_PATH+=":$HOME/tmp/bb2"

  if [[ -n ${__new:-} ]]; then
    trgdir="$HOME/tmp/bb2/$__new"
    # trgdir="${BASHBUD_NEW_SCRIPT_DIR:-}/$__new"
    if [[ -d $trgdir ]]; then
      ERX "project ${__new:-} already exist at $trgdir"
    else
      newproject "$trgdir"
    fi
  elif [[ -n ${__bump:-} ]]; then
    bumpproject "${__bump}"
  elif [[ -n ${__mode:-} ]]; then
    setmode
  elif [[ -n ${__publish:-} ]]; then
    publishproject
  elif ((${__hasoption:-0}==0)) && [[ -z "${__lastarg:-}" ]]; then
    listprojects
    # ___printprodcode
  elif [[ -n ${__lorem:-} ]]; then
    letslorem "${__lorem}"
  elif ((${__lib:-0}==1)); then
    composelib "$___dir"
  fi
}
___source="$(readlink -f "${BASH_SOURCE[0]}")" #bashbud
___dir="$(cd "$(dirname "${___source}")" && pwd)" #bashbud
. "${___dir}/lib/bblib.sh" #bashbud
BASHBUD_ALL_SCRIPTS_PATH+=":${___dir%/*}" #bashbud
main "${@:-}"
