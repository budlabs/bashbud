#!/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

main(){
  local trgdir

  IFS=$'\n\t'
  BASHBUD_ALL_SCRIPTS_PATH+=":$HOME/tmp/bb2"

  if [[ -n ${__new:-} ]]; then
    trgdir="$HOME/tmp/bb2/$__new"
    # trgdir="${BASHBUD_NEW_SCRIPT_DIR:-}/$__new"
    if [[ -d $trgdir ]]; then
      ERX "project ${__new:-} already exist at $trgdir"
    else
      newproject "$trgdir"
    fi
  elif [[ -n ${__bump:-} ]]; then
    bumpproject "${__bump}"
  elif [[ -n ${__mode:-} ]]; then
    setmode
  elif [[ -n ${__publish:-} ]]; then
    publishproject
  elif ((${__hasoption:-0}==0)) && [[ -z "${__lastarg:-}" ]]; then
    listprojects
    # ___printprodcode
  elif ((${__lib:-0}==1)); then
    composelib "$___dir"
  fi
}
___printversion(){
>&2 echo \
'bashbud - version: 0.02
updated: 2018-09-27 by budRich'
}

OFS="${IFS}"
IFS=$' \n\t'
BASHBUD_NEW_SCRIPT_PATH="${BASHBUD_NEW_SCRIPT_PATH:=/home/bud/src/bashbud}"
BASHBUD_ALL_SCRIPTS_PATH="${BASHBUD_ALL_SCRIPTS_PATH:=/home/bud/tmp/bashbud}"
BASHBUD_NEW_SCRIPT_DIR="${BASHBUD_NEW_SCRIPT_DIR:=/home/bud/tmp/bashbud}"

___printhelp(){
>&2 echo \
'bashbud - Boilerplate and template maker for bash scripts

SYNOPSIS
--------

bashbud --help|-h  
bashbud --version|-v  
bashbud --list|-l  
bashbud --lib  
bashbud --mode|-m [MODE] PROJECT  
bashbud --publish|-p PROJECT PATH  
bashbud --new|-n  PROJECT  
bashbud --bump|-b PROJECT  


DESCRIPTION
-----------

bashbud can be used to quickly create new scripts with cli-option support and 
automatic documentation applied.


OPTIONS
-------

--help|-h   
Show help and exit.

--list|-l   
Search "BASHBUD_ALL_SCRIPTS_PATH" for bashbud
projects and list their name and status. Status can be either: development or 
production.

--new|-n PROJECT  
This will create a new script named "BASHBUD_NEW_SCRIPT_DIR/NAME/NAME.sh" and 
copy the info template to the same directory. The bashbud.sh lib script will 
get linked to the lib directory of the script.

--version|-v   
Show version and exit.


ENVIRONMENT
-----------

BASHBUD_NEW_SCRIPT_PATH  
Path to a directory where new scripts are linked. It is recommended to have 
this directory in PATH.

BASHBUD_ALL_SCRIPTS_PATH  
Array of directories, separated by : in which bashbud projects cand be stored. 
Used to list and search for projects.

BASHBUD_NEW_SCRIPT_DIR  
Path to directory where new scripts are placed.


DEPENDENCIES
------------

bash  
gawk  
sed  '
}

ERR(){ >&2 echo "[WARNING]" "$*"; }
ERX(){ >&2 echo "[ERROR]" "$*" && exit 1 ; }

eval set -- "$(getopt --name "bashbud" \
  --options "hvm:lp:n:b:" \
  --longoptions "help,version,mode:,list,publish:,new:,bump:,lib" \
  -- "$@"
)"

__hasopts=0

while true; do
  case "$1" in
    -v | --version ) ___printversion ; exit ;;
    -h | --help ) ___printhelp ; exit ;;
    -m | --mode ) __mode="${2:-}" ; shift ; __hasopts=1 ;;
    -l | --list ) __list=1 ; __hasopts=1 ;;
    -p | --publish ) __publish="${2:-}" ; shift ; __hasopts=1 ;;
    -n | --new ) __new="${2:-}" ; shift ; __hasopts=1 ;;
    -b | --bump ) __bump="${2:-}" ; shift ; __hasopts=1 ;;
    --lib ) __lib=1 ; __hasopts=1 ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" \
  || true


IFS="${OFS}"
#!/bin/env bash

