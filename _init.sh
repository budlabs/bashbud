#!/bin/bash

exec 3>&2

__print_version()
{
  >&3 printf '%s\n' \
    'bashbud - version: 1.99' \
    'updated: 2022-04-14 by budRich'
}


__print_help()
{
  cat << 'EOB' >&3  
  usage: bashbud [OPTIONS] [DIRECTORY]

    -c, --config-dir DIRECTORY | override the default (~/.config/bashbud)               
    -t, --template TEMPLATE    | TEMPLATE is the name of a directory in BASHBUD_DIR     
    -n, --new DIRECTORY        | same as: --template default                            
    -v, --version              | print version info and exit                            
    -h, --help                 | print help and exit                                    
    -a, --add                  | add FILE to (mandatory --template) TEMPLATE            
    -f, --force DIRECTORY      | Overwrite already existing files imported from template
    -u, --update               | update TEMPLATE based on current directory             
EOB
}

for ___f in "$__dir/func"/*; do
  . "$___f" ; done ; unset -v ___f

declare -A _o

options=$(getopt \
  --name "[ERROR]:bashbud" \
  --options "c:,t:,n::,v,h,a,f::,u" \
  --longoptions "config-dir:,template:,new::,version,help,add,force::,update"  -- "$@"
) || exit 98

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --help       | -h ) __print_help && exit ;;
    --version    | -v ) __print_version && exit ;;
    --config-dir | -c ) _o[config-dir]=$2 ; shift ;;
    --template   | -t ) _o[template]=$2 ; shift ;;
    --new        | -n ) _o[new]=${2:-1} ; shift ;;
    --add        | -a ) _o[add]=1 ;;
    --force      | -f ) _o[force]=${2:-1} ; shift ;;
    --update     | -u ) _o[update]=1 ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

main "$@"
