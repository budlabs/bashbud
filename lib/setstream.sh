#!/usr/bin/env bash

setstream() {
  local projectdir="$1"
  local templatedir="$2"
  local licensetemplate="${3:-}"

  local templatelist

  cat "$projectdir/manifest.md"
  echo "___START___"
  
  # make a list of all templates, 
  # with __order in mind.
  templatelist="$(
  if [[ -f "$templatedir/__order" ]]; then
    awk '
      /^[^#]/ && $0 !~ /^\s*$/ {print}
    ' "$templatedir/__order"
    ls "$templatedir" | grep -v '^__'
  else
    ls "$templatedir" | grep -v '^__'
  fi | awk -v d="$templatedir" '
    !a[$0]++ {print d "/" $0}
  ')"

  for d in ${templatelist}; do
    [[ -d $d ]] || continue

    [[ -f $d/__template ]] && {
      cat "$d/__template"
      echo "___PRINT_TEMPLATE___${d}"
    }
  done

  [[ -n ${licensetemplate:-} ]] && {
    cat "$licensetemplate"
    echo "___PRINT_TEMPLATE___${licensetemplate%/*}"
  }
}