bumpproject(){
  local project pmain curpath curmode
  # get current mode

  project="${__bump:-}"

  eval "$(
    listprojects | awk -v srch="$project" '
      $1 == srch {
        print "curmode=" $2
        print "curpath=\"" $3 "\""
        exit
      }
    '
  )"

  [[ -z ${curpath:-} ]] \
    && ERX "could not find project: $project"

  curpath="${curpath/'~'/$HOME}"
  setdevmode "${curpath}" || true

  pmain="${curpath}/${project}.sh"

  # bump version and update date
  echo "$(dateupdate -bu "${curpath}/manifest.md")" \
    > "${curpath}/manifest.md"

  # generate files
  ${pmain} -hman
  ${pmain} -hmdg

  # reset mode if necessary
  [[ private = "${curmode:-}" ]] \
    && setprivmode "${curpath}"
}



# update date and version
#!/bin/env bash

composelib() {
  local dir f

  dir="$1"

  {
    echo '#!/bin/env bash'
    echo
    for f in "$dir/dev/"*.sh; do
      [[ ${f##*/} = init.sh ]] && continue
      # remove shebang from files
      tail +2 "$f"
    done
    tail +2 "$dir/dev/init.sh"
  } > "$dir"/lib/bblib.sh
}
#!/bin/env bash

dateupdate(){

  local f bump

  f="${!#:-}"
  bump=0

  [[ -f $f ]] && [[ manifest.md = "${f##*/}" ]] && {

    while getopts cub option; do
      case "${option}" in
        c ) dtu+=("created") ;;
        u ) dtu+=("updated") ;;
        b ) bump=1 ;;
        *) exit 1 ;;
      esac
    done

    trg=${#dtu[@]}
    ((trg>1)) \
      && srch="^created:$|^updated:$" \
      || srch="^${dtu[0]}:\$"


    awk \
      -v bump="$bump" \
      -v today="$(date +'%Y-%m-%d')" \
      -v trg="trg" \
      -v srch="$srch" '
        bump == 1 && $1 == "version:" {
          newver=$2 + 0.001
          sub($2,newver,$0)
          bump=0
        }
        fnd != trg && $1 ~ srch {sub($2,today,$0);fnd++}
        {print}
    ' "$f"
  }

}
#!/bin/env bash

listprojects(){
  local mode

  OFS="${IFS}"
  IFS=:; for d in ${BASHBUD_ALL_SCRIPTS_PATH}; do
    [[ -d $d ]] && for dd in "${d}"/*; do
      [[ ! -d $dd ]] && continue
      if [[ -f "${dd}/lib/bblib.sh" ]]; then
        if [[ -f ${dd}/${dd##*/}.dev ]]; then
          mode=public
        elif [[ -f "${dd}/lib/bblib.dev" ]]; then
          mode=private
        else
          mode=develop
        fi
        printf '%-12s  %-10s  %s\n' "${dd##*/}" "$mode" "${dd/$HOME/'~'}"
      fi
    done
  done
  IFS="${OFS}"
}
#!/bin/env bash

