#!/bin/env bash

___hardlibloop(){
 printf '%s\n' \
   'for ___f in "${___dir}/lib"/*; do' \
   '  [[ ${___f##*/} =~ ^(bashbud|base) ]] && continue' \
   '  source "$___f"' \
   'done' 
}
