#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
bashbud - version: 1.003
updated: 2018-12-12 by budRich
EOB
}

# environment variables
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
  elif [[ -n ${__o[bump]:-} ]]; then
    bumpproject "${__o[bump]}"
  elif [[ -z ${__o[*]:-} ]] && [[ -z "${__lastarg:-}" ]]; then
    listprojects
  elif [[ -n ${__o[lorem]:-} ]]; then
    letslorem "${__o[lorem]}"
  else
    ___printhelp
    exit
  fi
}


___printhelp(){
  
cat << 'EOB' >&2
bashbud - 
Boilerplate and template maker for bash 
scripts

SYNOPSIS
--------

--new|-n   PROJECT
--bump|-b  PROJECT
--lorem|-l PROJECT
--marulk
--olof|-o skum
--irsam|-i [--olof|-o] [skum]
--help|-h
--version|-v

OPTIONS
-------

--new|-n PROJECT  

This will create a new script named 
"BASHBUD_NEW_SCRIPT_DIR/NAME/NAME.sh" 
and copy the info template to the same 
directory. The bashbud.sh lib script 
will get linked to the lib directory of 
the script.



--bump|-b PROJECT  

bump option will update PROJECT by 
setting update date in manifest.md to 
the current date, and also bump the 
verion number with (current version + 
0.001). It will also temporarly set the 
project in development mode (if it 
isn't already) and generate readme and 
manpage files for PROJECT.


--lorem|-l PROJECT  

This will print all options and 
environment varialbes declared in 
manifest.md of PROJECT, that are 
missing descriptions. A file 
(doc/info/lorem.md) will get created 
(if it doesn't exist), containing 
placeholder (lorem impsum) text for all 
these options/


--marulk  

--olof|-o  

--irsam|-i  

--help|-h  
Show help and exit.


--version|-v  
Show version and exit.
EOB
}

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
    @include "awklib/wrap"

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

setmode(){

  local name curmode trgmode curpath

  name="$1"
  trgmode="$2"

  case "$trgmode" in 
    toggle ) trgmode=toggle  ;;
    pri*   ) trgmode=private ;;
    dev*|* ) trgmode=develop ;;
  esac

  eval "$(getproject "$name")"

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
  local pbb="${dir}/lib/base.sh"

  ${pmain} -vhardbase > "${pbb%.sh}.dev"
  mv -f "${pbb%.sh}.dev" "${pbb}"
}

setdevmode() {
  ERR "setting devmode"
  local dir="$1"

  [[ -d $dir ]] || ERX "directory $dir doesn't exist"

  local pbb="${dir}/lib/base.sh"

  [[ -f ${pbb%.sh}.dev ]] || {
    mv "$pbb" "${pbb%.sh}".dev
    ln -f "/lib/bblib.sh" "$pbb"
  }
}

publishproject() {
  ERR "setting publish project"

  local project target pmain curpath curmode

  project="${__o[publish]:-}"

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
  [[ $curmode != develop ]] && setdevmode "${curpath}"

  [[ -z ${__lastarg:-} ]] \
    && target="${curpath}/out/${project}.sh" \
    || target="${__lastarg}"

  mkdir -p "${target%/*}"

  pmain="${curpath}/${project}.sh"

  ${pmain} -vhardpublic > "${target}"

  chmod +x "${target}"

  [[ $curmode = private ]] && setprivmode "${curpath}"
}

newproject(){
  local trgdir tmpdir project d f

  project="${1:-}"
  trgdir="${BASHBUD_PROJECTS_DIR:-}/${project}"

  [[ -d $trgdir ]] \
    && ERX "project ${project} already exist at $trgdir"
  
  atdir=(
    "${BASHBUD_DIR}/base"
    "/usr/share/doc/bashbud/base"
  )

  for d in "${!atdir[@]}"; do
    [[ -d ${atdir[$d]} ]] && {
      tmpdir="$d"
      break
    }
  done

  [[ -z ${tmpdir:-} ]] && {
    ERX "couldn't locate base directory. " \
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

    ln -f "/lib/bblib.sh" "${trgdir}/lib/base.sh"
    touch "${trgdir}/lib/base.dev"

    chmod +x \
      "${trgdir}/main.sh"

    # set date in manifest
    echo "$(dateupdate -cu "${trgdir}/manifest.md")" \
      > "${trgdir}/manifest.md"

    mv "${trgdir}/main.sh" "${trgdir}/${project}.sh"

    mkdir -p "${BASHBUD_SCRIPTS_DIR}"
    ln -fs "${trgdir}/${project}.sh" \
       "${BASHBUD_SCRIPTS_DIR}/${project}"
  )

  bumpproject "${project}"
  
  echo "${trgdir}/${project}.sh"
}

