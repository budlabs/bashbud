#!/bin/env bash

___hardversion(){
  # printf '%s\n%s \\\n'"'"'%s'"'"'\n}\n' \
  #   '___printversion(){' \
  #   '>&2 echo' \
  #   "$(___printversion)"
  echo '___printversion(){'
  echo "cat << 'EOB' >&2"
  ___printversion
  echo 'EOB'
  echo '}'
}
