#!/bin/env bash

___composemanpage(){
  ___setinfo
  
  mkdir -p "${___dir}/doc/man"
  printf '%s' "# ${___about}" > "${___dir}/doc/man/${___name}.md" 
  printf '%s' "${___header}" "${___about}" "${___footer}" | \
    go-md2man > "${___dir}/doc/man/${___name}.1"
}
