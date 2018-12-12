#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
bashbud - version: 1.005
updated: 2018-12-12 by budRich
EOB
}

: "${BASHBUD_DIR:=$XDG_CONFIG_HOME/bashbud}"
: "${BASHBUD_PROJECTS_DIR:=$BASHBUD_DIR/projects}"
: "${BASHBUD_SCRIPTS_DIR:=$BASHBUD_DIR/scripts}"
: "${BASHBUD_PROJECTS_PATH:=$BASHBUD_PROJECTS_DIR}"
: "${BASHBUD_INFO_FOLD:=80}"

___printhelp(){
  
cat << 'EOB' >&2
bashbud - Boilerplate and template maker for bash scripts

SYNOPSIS
--------

--new|-n   [GENERATOR] TARGET_DIR
--bump|-b  PROJECT
--help|-h
--version|-v

OPTIONS
-------

--new|-n GENERATOR  

This will create a new script named 
"BASHBUD_NEW_SCRIPT_DIR/NAME/NAME.sh" and copy 
the info template to the same directory. The 
bashbud.sh lib script will get linked to the lib 
directory of the script.



--bump|-b PROJECT  

bump option will update PROJECT by setting update 
date in manifest.md to the current date, and also 
bump the verion number with (current version + 
0.001). It will also temporarly set the project 
in development mode (if it isn't already) and 
generate readme and manpage files for PROJECT.


--help|-h  
Show help and exit.


--version|-v  
Show version and exit.
EOB
}

OFS="${IFS}"
IFS=$' \n\t'

declare -A __o
eval set -- "$(getopt --name "bashbud" \
  --options "nb:hv" \
  --longoptions "new,bump:,help,version," \
  -- "$@"
)"

while true; do
  case "$1" in
    --new        | -n ) __o[new]=1 ;;
    --bump       | -b ) __o[bump]="${2:-}" ; shift ;;
    --help       | -h ) __o[help]=1 ;; 
    --version    | -v ) __o[version]=1 ;; 
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" \
  || true

___source="$(readlink -f "${BASH_SOURCE[0]}")" #bashbud
___dir="$(cd "$(dirname "${___source}")" && pwd)" #bashbud

for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

IFS="${OFS}"


