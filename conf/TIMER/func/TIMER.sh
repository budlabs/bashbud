#!/bin/bash

trap 'CLEANUP' EXIT INT HUP

start_timer=0
[[ $* =~ --verbose || $BASHBUD_VERBOSE -eq 1 ]] && start_timer=1
[[ $* =~ --dryrun ]] && start_timer=0

((start_timer)) && {
  ___t=$(( 10#${EPOCHREALTIME//[!0-9]} ))

  for ((___arg=0; ___arg<${#@}+1;___arg++)); do
    [[ ${!___arg} = --verbose ]] && break
  done

  printf -v ___cmd "%s " "${0##*/}" "${@:1:___arg}"
  unset -v ___arg
  >&2 echo ">>> $___cmd"
}

CLEANUP() {
  ((start_timer)) \
    && >&2 echo "<<< $___cmd" \
      "$(( (10#${EPOCHREALTIME//[!0-9]} - ___t) / 1000 ))ms"
}

