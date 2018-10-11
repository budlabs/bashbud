#!/bin/env bash

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