newproject(){
  local trgdir tmpdir d f

  trgdir="${1:-}"

  atdir=(
    "${XDG_CONFIG_HOME:-$HOME/.config}/bashbud/template"
    "/usr/share/doc/bashbud/template"
  )

  for d in "${!atdir[@]}"; do
    [[ -d ${atdir[$d]} ]] && {
      tmpdir="$d"
      break
    }
  done

  [[ -z ${tmpdir:-} ]] && {
    ERX "couldn't locate template directory. " \
    "Please install bashbud correctly. " \
    "See README.md for instructions how."
  }

  [[ -f /lib/bblib.sh ]] || {
    ERX "couldn't locate /lib/bblib.sh" \
    "Please install bashbud correctly." \
    "See README.md for instructions how."
  }

  ((tmpdir!=0)) && {
    ERR "moving ${atdir[$tmpdir]} to ${atdir[0]}"
    mkdir -p "${atdir[0]%/*}"
    cp -r "${atdir[$tmpdir]}" "${atdir[0]}" 
    tmpdir=0
  }
  
  tmpdir=${atdir[$tmpdir]}

  mkdir -p "${trgdir}"
  (
    cd "$trgdir" || ERX "couldn't create directory $trgdir"
    # git init
    cp -r "$tmpdir"/* "$trgdir"
    [[ $(ls -A "${trgdir}/lib") ]] \
      && rm "${trgdir}/lib/"*

    [[ $(ls -A "${tmpdir}/lib") ]] && {
      for f in "${tmpdir}/lib"/*; do
        ln "$f" "${trgdir}/lib"
      done
    }

    ln -f "/lib/bblib.sh" "${trgdir}/lib/bblib.sh"
    
    chmod +x \
      "${trgdir}/main.sh"

    # set date in manifest
    echo "$(dateupdate -cu "${trgdir}/manifest.md")" \
      > "${trgdir}/manifest.md"

    mv "${trgdir}/main.sh" "${trgdir}/${__new}.sh"

    sleep 2
    mkdir -p "${BASHBUD_NEW_SCRIPT_PATH}"
    ln -s "${trgdir}/${__new}.sh" \
       "${BASHBUD_NEW_SCRIPT_PATH}/${__new}"
  )
}
#!/bin/env bash

publishproject() {
  ERR "setting publish project"

  local project target pmain curpath curmode

  project="${__publish:-}"

  eval "$(
    listprojects | awk -v srch="$project" '
      $1 == srch {
        print "curmode=" $2
        print "curpath=\"" $3 "\""
        exit
      }
    '
  )"

  [[ -z ${curpath:-} ]] \
    && ERX "could not find project: $project"

  curpath="${curpath/'~'/$HOME}"
  setdevmode "${curpath}" || true

  [[ -z ${__lastarg:-} ]] \
    && target="${curpath}/out/${project}.sh" \
    || target="${__lastarg}"

  mkdir -p "${target%/*}"

  pmain="${curpath}/${project}.sh"

  {
    awk '/#bashbud$/ {exit};{print}' "${pmain}"
    ${pmain} -vvv
    awk '
      /#bashbud$/ {start=1}
      start==1 && $0 !~ /#bashbud$/ {print}
    ' "${pmain}"
  } > "${target}"
  chmod +x "${target}"

  [[ private = "${curmode:-}" ]] \
    && setprivmode "${curpath}"
}
#!/bin/env bash

setmode(){

  local name curmode trgmode curpath

  if [[ -z ${__lastarg:-} ]]; then
    name=${__mode}
    trgmode=toggle
  else
    name=${__lastarg}
    trgmode=${__mode}
  fi
  
  case "$trgmode" in toggle ) trgmode=toggle  ;;
    pri*   ) trgmode=private ;;
    # pub*   ) trgmode=public  ;;
    dev*|* ) trgmode=develop ;;
  esac

  eval "$(
    listprojects | awk -v srch="$name" '
      $1 == srch {
        print "curmode=" $2
        print "curpath=\"" $3 "\""
        exit
      }
    '
  )"

  [[ -z ${curmode:-} ]] \
    && ERX "no project named $name found."

  [[ $curmode = "$trgmode" ]] \
    && ERX "$name is already set to $trgmode mode"

  curpath="${curpath/'~'/$HOME}"
  # if curmode is not develop, set it to develop
  [[ $curmode != develop ]] && setdevmode "${curpath:-}"

  # toggle if curmode is not develop
  case "$trgmode" in
    toggle ) [[ $curmode = develop ]] && \
               setprivmode "${curpath:-}" ;;
    pri*   )   setprivmode "${curpath:-}" ;;
    # pub*   )   setpubmode  "${curpath:-}" ;;
    dev*   ) : ;;
    *      ) : ;;
  esac
}



setprivmode() {
  ERR "setting privmode"
  local dir="$1"

  [[ -d $dir ]] || ERX "directory $dir doesn't exist"

  local trg="${dir##*/}"
  local pmain="${dir}/${trg}.sh"
  local pbb="${dir}/lib/bblib.sh"

  ${pmain} -vv > "${pbb%.sh}.prod"
  mv -f "${pbb}" "${pbb%.sh}.dev"
  mv -f "${pbb%.sh}.prod" "${pbb}"
}

setdevmode() {
  ERR "setting devmode"
  local dir="$1"

  [[ -d $dir ]] || ERX "directory $dir doesn't exist"

  local trg="${dir##*/}"
  local pmain="${dir}/${trg}.sh"
  local pbb="${dir}/lib/bblib.sh"

  # restore lib file
  [[ -f ${pbb%.sh}.dev ]] && mv -f "${pbb%.sh}.dev" "${pbb}"

  # restore script
  [[ -f ${pmain%.sh}.dev ]] && mv -f "${pmain%.sh}.dev" "${pmain}"
}
main "${@:-}"
