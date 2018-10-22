#!/usr/bin/env bash

___printversion(){
  printf '%s\n' \
    "$___name - version: $___version" \
    "updated: $___updated by $___author"
}

___printhelp(){

  ___setinfo

  printf '%s' "${___about}" | awk '
     BEGIN{ind=0}
     $0~/^```/{
       if(ind!="1"){ind="1"}
       else{ind="0"}
       print ""
     }
     $0!~/^```/{
       gsub("[`*]","",$0)
       if(ind=="1"){$0="   " $0}
       print $0
     }
   ' | fold "-${BASHBUD_INFO_FOLD:-80}" -s
 }


___setinfo(){
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
 [[ ${___info[option-${lo}]} = INCHAIN ]] && continue

 so="${___info[$o]:-}"
 [[ $so ]] \
   && printf '`--%s`|`-%s`' "$lo" "$so" \
   || printf '`--%s`' "$lo" 
 echo " ${___info[optarg-${lo}]:-}  "

 [[ ${___info[option-${lo}]} =~ ^CHAIN= ]] && {
   chain="$(echo "${___info[option-${lo}]}" | head -1)"
   ___info[option-${lo}]="$(echo "${___info[option-${lo}]}" | tail +2)"

   chain=${chain#*=}
   for c in ${chain}; do
     clo=${c#*-}
     cso="${___info[options-$clo]:-}"
     [[ $cso ]] \
       && printf '`--%s`|`-%s`' "$clo" "$cso" \
       || printf '`--%s`' "$clo" 
     echo " ${___info[optarg-${clo}]:-}  "
   done
 }

 printf '%s\n\n' "${___info[option-${lo}]:-}"
done 

((${#___environment_variables[@]}>0)) && {
echo "
ENVIRONMENT
-----------
"

for e in $(for eo in "${!___environment_variables[@]}"; do echo "$eo"; done | sort); do
 es="${e#*-}"
 printf '**%s**  \nDefaults to: %s  \n' "$es" "${___environment_variables[$e]}"
 [[ -n ${___info[env-${es}]:-} ]] && {
   echo "${___info[env-${es}]}"
 }
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
