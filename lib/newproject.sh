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

    mkdir -p "${BASHBUD_NEW_SCRIPT_PATH/'~'/$HOME}"
    ln -s "${trgdir}/${__new}.sh" \
       "${BASHBUD_NEW_SCRIPT_PATH/'~'/$HOME}/${__new}"
  )
}
