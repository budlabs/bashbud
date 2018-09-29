#!/bin/env bash

___printinfo(){

  setinfo

  case "$1" in
    # print version info to stderr
    version )
      printf '%s\n' \
        "$___name - version: $___version" \
        "updated: $___updated by $___author"
      ;;
    # print help in markdown format to stdout
    md ) printf '%s' "# ${___infoabout}" ;;

    lorem )
      ((${#___autoopts[@]}>0)) && {
        for o in "${!___autoopts[@]}"; do
          [[ -z ${___info[option-${o}]:-} ]] \
            && alorem+=("option-${o}")
        done
      }

      ((${#___environment_variables[@]}>0)) && {

        for e in "${!___environment_variables[@]}"; do
          [[ -z ${___info[env-${e}]:-} ]] \
            && alorem+=("env-${e}")
        done
      }

      [[ -z ${___info[long-description]:-} ]] \
        && echo "long-description"

      for l in "${alorem[@]}"; do
        echo "$l"
      done
    ;;
    # print help in markdown format to README.md
    mdg ) 
      ___composereadme > "${___dir:-.}/README.md"
    ;;
    
    # print help in troff format to __dir/__name.1
    man ) 
      mkdir -p "${___dir}/doc/man"
      printf '%s' "# ${___about}" > "${___dir}/doc/man/${___name}.md" 
      printf '%s' "${___header}" "${___about}" "${___footer}" | \
        go-md2man > "${___dir}/doc/man/${___name}.1"
    ;;

    vv )
      ___printprodcode 

      for ___f in "${___dir}/lib"/*; do
        [[ ${___f##*/} =~ ^(bashbud|bblib) ]] && continue
        cat "$___f"
      done
    ;;

    v ) 
      ___printprodcode 
      # include other files in /lib
      printf '%s\n' \
        'for ___f in "${___dir}/lib"/*; do' \
        '  [[ ${___f##*/} =~ ^(bashbud|bblib) ]] && continue' \
        '  source "$___f"' \
        'done'
    ;;

    

    # print help stripped of markdown to stderr
    * ) 
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
       ' | fold -80 -s
    ;;
  esac
}
