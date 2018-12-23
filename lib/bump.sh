#!/usr/bin/env bash

bumpproject(){
  local projectdir="${1/'~'/$HOME}"

  [[ -f "$projectdir/manifest.md" ]] \
    || ERX "$projectdir doesn't contain manifest.md"

  # update date and version number
  dateupdate -bu "$projectdir/manifest.md"

  generate "$projectdir"
}

generate() {
  local generatortype genpath
  local projectdir="${1/'~'/$HOME}"
  local templatedir="$projectdir/bashbud"
  local projectname="${projectdir##*/}"

  # prepend full path if dirname is relative
  [[ $projectdir =~ ^[^/] ]] \
    && projectdir="$PWD/$projectdir"

  # get generator and license type from manifest
  eval "$(awk '
    /^type:/ {print "generatortype=" $2}
    /^license:/ {print "licensetype=" $2}
    /^[.]{3}$/ {exit}
    ' "$projectdir/manifest.md"
  )"


  [[ -f $BASHBUD_DIR/licenses/${licensetype:=X} ]] \
    && licensetemplate="$BASHBUD_DIR/licenses/$licensetype"

  # templatedir path priority:
  # 1. $projectdir/bashbud
  # 2. $BASHBUD_DIR/generators/${generatortype:=default}/__templates
  # 3. /usr/share/bashbud/generators/${generatortype:=default}/__templates

  if [[ ! -d "$templatedir" ]]; then

    genpath="generators/${generatortype:=default}/__templates"
    
    if [[ -d "$BASHBUD_DIR/$genpath" ]]; then
      templatedir="$BASHBUD_DIR/$genpath"
    elif [[ -d "/usr/share/bashbud/$genpath" ]]; then
      templatedir="/usr/share/bashbud/$genpath"
    else
      ERX "could not locate generator: $generatortype"
    fi
  fi

  awk -v name="$projectname" -v dir="$projectdir" '

    @include "awklib/isfile"
    @include "awklib/isdir"
    @include "awklib/getif"
    @include "awklib/tempexpand"
    @include "awklib/loop"
    @include "awklib/templateinit"
    @include "awklib/readtemplate"
    @include "awklib/readmanifest"
    @include "awklib/readyaml"
    @include "awklib/printformat"
    @include "awklib/makemanifest"
    @include "awklib/expandbody"
    @include "awklib/cat"
    @include "awklib/setvar"
    @include "awklib/mdcat"
    @include "awklib/wrap"
    @include "awklib/wrapcheck"

    BEGIN {
      sqo="'"'"'"
      sqol=sqo "\"" sqo "\"" sqo
      reading=0

      aafrm="___%s[%s-%s]=\"%s\"\n"
      iafrm="___%s+=(\"%s\")\n"

      amani["name"]=name
      curopt=0
    }

    mark=0

    $0=="---" && reading==0 {
      reading="yaml"
      mark=1
    }

    $0=="..." && reading=="yaml" {
      reading="manifest"
      chain=0
      mark=1
    }

    $0=="___START___" && reading=="manifest" {
      makemanifest()
      reading="templates"
      mark=1
      templateinit()
    }

    mark!=1 && reading=="templates" {
      readtemplate()
    }
      

    mark!=1 && reading=="manifest" {
      readmanifest()
    }

    mark!=1 && reading=="yaml" && /./ && match($0,/([[:space:]]*)([-]{,1})[[:space:]]*([0-9a-zA-Z_-]*)([:]{,1})[[:space:]]*(.*)[[:space:]]*$/,ma) {
      readyaml() 
    }

    END {

      # for (k in amani["options"]["mode"]) {print k}
      # print amani["options"]["mode"]["long"]
    }


  ' <(
    cat "$projectdir/manifest.md"
    [[ -d $projectdir/manifest.d ]] \
      && cat "$projectdir/manifest.d/"*
    echo "___START___"
    for d in "$templatedir"/* ; do
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
    
  )


}
