#!/usr/bin/env bash

# --new|-n  [GENERATOR]  **TARGET_DIR**
newproject(){

  local f fn dn

  local generator="${1:-default}"
  local generatordir="$BASHBUD_DIR/generators/$generator"
  local targetdir="${__lastarg/'~'/$HOME}"

  : "${targetdir:=$PWD}"

  # test if targetdir exist
  [[ -d $targetdir && $targetdir != $PWD ]] \
    && ERX "$targetdir already exist."

  # test if generator exist
  [[ -d $generatordir ]] \
    || ERX "generator DIR $generatordir doesn't exist"
  
  [[ $targetdir = $PWD ]] || mkdir -p "$targetdir"

  # execute any pre-generate script
  [[ -x "$generatordir/__pre-generate" ]] \
    && "$generatordir/__pre-generate" "$targetdir"

  # copy all files and directories from generatordir
  # not starting with "__"
  for f in "$generatordir"/*; do
    fn="${f##*/}"
    [[ $fn =~ ^__ ]] && continue
    cp -rf "$f" "$targetdir"
  done

  # if __link dir exist, link files and create
  # directories if needed
  if [[ -s "$generatordir/__link" ]]; then
    for f in $(find "$generatordir/__link" -type f); do
      dn="${f%/*}"
      dn="${dn/$generatordir\/__link/$targetdir}"
      [[ -d $dn ]] || mkdir -p "$dn"
      ln -f "$f" "$dn"
    done
  fi

  # execute any post-generate script
  [[ -x "$generatordir/__post-generate" ]] \
    && "$generatordir/__post-generate" "$targetdir"

  bumpproject "$targetdir"
}
