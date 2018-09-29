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
