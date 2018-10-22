#!/usr/bin/env bash

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