letslorem() {
  local project curmode curpath

  project="$1"

  eval "$(getproject "$project")"

  [[ -z ${curmode:-} ]] \
    && ERX "no project named $project found."

  curpath="${curpath/'~'/$HOME}"
  # if curmode is not develop, set it to develop
  [[ $curmode != develop ]] && setdevmode "${curpath:-}"

  local trg="${curpath##*/}"
  local pmain="${curpath}/${trg}.sh"

  alor=($(${pmain} -vprintlorem))

  mkdir -p "${curpath}/doc/info"
  for l in "${alor[@]}"; do
    echo "$l"
    printf '# %s\n\n%s\n\n' "$l" "$(loremtext)" \
      >> "${curpath}/doc/info/lorem.md"
  done

  [[ $curmode != develop ]] && setprivmode "${curpath:-}"

}

loremtext(){
echo '
Lorem ipsumLorem ipsum in ex duis magna veniam
proident incididunt voluptate minim aliquip dolore
incididunt sunt exercitation et officia aute sunt
fugiat. Lorem ipsum enim sed quis fugiat consequat
quis magna fugiat minim tempor nulla sed ex aute
elit. Nulla cupidatat ea enim voluptate voluptate
laborum esse fugiat sed nulla consequat laborum
tempor sint aliquip. Pariatur ut eiusmod pariatur
voluptate id fugiat in sunt dolor id eu amet.
Lorem ipsum veniam commodo dolore quis non ullamco
ad sint proident adipisicing in occaecat ut elit.
ad excepteur do fugiat dolore anim consequat dolor
aute cupidatat est eu.
'
}

listprojects(){
  local mode

  OFS="${IFS}"
  IFS=: ; for d in ${BASHBUD_PROJECTS_PATH//'~'/$HOME}; do
    [[ -d $d ]] && for dd in "${d}"/*; do
      [[ -f "${dd}/lib/base.sh" ]] || continue
      printf '%-12s  %s\n' "${dd##*/}" "${dd/$HOME/'~'}"
    done
  done
  IFS="${OFS}"
}

getproject(){
  local name

  name="$1"
  
  listprojects | awk -v srch="$name" '
    $1 == srch {
      print "curpath=\"" $2 "\""
      exit
    }
  '
}

ERR(){ >&2 echo "[WARNING]" "$*"; }
ERX(){ >&2 echo "[ERROR]" "$*" && exit 1 ; }

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

composelib() {
  local dir f

  dir="$1"

  {
    echo '#!/usr/bin/env bash'
    echo
    for f in "$dir/dev/"*.sh; do
      [[ ${f##*/} = init.sh ]] && continue
      # remove shebang from files
      grep -v '^#!/bin/.*' "$f"
    done
    tail +2 "$dir/dev/init.sh"
  } > "$dir"/lib/base.sh
  
}

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

OFS="${IFS}"
IFS=$' \n\t'

declare -A __o
eval set -- "$(getopt --name "bashbud" \
  --options "n:b:l:oihv" \
  --longoptions "new:,bump:,lorem:,marulk,olof,irsam,help,version," \
  -- "$@"
)"

while true; do
  case "$1" in
    --new        | -n ) __o[new]="${2:-}" ; shift ;;
    --bump       | -b ) __o[bump]="${2:-}" ; shift ;;
    --lorem      | -l ) __o[lorem]="${2:-}" ; shift ;;
    --marulk     ) __o[marulk]=1 ;; 
    --olof       | -o ) __o[olof]=1 ;; 
    --irsam      | -i ) __o[irsam]=1 ;; 
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

IFS="${OFS}"

main "${@:-}"


