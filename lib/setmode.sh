#!/usr/bin/env bash

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
