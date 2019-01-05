#!/usr/bin/env bash

# --get|-g KEY [PROJECT_DIR]
getkey(){

  local found
  local key="$1"
  local projectdir="${2/'~'/$HOME}"

  [[ -f "$projectdir/manifest.md" ]] \
    || ERX "$projectdir doesn't contain manifest.md"

  # found="$(awk -v key="$key" '
  #   BEGIN {r=""}
  #   $1 ~ key ":" {r=gensub($1 "\\s*","","g",$0)}
  #   r == ">" {block="fold";r=""}
  #   /^[.]{3}$/ {print r; exit}
  #   ' "$projectdir/manifest.md"
  # )"

  found="$(AWKPATH="${___dir:-}/awklib:/usr/share/bashbud/awklib:$(gawk 'BEGIN {print ENVIRON["AWKPATH"]}')" \
    awk -v key="$key" '
    @include "readyaml"

    BEGIN {
      sqo="'"'"'"
      sqol=sqo "\"" sqo "\"" sqo
      reading=0
      curopt=0
    }

    mark=0

    $0=="---" && reading==0 {
      reading="yaml"
      mark=1
    }

    $0=="..." && reading=="yaml" {
      if (amani["synopsis"] ~ /./) {
        split(amani["synopsis"],ssplit,"\n")
        sr=""
        for (l in ssplit) {
          if (sr=="") {sr=amani["name"] " " ssplit[l]}
          else {sr=sr "\n" amani["name"] " " ssplit[l]}
        }
        amani["synopsis"]=sr
      }
      exit
    }

    mark!=1 && reading=="yaml" && /./ && match($0,/([[:space:]]*)([-]{,1})[[:space:]]*([0-9a-zA-Z_-]*)([:]{,1})[[:space:]]*(.*)[[:space:]]*$/,ma) {
      readyaml() 
    }

  END {
    if (isarray(amani[key])) {
      for (k in amani[key]) {
        if (isarray(amani[key][k])) {
          for (l in amani[key][k]) {
            if (isarray(amani[key][k][l])) {
              
              for (j in amani[key][k][l]) {
                if (j != "index")
                  print l "=\"" amani[key][k][l][j] "\""
                else
                  print l
              }
            }
            else
            print l
          }
        }
      }
    }
    else if (amani[key] ~ /./) {print amani[key]}
  }

  ' "$projectdir/manifest.md")"

  [[ -n $found ]] \
    && echo "$found" \
    || return 1
}

# if      (rol==">" && iskey=1) {block="fold";binx=0}
# else if (rol=="|" && iskey=1) {block="block";binx=0}
# else if (block=="fold" && (curind>0 || $0 ~ /^[[:space:]]*$/)) {
#   iskey=0
#   if   (binx==0) {
#     amani[parkey]=gensub(/^[[:space:]]*/,"","g",$0)
#     binx++
#   }

#   else {
#     amani[parkey]=amani[parkey] gensub(/^[[:space:]]*/," ","g",$0)
#   }
# }
