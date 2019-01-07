#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
bashbud - version: 1.297
updated: 2019-01-07 by budRich
EOB
}


# environment variables
: "${BASHBUD_DIR:=$XDG_CONFIG_HOME/bashbud}"


set -o errexit
set -o pipefail
set -o nounset

main(){

  local setval
  IFS=$'\n\t'

  # --new|-n  [GENERATOR]  **TARGET_DIR**
  if [[ ${__o[new]:-} = 1 ]]; then
    
    case $# in
      0 ) ERX "no directory specified" ;;
      2 ) newproject "$1" ;;
      1 ) newproject      ;;
      * ) ___printhelp    ;;
    esac

  # --bump|-b  [PROJECT_DIR]
  elif [[ ${__o[bump]:-} = 1 ]]; then
    bumpproject "${1:-$PWD}"
    
  # --link|-l [PROJECT_DIR]
  elif [[ ${__o[link]:-} = 1 ]]; then
    linkproject "${1:-$PWD}"

  # --set|-s KEY VALUE [PROJECT_DIR]
  elif [[ -n ${__o[set]:-} ]]; then

    [[ -z ${1:-} ]] \
      && ERX "no value to ${__o[set]:-} given."

    setval="$1"
    shift

    __lastarg="${!#:-}"

    [[ ${__lastarg} =~ ^--$|${0}$ ]] \
      && __lastarg="" \
      || true

    setkey "${__o[set]:-}" "$setval" "${__lastarg:-$PWD}"

  # --get|-g KEY [PROJECT_DIR]
  elif [[ -n ${__o[get]:-} ]]; then
    getkey "${__o[get]:-}" "${__lastarg:-$PWD}"

  else
    ___printhelp
  fi
}

___printhelp(){
  
cat << 'EOB' >&2
bashbud - Generate documents and manage projects


SYNOPSIS
--------
bashbud --new|-n    [GENERATOR] TARGET_DIR
bashbud --bump|-b   [PROJECT_DIR]
bashbud --link|-l [PROJECT_DIR]
bashbud --get|-g KEY [PROJECT_DIR]
bashbud --set|-s KEY VALUE [PROJECT_DIR]
bashbud --help|-h
bashbud --version|-v

OPTIONS
-------

--new|-n  
Creates a new project at TARGET_DIR (if
TARGET_DIR doesnt exist, if it does script will
exit), based on GENERATOR. If GENERATOR is omitted
the default generator will be used. After all
files are copied and linked, the project is bumped
(same as: bashbud --bump TARGET_DIR).


--bump|-b  
The current working direcory will be set as
PROJECT_DIR if none is specified. When a project
is bumped,  bashbud will read the manifest.md file
in PROJECT_DIR, (or exit if no manifest.md file
exists). If a generator type is specified in the
front matter  (the YAML section starting the
document) of the manifest.md file, that generator
will be used to update the project based on the
content of the manifest.md file and the manifest.d
directory (if it exists). If a directory named
bashbud exists within PROJECT_DIR, that directory
will be used as a generator.


--link|-l  
Add any missing links from the generators __link
directory, to PROJECT_DIR.


--get|-g KEY  
Get the value from a key in the YAML frontmatter
of the manifest.md. If last argument is a
directory, the manifest in that directory will be
used, otherwise the current directory is assumed.


--set|-s VALUE  
Set the value of KEY in the YAML frontmatter of
the manifest.md to VALUE. If last argument is a
directory, the manifest in that directory will be
used, otherwise the current directory is assumed.


--help|-h  
Show help and exit.


--version|-v  
Show version and exit.
EOB
}


