#!/bin/env bash

___printprodcode(){

  local infformat e o

  infformat='%s\n%s \\\n'"'"'%s'"'"'\n}\n'

  # --version info
  printf "$infformat" \
    '___printversion(){' '>&2 echo' "$(___printinfo version)"
  
  echo 

  echo 'OFS="${IFS}"'
  echo "IFS=\$' \n\t'"
  echo

  # if envrionemt variables are defined in manifest
  ((${#___environment_variables[@]}>0)) && {
    for e in "${!___environment_variables[@]}"; do
      printf '%s=\"${%s:=%s}\"\n' \
        "$e" "$e" "${___environment_variables[$e]}"
    done

    echo
  }

  # --help
  printf "$infformat" \
    '___printhelp(){' '>&2 echo' "$(
      ___printinfo help | sed 's/'"'"'/'"'"'"'"'"'"'"'"'/g'
    )"
  
  echo

  # getopts start
  printf 'eval set -- "$(getopt --name "%s" \\\n' "$___name"
  printf '  --options "%s" \\\n' "${___vvsopts//::/}"
  printf '  --longoptions "%s" \\\n' "${___vvlopts%,}"
  printf '  -- "$@"\n)"\n'

  echo
  echo '__hasopts=0'
  echo

  printf 'while true; do\n  case "$1" in\n'
  printf '    %s ; exit ;;\n' \
    '-v | --version ) ___printversion' \
    '-h | --help ) ___printhelp'

  ((${#___autoopts[@]}>0)) && for o in "${!___autoopts[@]}"; do
    echo -n "    "
    [[ -n ${___autoopts[$o]:-} ]] \
      && echo -n "-${___autoopts[$o]//:} | "
    echo -n "--$o ) "
    isflag=0
    for f in "${___vvflags[@]}"; do
      [[ $f = "$o" ]] && isflag=1
    done
    ((isflag==1)) \
      && echo -n "__${o}=1" \
      || echo -n "__${o}=\"\${2:-}\" ; shift" 
    echo " ; __hasopts=1 ;;"
  done

  printf '    %s ;;\n' \
    '-- ) shift ; break' \
    '*  ) break'


  printf '  %s\n  %s\n%s\n' "esac" "shift" "done"

  # getopts end
  echo

  # __lastarg
  printf '%s\n  %s\n  %s\n' \
    '[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \' \
    '&& __lastarg="" \' \
    '|| true'
  
  echo

  # include __stdin if it is used in main script
  grep '.*__stdin.*' "${___source}"  > /dev/null 2>&1 && {
    printf '%s\n' '__=""' '__stdin=""' 'read -N1 -t0.01 __  && {'
    echo '  (( $? <= 128 ))  && {'
    printf '    %s\n' \
      "IFS= read -rd '' __stdin" \
      '__stdin="$__$__stdin"'
    printf '  }\n}\n'
  }
  echo

  echo 'IFS="${OFS}"'

}
