#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
bashbud - version: 1.277
updated: 2019-01-01 by budRich
EOB
}


# environment variables
: "${BASHBUD_DIR:=$XDG_CONFIG_HOME/bashbud}"


___printhelp(){
  
cat << 'EOB' >&2
bashbud - Generate documents and manage projects


SYNOPSIS
--------
--new|-n   [GENERATOR] TARGET_DIR
--bump|-b  [PROJECT_DIR]
--help|-h
--version|-v

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


--help|-h  
Show help and exit.


--version|-v  
Show version and exit.
EOB
}


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done
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





