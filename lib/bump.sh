#!/bin/env bash

bumpproject(){
  local project pmain curpath curmode

  project="${1:-}"
  
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

  pmain="${curpath}/${project}.sh"

  # bump version and update date
  echo "$(dateupdate -bu "${curpath}/manifest.md")" \
    > "${curpath}/manifest.md"

  # generate files
  ${pmain} -vcomposemanpage
  ${pmain} -vcomposereadme > "${curpath}/README.md"

  # reset mode if necessary
  [[ $curmode = private ]] \
    && setprivmode "${curpath}"

  # coolon
  :
}
