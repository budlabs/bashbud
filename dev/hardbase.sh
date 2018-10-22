#!/usr/bin/env bash

___hardbase(){

  echo '#!/usr/bin/env bash'
  echo

  ___hardversion
  echo
  
  ___hardenv
  echo

  ___hardhelp
  echo
  
  ___hardopts
  ___hardstdin
  ___hardlibloop
}
