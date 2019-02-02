#!/usr/bin/env bash

setstream() {
  local projectdir="$1"
  local templatedir="$2"
  local licensetemplate="${3:-}"

  cat "$projectdir/manifest.md"
  [[ -d $projectdir/manifest.d ]] && {
    for f in "$projectdir/manifest.d/"*; do
      cat "$f"
    done
  }
  echo "___START___"
  
  for d in $(getorder "$templatedir"); do
    [[ -d $d ]] || continue

    [[ -f $d/__template ]] && {
      cat "$d/__template"
      echo "___PRINT_TEMPLATE___${d}"
    }
  done

  if [[ -f ${licensetemplate:-} ]]; then
    cat "$licensetemplate"
    echo "___PRINT_TEMPLATE___${licensetemplate%/*}"
  fi
}
