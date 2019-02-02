#!/usr/bin/env bash

getorder() {
  local trgdir="$1"

  [[ -d $trgdir ]] || return 1

  if [[ -f "$trgdir/__order" ]]; then
    awk '
      /^[^#]/ && $0 !~ /^\s*$/ {print}
    ' "$trgdir/__order"
    ls "$trgdir" | grep -v '^__'
  else
    ls "$trgdir" | grep -v '^__'
  fi | awk -v d="$trgdir" '
    !a[$0]++ {print d "/" $0}
  '
}
