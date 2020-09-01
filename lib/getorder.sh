#!/usr/bin/env bash

getorder() {
  local trgdir="$1" 
  local orderfile=$trgdir/__order

  [[ -d $trgdir ]] || return 1

  if [[ -f "$orderfile" ]]; then
    awk '
      /^[^#]/ && $0 !~ /^\s*$/ {print}
    ' "$orderfile"
    ls "$trgdir" | grep -v '^__'
  else
    ls "$trgdir" | grep -v '^__'
  fi | awk -v d="$trgdir" '
    !a[$0]++ {print d "/" $0}
  '
}
