#!/bin/env bash

OFS="${IFS}"
IFS=$' \n\t'

declare -A ___info
declare -A ___environment_variables
declare -A ___autoopts

___file="${___dir}/$(basename "${___source}")"
___name="$(basename "${___file}" .sh)"
__=""
__stdin=""

read -N1 -t0.01 __  && {
  (( $? <= 128 ))  && {
    IFS= read -rd '' __stdin
    __stdin="$__$__stdin"
  }
}

eval "$(___parsemanifest <(
  awk 'start==1{print}; $0=="..." {start=1}' \
    "${___dir}/manifest.md"
  [[ -d ${___dir}/doc/info ]] && {
    for infofile in "${___dir}/doc/info/"*.md; do
      cat "$infofile"
    done
  }
  )
)"


eval "$(___parseyaml <(
  awk '$0=="..." {exit};$0!="---" {print}' \
    "${___dir}/manifest.md"
  )
)"

___autoparse "${@}"

for ___f in "${___dir}/lib"/*; do
  [[ ${___f##*/} =~ ^(bashbud|bblib) ]] && continue
  source "$___f"
done

IFS="${OFS}"
