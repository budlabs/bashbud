#!/usr/bin/env bash

___autoparse(){
  local ln sn au

  # parse all help and version option
  # and all options marked with +

  declare -A options
  declare -A shortoptions

  ((${#___environment_variables[@]}>0)) \
    && eval "$(
    for e in $(for eo in "${!___environment_variables[@]}"; do echo "$eo"; done | sort); do
      es="${e#*-}"
      printf '%s=\"${%s:=%s}\"\n' \
        "$es" "$es" "${___environment_variables[$e]}"
    done
  )"

  # echo "$(echo "${___synopsis}" \
  eval "$(echo "${___synopsis}" \
    | sed 's/\([][|]\)/ \1 /g' | awk -v scriptname="${___name}" '
    BEGIN{
      arpf="options[%s]=\"%s\"\n"
      argfrm="___info[optarg-%s]=\"%s\"\n"
      inffrm="___info[options-%s]=\"%s\"\n"
      synfrm="___synopsis='"'"'%s'"'"'"
    }
    /./ {
      oline=$0"  "
      
      curopt=curlink=0
      curarg=curshrt=curlng=""
      for (i=1;i<NF+1;i++) {
        field=$i
        if (field == "|") {curlink=lastopt}
        else if (field == "[") {curoptional=1}
        else if (field == "]") {curoptional=0}
        # longoptions:
        else if (match(field,/^--(\w+)/,ma)) {
          curlng=ma[1]
          gsub(field" ","`"field"` ",oline)
          if (curlink!=0) var=curlink; else var=""
          lastopt=curlng
          optar[curlng]["short"]=var
          lastkey=curlng
          # printf arpf, curlng, var
          curlink=0
        }
        
        # shortoption:
        else if (match(field,/^[-]([a-zA-Z])/,ma)) {
          curshrt=ma[1]
          gsub(field" ","`"field"` ",oline)
          lastopt=curshrt
          if (curlink!=0) optar[curlink]["short"]=curshrt
          lastkey=curlink
          curlink=0
        }

        # arguments
        else if (field !~ /^[*][*]/) {
          optar[lastkey]["arg"]=field
        }
        
      }
      gsub(/\s\|\s/,"|",oline)
      gsub(" [[] ","[",oline)
      gsub(" []] ","]",oline)
      synform=synform sprintf("%s %s\n",scriptname, oline)
    }
    END {
      
      for (l in optar) {
        val=""
        if (optar[l]["short"] ~ /./) val=optar[l]["short"]
        printf inffrm, l, val
        if (optar[l]["arg"] ~ /./) {
          val=val":"
          printf argfrm, l, optar[l]["arg"]
        }
        val=val"+"
        printf arpf, l, val
      }
      printf arpf, "help", "h::"
      printf inffrm, "help", "h"
      printf arpf, "version", "v::"
      printf inffrm, "version", "v"
      printf synfrm, synform 
    }
  ')"


  for ln in "${!options[@]}"; do
    sn=au=
    [[ ${options[$ln]} =~ ^([a-zA-Z]{,1})(:*)([+]*)$ ]] && {
      sn=${BASH_REMATCH[1]}
      au=${BASH_REMATCH[3]}
    }

    [[ -n $sn ]] && shortoptions[$sn]="$ln"
    if [[ $au = + ]]; then
      ___autoopts[$ln]="${options[$ln]%+}"
      aure+="${ln}|"
    fi
  done

  aure="+(${aure%|})"

  lopt="help,version,"
  sopt="hv::"

  for o in "${!___autoopts[@]}"; do
    [[ ${___autoopts[$o]} =~ ([:]*)$ ]] \
      && kol="${BASH_REMATCH[1]:-}"
    lopt+="$o$kol,"
    sopt+="${___autoopts[$o]}"
    [[ -z $kol ]] && eval __"$o"=0 && ___vvflags+=("${o}")
  done

  ___vvlopts="$lopt"
  ___vvsopts="$sopt"
  eval set -- "$(getopt --name "${___name}" \
    --options "$sopt" \
    --longoptions "$lopt" \
    -- "$@"
  )"

  while true; do
    if [[ $1 = -- ]];then
      po="$1"
    else
      po="${1##--}" 
      po="${po##-}"
      if ((${#po}==1)); then
        pl="${shortoptions[$po]}"
      else
        pl="$po"
      fi

      if [[ ${options[$pl]:-} =~ [:] ]]; then
        pa="${2:-}" 
      else
        pa=1
      fi
    fi

    shopt -s extglob

    case "${pl:-}" in
      $aure  ) 
        eval __o["$pl"]='${pa}'
        [[ ${options[$pl]} =~ [:] ]] && [[ -n $pa ]] && shift 
        pl=pa=po=""
      ;;
      version ) 
        [[ -z ${pa:-} ]] \
          && ___callfunc "printversion" >&2 \
          || ___callfunc "${pa:-}"
          exit
      ;;
      help    ) ___printhelp >&2        ; exit  ;;
      -- ) shift ; break ;;
      *  ) break ;;
    esac
    shift
  done

  [[ ${__lastarg:="${!#:-}"} = -- ]] \
    && __lastarg= \
    || true
}
