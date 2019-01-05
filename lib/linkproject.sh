#!/usr/bin/env bash

linkproject(){
  local generatortype genpath linkdir
  local projectdir="${1/'~'/$HOME}"

  [[ -f "$projectdir/manifest.md" ]] \
    || ERX "$projectdir doesn't contain manifest.md"

  # prepend full path if dirname is relative
  [[ $projectdir =~ ^[^/] ]] \
    && projectdir="$PWD/$projectdir"

  # get generator type from manifest
  eval "$(awk '
    /^generator:/ {print "generatortype=" $2}
    /^[.]{3}$/ {exit}
    ' "$projectdir/manifest.md"
  )"

  # Find __link dir
  genpath="generators/${generatortype:=default}/__link"
  
  if [[ -d "$BASHBUD_DIR/$genpath" ]]; then
    linkdir="$BASHBUD_DIR/$genpath"
  elif [[ -d "/usr/share/bashbud/$genpath" ]]; then
    linkdir="/usr/share/bashbud/$genpath"
  else
    ERX "could not locate __link dir for generator: $generatortype"
  fi

  # link files and create
  # directories if needed
  for f in $(find "$linkdir" -type f); do
    dn="${f%/*}"
    dn="${dn/$linkdir/$projectdir}"
    [[ -d $dn ]] || mkdir -p "$dn"
    [[ -f "$dn/${f##*/}" ]] || ln -f "$f" "$dn"
  done
}
