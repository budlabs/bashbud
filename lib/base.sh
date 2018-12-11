#!/usr/bin/env bash

___printversion(){
cat << 'EOB' >&2
bashbud - version: 0.035
updated: 2018-10-17 by budRich
EOB
}

: "${BASHBUD_DIR:=$XDG_CONFIG_HOME/bashbud}"
: "${BASHBUD_PROJECTS_DIR:=$BASHBUD_DIR/projects}"
: "${BASHBUD_SCRIPTS_DIR:=$BASHBUD_DIR/scripts}"
: "${BASHBUD_PROJECTS_PATH:=$BASHBUD_PROJECTS_DIR}"
: "${BASHBUD_INFO_FOLD:=80}"

set -o errexit
set -o pipefail
set -o nounset

main(){
  local trgdir

  IFS=$'\n\t'

  if [[ -n ${__o[new]:-} ]]; then
    newproject "${__o[new]:-}"
    # trgdir="$HOME/tmp/bb2/$__new"
    
  elif [[ -n ${__o[bump]:-} ]]; then
    bumpproject "${__o[bump]}"
  elif [[ -n ${__o[mode]:-} ]]; then

    if [[ -z ${__lastarg:-} ]]; then
      setmode "${__o[mode]:-}" toggle
    else
      setmode "${__lastarg}" "${__o[mode]:-}"
    fi
    
  elif [[ -n ${__o[publish]:-} ]]; then
    publishproject
  elif [[ -z ${__o[*]:-} ]] && [[ -z "${__lastarg:-}" ]]; then
    listprojects
  elif [[ -n ${__o[lorem]:-} ]]; then
    letslorem "${__o[lorem]}"
  elif ((${__o[lib]:-0}==1)); then
    composelib "$___dir"
  fi
}

___printhelp(){
cat << 'EOB' >&2
bashbud - Boilerplate and template maker for bash scripts

SYNOPSIS
--------

bashbud --help|-h  
bashbud --version|-v  
bashbud --lib  
bashbud --mode|-m [MODE] PROJECT  
bashbud --publish|-p PROJECT PATH  
bashbud --new|-n  PROJECT  
bashbud --bump|-b PROJECT  
bashbud --lorem PROJECT  


DESCRIPTION
-----------

bashbud can be used to quickly create new scripts with cli-option support and 
automatic documentation applied.


OPTIONS
-------

--bump|-b PROJECT  
bump option will update PROJECT by setting update date in manifest.md to the 
current date, and also bump the verion number with (current version + 0.001). 
It will also temporarly set the project in development mode (if it isn't 
already) and generate readme and manpage files for PROJECT.

--help|-h   
Show help and exit.

--lib   
If this flag is set all files in bashbud/dev will be concatenated into a new 
bblib.sh file. This option is inteded only for developers  developing the 
bblib.sh file.

--lorem PROJECT  
This will print all options and environment varialbes declared in manifest.md 
of PROJECT, that are missing descriptions. A file (doc/info/lorem.md) will get 
created (if it doesn't exist), containing placeholder (lorem impsum) text for 
all these options/

--mode|-m MODE  
Toggles the mode of PROJECT between private and development. MODE can also be 
explicitly set by specifying it.

--new|-n PROJECT  
This will create a new script named "BASHBUD_NEW_SCRIPT_DIR/NAME/NAME.sh" and 
copy the info template to the same directory. The bashbud.sh lib script will 
get linked to the lib directory of the script.

--publish|-p PROJECT  
This will publish PROJECT to PATH (if PATH is not given it will default to: 
out/PROJECT.sh). The published file is a single file script with all files in 
the lib directory appended (excluding bblib.sh), this is the fastest and most 
portable version of the script, and is intended for releases and installed 
versions.

--version|-v   
Show version and exit.


ENVIRONMENT
-----------

BASHBUD_DIR  
Defaults to: $XDG_CONFIG_HOME/bashbud  

BASHBUD_PROJECTS_DIR  
Defaults to: $BASHBUD_DIR/projects  

BASHBUD_SCRIPTS_DIR  
Defaults to: $BASHBUD_DIR/scripts  

BASHBUD_PROJECTS_PATH  
Defaults to: $BASHBUD_PROJECTS_DIR  

BASHBUD_INFO_FOLD  
Defaults to: 80  
Width of text printed when --help option is triggered. (same width will be used 
in base.sh)


DEPENDENCIES
------------

bash  
gawk  
sed  
EOB
}

OFS="${IFS}"
IFS=$' \n\t'

declare -A __o
eval set -- "$(getopt --name "bashbud" \
  --options "hvm:p:nb:" \
  --longoptions "help,version,mode:,publish:,new:,lorem:,bump:,lib" \
  -- "$@"
)"

while true; do
  case "$1" in
    -v | --version ) ___printversion ; exit ;;
    -h | --help ) ___printhelp ; exit ;;
    -m | --mode ) __o[mode]="${2:-}" ; shift ;;
    -p | --publish ) __o[publish]="${2:-}" ; shift ;;
    -n | --new ) __o[new]="${2:-}" ; shift ;;
    --lorem ) __o[lorem]="${2:-}" ; shift ;;
    -b | --bump ) __o[bump]="${2:-}" ; shift ;;
    --lib ) __o[lib]=1 ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" \
  || true

for ___f in "${___dir}/lib"/*; do
  [[ ${___f##*/} =~ ^(bashbud|base) ]] && continue
  source "$___f"
done

IFS="${OFS}"
