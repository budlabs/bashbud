#!/bin/env bash

setinfo(){
local o lo so 

# shellcheck disable=SC2016
___about="$(
echo "\`${___name}\` - ${___description}"
echo "
SYNOPSIS
--------

${___synopsis}"

[[ -n ${___info[long-description]:-} ]] && {
echo "
DESCRIPTION
-----------

${___info[long-description]}
"
}

echo "
OPTIONS
-------
"

for o in $(printf '%s\n' "${!___info[@]}" | sort); do
  [[ $o =~ ^options ]] || continue
  lo=${o#*-}
  [[ -z ${___info[option-${lo}]:-} ]] && continue
  so="${___info[$o]:-}"
  [[ $so ]] \
    && printf '`--%s`|`-%s`' "$lo" "$so" \
    || printf '`--%s`' "$lo" 
  echo " ${___info[optarg-${lo}]:-}  "
  printf '%s\n\n' "${___info[option-${lo}]:-}"
done 

((${#___environment_variables[@]}>0)) && {
echo "
ENVIRONMENT
-----------
"

for e in "${!___environment_variables[@]}"; do
  printf '**%s**  \n' "$e"
  echo "${___info[env-${e}]}"
  echo
done
}

[[ -n ${___info[additional-info]:-}  ]] \
  && echo "${___info[additional-info]}"

[[ -n ${___dependencies[0]:-} ]] && {
echo "
DEPENDENCIES
------------
"
for d in "${___dependencies[@]}"; do
  echo "${d}  "
done
}
)"

___header="
${___name^^} 1 ${___created} Linux \"User Manuals\"
=======================================

NAME
----
"

___footer="$(
echo "
AUTHOR
------

${___author} <${___repo}>
"

[[ -n ${___see_also[0]:-} ]] && {
echo "
SEE ALSO
--------
"

s=""
for d in "${___see_also[@]}"; do
  s+="${d}, "
done
echo "${s%, }  "
}
)"
}
