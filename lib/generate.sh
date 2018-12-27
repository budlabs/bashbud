#!/usr/bin/env bash

generate() {
  local projectdir="${1/'~'/$HOME}"
  local projectname="${projectdir##*/}"

  AWKPATH="${___dir:-}/awklib:/usr/share/bashbud/awklib:$(gawk 'BEGIN {print ENVIRON["AWKPATH"]}')" \
    awk -v name="$projectname" -v dir="$projectdir" '

    @include "isfile"
    @include "isdir"
    @include "getif"
    @include "tempexpand"
    @include "loop"
    @include "templateinit"
    @include "readtemplate"
    @include "readmanifest"
    @include "readyaml"
    @include "printformat"
    @include "makemanifest"
    @include "expandbody"
    @include "cat"
    @include "setvar"
    @include "mdcat"
    @include "wrap"
    @include "wrapcheck"
    @include "getopt"

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


  ' < /dev/stdin
}
