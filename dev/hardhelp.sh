#!/usr/bin/env bash

___hardhelp(){
  
  echo '___printhelp(){'
  echo "cat << 'EOB' >&2"
  ___printhelp
  echo 'EOB'
  echo '}'
}
