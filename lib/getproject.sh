#!/usr/bin/env bash

getproject(){
  local name

  name="$1"
  
  listprojects | awk -v srch="$name" '
    $1 == srch {
      print "curpath=\"" $2 "\""
      exit
    }
  '
}