bumpproject(){
  local generatortype licensetype genpath
  local projectdir="${1/'~'/$HOME}"
  local templatedir="$projectdir/bashbud"

  [[ -f "$projectdir/manifest.md" ]] \
    || ERX "$projectdir doesn't contain manifest.md"

  # prepend full path if dirname is relative
  [[ $projectdir =~ ^[^/] ]] \
    && projectdir="$PWD/$projectdir"

  # get generator and license type from manifest
  eval "$(awk '
    /^generator:/ {print "generatortype=" $2}
    /^license:/ {print "licensetype=" $2}
    /^[.]{3}$/ {exit}
    ' "$projectdir/manifest.md"
  )"

  [[ -f $BASHBUD_DIR/licenses/${licensetype:=X} ]] \
    && licensetemplate="$BASHBUD_DIR/licenses/$licensetype"

  
  # Find template DIR
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

  # execute any pre-apply script
  [[ -x "$templatedir/__pre-apply" ]] \
    && "$templatedir/__pre-apply" "$projectdir"

  # process manifest and templates
  setstream "$projectdir" "$templatedir" "${licensetemplate:-}" \
    | generate "$projectdir"

  # execute any post-apply script
  [[ -x "$templatedir/__post-apply" ]] \
    && "$templatedir/__post-apply" "$projectdir"
}

ERM(){ >&2 echo "$*"; }
ERR(){ >&2 echo "[WARNING]" "$*"; }
ERX(){ >&2 echo "[ERROR]" "$*" && exit 1 ; }

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

      # for (k in amani["options"]) {print k}

    }


  ' < /dev/stdin
}

# --get|-g KEY [PROJECT_DIR]
getkey(){

  local found
  local key="$1"
  local projectdir="${2/'~'/$HOME}"

  [[ -f "$projectdir/manifest.md" ]] \
    || ERX "$projectdir doesn't contain manifest.md"

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

# --new|-n  [GENERATOR]  **TARGET_DIR**
newproject(){

  local f fn dn

  local generator="${1:-default}"
  local generatordir="$BASHBUD_DIR/generators/$generator"
  local targetdir="${__lastarg/'~'/$HOME}"

  # test if targetdir exist
  [[ -d $targetdir ]] \
    && ERX "$targetdir already exist."

  # test if generator exist
  [[ -d $generatordir ]] \
    || ERX "generator DIR $generatordir doesn't exist"
  
  # execute any pre-generate script
  [[ -x "$generatordir/__pre-generate" ]] \
    && "$generatordir/__pre-generate" "$targetdir"

  # create targetdir
  mkdir -p "$targetdir"

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

# --set|-s KEY VALUE [PROJECT_DIR]
setkey(){

  local key="$1"
  local value="$2"
  local projectdir="${3/'~'/$HOME}"

  [[ -f "$projectdir/manifest.md" ]] \
    || ERX "$projectdir doesn't contain manifest.md"


  awk -i inplace -v key="$key" -v val="$value" '
    $1 ~ key ":" {
      $0=gensub(/(.+:\s*)(.+)/,"\\1" val,"g",$0)
    }
    {print}
    ' "$projectdir/manifest.md"
}

setstream() {
  local projectdir="$1"
  local templatedir="$2"
  local licensetemplate="${3:-}"

  local templatelist

  cat "$projectdir/manifest.md"
  [[ -d $projectdir/manifest.d ]] && {
    for f in "$projectdir/manifest.d/"*; do
      cat "$f"
    done
  }
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

  if [[ -f ${licensetemplate:-} ]]; then
    cat "$licensetemplate"
    echo "___PRINT_TEMPLATE___${licensetemplate%/*}"
  fi
}
declare -A __o
eval set -- "$(getopt --name "bashbud" \
  --options "nblg:s:hv" \
  --longoptions "new,bump,link,get:,set:,help,version," \
  -- "$@"
)"

while true; do
  case "$1" in
    --new        | -n ) __o[new]=1 ;; 
    --bump       | -b ) __o[bump]=1 ;; 
    --link       | -l ) __o[link]=1 ;; 
    --get        | -g ) __o[get]="${2:-}" ; shift ;;
    --set        | -s ) __o[set]="${2:-}" ; shift ;;
    --help       | -h ) __o[help]=1 ;; 
    --version    | -v ) __o[version]=1 ;; 
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

if [[ ${__o[help]:-} = 1 ]]; then
  ___printhelp
  exit
elif [[ ${__o[version]:-} = 1 ]]; then
  ___printversion
  exit
fi

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" \
  || true


main "${@:-}"


