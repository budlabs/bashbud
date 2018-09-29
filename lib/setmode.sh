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
