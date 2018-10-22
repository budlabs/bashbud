#!/usr/bin/env bash

___hardopts(){

  echo 'OFS="${IFS}"'
  echo "IFS=\$' \n\t'"
  echo
  echo 'declare -A __o'

  printf 'eval set -- "$(getopt --name "%s" \\\n' "$___name"
  printf '  --options "%s" \\\n' "${___vvsopts//::/}"
  printf '  --longoptions "%s" \\\n' "${___vvlopts%,}"
  printf '  -- "$@"\n)"\n'

  echo

  printf 'while true; do\n  case "$1" in\n'
  printf '    %s ; exit ;;\n' \
    '-v | --version ) ___printversion' \
    '-h | --help ) ___printhelp'

  ((${#___autoopts[@]}>0)) && for o in "${!___autoopts[@]}"; do
    echo -n "    "
    [[ ${___autoopts[$o]//:} != "" ]] \
      && echo -n "-${___autoopts[$o]//:} | "
    echo -n "--$o ) "
    isflag=0
    for f in "${___vvflags[@]}"; do
      [[ $f = "$o" ]] && isflag=1
    done
    ((isflag==1)) \
      && echo -n "__o[${o}]=1" \
      || echo -n "__o[${o}]=\"\${2:-}\" ; shift" 
    echo " ;;"
  done

  printf '    %s ;;\n' \
    '-- ) shift ; break' \
    '*  ) break'


  printf '  %s\n  %s\n%s\n' "esac" "shift" "done"

  echo

  # __lastarg
  printf '%s\n  %s\n  %s\n' \
    '[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \' \
    '&& __lastarg="" \' \
    '|| true'
  
  echo

  echo 'IFS="${OFS}"'
  
}
