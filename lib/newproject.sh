#!/usr/bin/env bash

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
  setprivmode "${trgdir}"
  
  echo "created: ${trgdir}/${project}.sh"
}
