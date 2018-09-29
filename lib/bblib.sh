#!/bin/env bash


___autoparse(){
  local ln sn au

  # parse all help and version option
  # and all options marked with +

  declare -A options
  declare -A shortoptions

  ((${#___environment_variables[@]}>0)) \
    && eval "$(
    for e in "${!___environment_variables[@]}"; do
      printf '%s=\"${%s:=%s}\"\n' \
        "$e" "$e" "${___environment_variables[$e]}"
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
  sopt="h::v::"

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

  __hasoption=0

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
        eval __"$pl"='${pa}'
        [[ ${options[$pl]} =~ [:] ]] && [[ -n $pa ]] && shift 
        __hasoption=1
        pl=pa=po=""
      ;;
      version ) 
        [[ -z ${pa:-} ]] \
          && ___printinfo "version" >&2 \
          || ___printinfo "${pa:-}"
          exit
      ;;
      help    ) ___printinfo "${pa:-}" >&2        ; exit  ;;
      -- ) shift ; break ;;
      *  ) break ;;
    esac
    shift
  done

  [[ ${__lastarg:="${!#:-}"} = -- ]] \
    && __lastarg= \
    || true
}

___composereadme(){

  local rmdir="${___dir:-.}/doc/readme"

  # TITLE
  printf '# **%s** - %s\n' "${___name}" "${___description}"

  declare -A content
  tocfrm='\[ [%s](#%s) \] '

  echo
  echo -n "#### "

  # [TOC]

  [[ -n ${___info[long-description]:-} ]] && {
    content[about]=about
    printf "${tocfrm}" "${content[about]}" "${content[about]}"
  }

  [[ -f $rmdir/install.md ]] && {
    content[install]=installation
    printf "${tocfrm}" "${content[install]}" "${content[install]}"
  }

  [[ -n "${___synopsis:-}" ]] && {
    content[usage]=usage
    printf "${tocfrm}" "${content[usage]}" "${content[usage]}"
  }

  [[ -d "${___dir}/doc/release" ]] && [[ "$(ls -A "${___dir}/doc/release")" ]] && {
    content[updates]=updates
    printf "${tocfrm}" "${content[updates]}" "${content[updates]}"
  }

  echo
  echo

  # [BANNER]
  [[ -f $rmdir/banner.md ]] && {
    cat "$rmdir/banner.md"
    echo
  }

  # [INSTALLATION]
  [[ -n ${content[install]:-} ]] && {
    echo "# ${content[install]}"
    cat "$rmdir/install.md"
    echo
  }

  # [LONG DESCRIPTION]
  [[ -n ${content[about]:-} ]] && {
    echo "# ${content[about]}"
    echo "${___info[long-description]}"
    echo
  }

  # [USAGE] (synopsis+options)
  [[ -n ${content[usage]:-} ]] && {
    echo "# ${content[usage]}"
    echo
    echo '```shell'
    echo "${___synopsis}" | awk '{gsub(/[`*]/,"");print}'
    echo '```'

    for o in $(printf '%s\n' "${!___info[@]}" | sort); do
      [[ $o =~ ^options ]] || continue
      lo=${o#*-}
      [[ -z ${___info[option-${lo}]:-} ]] && continue
      so="${___info[$o]:-}"
      echo
      [[ $so ]] \
        && printf '`--%s`|`-%s`' "$lo" "$so" \
        || printf '`--%s`' "$lo" 
      echo " ${___info[optarg-${lo}]:-}  "
      printf '%s\n\n' "${___info[option-${lo}]:-}"
    done
    
  }

  echo
  # [UPDATES]
  [[ -n ${content[updates]:-} ]] && {
    echo "# ${content[updates]}"
    echo
    (
      cd ${___dir}/doc/release || exit 1
      rels=($(ls -t *.md | head -3))
      for r in "${rels[@]}"; do
        echo "**${r%.md}**  "
        cat "$r"
        echo
      done
    )
    echo
  }

  # [FOOTER]
  [[ -f $rmdir/footer.md ]] && {
    echo "---"
    echo
    cat "$rmdir/footer.md"
    echo
  }
}

___parsemanifest(){
  local f="$1"
  awk '
  BEGIN {sqo="'"'"'";sqol=sqo "\"" sqo "\"" sqo}
  {
    # esacpe single quotes
    gsub(sqo,sqol)

    if (match($0,/[[:space:]]*[#] (long|option|env)-(.*)[[:space:]]*$/,ma)) {
      curvar=ma[1]"-"ma[2]
      start=1
    }



    else if (start==1 && $0 !~ /^[[:space:]]*$/) {start++;blanks=0}
    if (start==2) {avar[curvar]=$0;start++}
    
    else if (start>2 && $0 ~ /^[[:space:]]*$/) {blanks++}
    else if (start>2) {
      nl="\n"
      for (i=0;i<blanks;i++){
        nl=nl "\n"
      }
      avar[curvar]=avar[curvar] nl $0
      blanks=0
    }
  }
  END {
    for (k in avar) {
      printf "___info[%s]="sqo"%s"sqo"\n", k, avar[k]
    }

  }
  ' "$f"
}

___parseyaml(){
  local f="$1"

  awk '
    BEGIN {
      aafrm="___%s[%s]=\"%s\"\n"
      iafrm="___%s+=(\"%s\")\n"
    }
    /./ && match($0,/([[:space:]]*)([-]{,1})[[:space:]]*([a-zA-Z_-]*)([:]{,1})[[:space:]]*(.*)[[:space:]]*$/,ma) {
      iskey=islist=0
      curind=length(ma[1])
      rol=ma[5]

      if (curind > lastind) {parkey=lastkey}
      if (curind < lastind && $0 !~ /^[[:space:]]*$/) {
        block="none"
      }
      
      if (ma[4]==":") {
        curkey=ma[3]
        iskey=1
      }

      if      (rol==">" && iskey=1) {block="fold";binx=0}
      else if (rol=="|" && iskey=1) {block="block";binx=0}
      else if (block=="fold" && (curind>0 || $0 ~ /^[[:space:]]*$/)) {
        iskey=0
        if   (binx==0) {
          folds[parkey]=gensub(/^[[:space:]]*/,"","g",$0)
          binx++
        }

        else {
          folds[parkey]=folds[parkey] gensub(/^[[:space:]]*/," ","g",$0)
        }
      }
      else if (block=="block" && (curind>0 || $0 ~ /^[[:space:]]*$/)) {
        iskey=0
        if   (binx==0) {
          blocks[parkey]=gensub(/^[[:space:]]*/,"","g",$0)
          binx++
        }

        else {
          blocks[parkey]=blocks[parkey] gensub("^[[:space:]]{"lastind"}","\n","g",$0)
        }
      }

      else if (ma[2]=="-") {
        islist=1
        listitem=gensub(/^[[:space:]]*[-][[:space:]]*/,"","g",$0)
      }

      # associative array
      if (curind>0 && iskey==1) {
        printf  aafrm, gensub("-","_","g",parkey), curkey, rol
      } 

      # indexed array list
      else if (curind>0 && iskey==0 && islist==1) {
        printf  iafrm, gensub("-","_","g",parkey), listitem
      } 

      # indexed array brackets
      else if (iskey==1 && rol ~ /^[[]/) {
        thislist=gensub(/[][]/,"","g",rol)
        gsub(/[[:space:]]*/,"",thislist)
        split(thislist,la,",")
        for (li in la) {
          printf  iafrm, gensub("-","_","g",curkey), la[li]
        }
      } 

      # normal key
      else if (rol !~ /^[[>|{]/ && rol ~ /./ && iskey==1) {
        print "___" curkey "=\"" rol "\""
      }


      if (iskey==1) {lastkey=curkey;curkey=""}
      if (lastind!=curind) {lastind=curind}
    }
    END {
      for (f in folds) {
        print "___" f "=\"" folds[f] "\""
      }
      for (f in blocks) {
        print "___" f "=\"" blocks[f] "\""
      }
    }
  ' "$f"
}

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

___printprodcode(){

  local infformat e o

  infformat='%s\n%s \\\n'"'"'%s'"'"'\n}\n'

  # --version info
  printf "$infformat" \
    '___printversion(){' '>&2 echo' "$(___printinfo version)"
  
  echo 

  echo 'OFS="${IFS}"'
  echo "IFS=\$' \n\t'"
  echo

  # if envrionemt variables are defined in manifest
  ((${#___environment_variables[@]}>0)) && {
    for e in "${!___environment_variables[@]}"; do
      printf '%s=\"${%s:=%s}\"\n' \
        "$e" "$e" "${___environment_variables[$e]}"
    done

    echo
  }

  # --help
  printf "$infformat" \
    '___printhelp(){' '>&2 echo' "$(
      ___printinfo help | sed 's/'"'"'/'"'"'"'"'"'"'"'"'/g'
    )"
  
  echo

  # getopts start
  printf 'eval set -- "$(getopt --name "%s" \\\n' "$___name"
  printf '  --options "%s" \\\n' "${___vvsopts//::/}"
  printf '  --longoptions "%s" \\\n' "${___vvlopts%,}"
  printf '  -- "$@"\n)"\n'

  echo
  echo '__hasopts=0'
  echo

  printf 'while true; do\n  case "$1" in\n'
  printf '    %s ; exit ;;\n' \
    '-v | --version ) ___printversion' \
    '-h | --help ) ___printhelp'

  ((${#___autoopts[@]}>0)) && for o in "${!___autoopts[@]}"; do
    echo -n "    "
    [[ -n ${___autoopts[$o]:-} ]] \
      && echo -n "-${___autoopts[$o]//:} | "
    echo -n "--$o ) "
    isflag=0
    for f in "${___vvflags[@]}"; do
      [[ $f = "$o" ]] && isflag=1
    done
    ((isflag==1)) \
      && echo -n "__${o}=1" \
      || echo -n "__${o}=\"\${2:-}\" ; shift" 
    echo " ; __hasopts=1 ;;"
  done

  printf '    %s ;;\n' \
    '-- ) shift ; break' \
    '*  ) break'


  printf '  %s\n  %s\n%s\n' "esac" "shift" "done"

  # getopts end
  echo

  # __lastarg
  printf '%s\n  %s\n  %s\n' \
    '[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \' \
    '&& __lastarg="" \' \
    '|| true'
  
  echo

  # include __stdin if it is used in main script
  grep '.*__stdin.*' "${___source}"  > /dev/null 2>&1 && {
    printf '%s\n' '__=""' '__stdin=""' 'read -N1 -t0.01 __  && {'
    echo '  (( $? <= 128 ))  && {'
    printf '    %s\n' \
      "IFS= read -rd '' __stdin" \
      '__stdin="$__$__stdin"'
    printf '  }\n}\n'
  }
  echo

  echo 'IFS="${OFS}"'

}

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

OFS="${IFS}"
IFS=$' \n\t'

declare -A ___info
declare -A ___environment_variables
declare -A ___autoopts

___file="${___dir}/$(basename "${___source}")"
___name="$(basename "${___file}" .sh)"
__=""
__stdin=""

read -N1 -t0.01 __  && {
  (( $? <= 128 ))  && {
    IFS= read -rd '' __stdin
    __stdin="$__$__stdin"
  }
}

eval "$(___parsemanifest <(
  awk 'start==1{print}; $0=="..." {start=1}' \
    "${___dir}/manifest.md"
  [[ -d ${___dir}/doc/info ]] && {
    for infofile in "${___dir}/doc/info/"*.md; do
      cat "$infofile"
    done
  }
  )
)"


eval "$(___parseyaml <(
  awk '$0=="..." {exit};$0!="---" {print}' \
    "${___dir}/manifest.md"
  )
)"

___autoparse "${@}"

for ___f in "${___dir}/lib"/*; do
  [[ ${___f##*/} =~ ^(bashbud|bblib) ]] && continue
  source "$___f"
done

IFS="${OFS}"
