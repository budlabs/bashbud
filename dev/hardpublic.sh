#!/usr/bin/env bash

___hardpublic(){

  local f pmain
  
  pmain="${___dir}/${___name}.sh"

  echo '#!/usr/bin/env bash'
  echo

  ___hardversion

  echo

  ___hardenv

  grep -v '^#!/usr/bin/.*' "${pmain}" \
    | awk '/#bashbud$/ {exit};{print}'

  echo

  ___hardhelp

  echo
  
  ___hardopts
  ___hardstdin

  for f in "${___dir}/lib"/*; do
    [[ ${f##*/} =~ ^(bashbud|base) ]] && continue
    grep -v '^#!/usr/bin/.*' "$f"
  done

  awk '
    /#bashbud$/ {start=1}
    start==1 && $0 !~ /#bashbud$/ {print}
  ' "${pmain}"
}
