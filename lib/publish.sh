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
