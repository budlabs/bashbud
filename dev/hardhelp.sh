#!/bin/env bash

___hardhelp(){
  # printf '%s\n%s \\\n'"'"'%s'"'"'\n}\n' \
  #   '___printhelp(){' '>&2 echo' "$(
  #     ___printhelp | sed 's/'"'"'/'"'"'"'"'"'"'"'"'/g'
  #   )"
  
  # echo
  echo '___printhelp(){'
  echo "cat << 'EOB' >&2"
  ___printhelp
  echo 'EOB'
  echo '}'
}
