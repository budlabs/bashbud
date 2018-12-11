#!/usr/bin/env bash

bumpproject(){
  local project curpath

  if [[ -d "$1" ]]; then
    curpath="$1"
  else
    project="${1:-}"
    
    eval "$(getproject "$project")"

    [[ -z ${curpath:-} ]] \
      && ERX "could not find project: $project"
  fi

  curpath="${curpath/'~'/$HOME}"

  echo "$(dateupdate -bu "${curpath}/manifest.md")" \
    > "${curpath}/manifest.md"

  generate "$curpath"

}

generate(){
  local dir

  dir="${1:-.}"

  [[ $dir = "." ]] \
    && name="${PWD##*/}" \
    || name="${dir##*/}"

  if [[ -d ${dir}/generators ]]; then
    gendir="$dir/generators"
  elif [[ -d ${BASHBUD_DIR}/generators ]]; then
    gendir="${BASHBUD_DIR}/generators"
  elif [[ -d /usr/share/doc/bashbud/generators ]]; then
    gendir="/usr/share/doc/bashbud/generators"
  else
    ERX "no generators found"
  fi

  awk -v name="$name" -v dir="$dir" '

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
    cat "$dir/manifest.md"
    [[ -d $dir/manifest.d ]] \
      && cat "$dir/manifest.d/"*
    echo "___START___"
    for d in "$gendir"/* ; do
      [[ -d $d ]] || continue

      [[ -f $d/template ]] && {
        cat "$d/template"
        echo "___PRINT_TEMPLATE___${d##*/}"
      }
    done
  )
}
