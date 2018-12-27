#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
bashbud - version: 1.212
updated: 2018-12-27 by budRich
EOB
}

# environment variables
: "${BASHBUD_DIR:=$XDG_CONFIG_HOME/bashbud}"
: "${BASHBUD_DATEFORMAT:=%Y-%m-%d}"

___printhelp(){
  
cat << 'EOB' >&2
bashbud - Boilerplate and template maker for bash scripts

SYNOPSIS
--------
--new|-n   [GENERATOR] TARGET_DIR
--bump|-b  [PROJECT_DIR]
--help|-h
--version|-v

OPTIONS
-------

--new|-n  

--bump|-b  

--help|-h  

--version|-v  
EOB
}

OFS="${IFS}"
IFS=$' \n\t'

declare -A __o
eval set -- "$(getopt --name "bashbud" \
  --options "nbhv" \
  --longoptions "new,bump,help,version," \
  -- "$@"
)"

while true; do
  case "$1" in
    --new        | -n ) __o[new]=1 ;; 
    --bump       | -b ) __o[bump]=1 ;; 
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


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

IFS="${OFS}"


