#!/bin/bash

main(){
  
  : "${_o[verbose]:=$BASHBUD_VERBOSE}"

  echo "hello ${_o[hello]:-,option "--hello" have no WORD}!"
}

__dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")") #bashbud
source "$__dir/_init.sh"                              #bashbud
