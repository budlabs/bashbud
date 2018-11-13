#!/usr/bin/env bash

bumpproject(){
  local project curpath

  project="${1:-}"
  
  eval "$(getproject "$project")"

  [[ -z ${curpath:-} ]] \
    && ERX "could not find project: $project"

  curpath="${curpath/'~'/$HOME}"

  echo "$(dateupdate -bu "${curpath}/manifest.md")" \
    > "${curpath}/manifest.md"

  generate "$curpath"

}

generate(){
  local dir

  dir="${1:-.}"

 [[ $dir = "." ]] \
    && name="${PWD##*/}" \
    || name="${dir##*/}"

  echo "arne $name"
  if [[ -d ${dir}/generators ]]; then
    gendir="$dir/generators"
  elif [[ -d ${BASHBUD_DIR}/generators ]]; then
    gendir="${BASHBUD_DIR}/generators"
  elif [[ -d /usr/share/doc/bashbud/generators ]]; then
    gendir="/usr/share/doc/bashbud/generators"
  else
    ERX "no generators found"
  fi

  awk -v name="$name" -v dir="$dir" '

    function isfile(file) {
      cmd = "[ -f " file " ]"

      result = system(cmd)

      close(cmd)

      # exist=0 
      return result
    }

    function isdir(dir) {
      cmd = "[ -d " dir " ]"

      result = system(cmd)

      close(cmd)

      # exist=0 
      return result
    }

    function getif(expression) {
      doprint=0

      split(expression,txa," ")

      if (length(txa)==1) {
        if (amani[expression] ~ /./) {
          doprint=1
        }
      }
    }

    function tempexpand(stuff) {
      expanderz=""

      split(stuff,txa," ")

      if (length(txa)==1) {
        expanderz=amani[stuff]
      }

      else if (txa[1]=="cat") {

        tmpfile=""

        fil=dir "/" txa[2]

        catfile=gensub(".*/","","g",fil)
        catdir=gensub(catfile,"","g",fil)
        return "sss"

        # if fil ends with *: dir
        if (catfile == "*") {
          cattype="dir"
          catex = isdir(catdir)
          return catdir
        }
        else {
          cattype="file"
          catex = isfile(fil)
        }

        if (catex==1) {
          expanderz=""
        } else {
          tmpfile="KKKK: " catdir "\n\n"
          # check if file/dir exist
          # if dir and txa[3] is int, cat n latest

          cmd = "cat " fil " | fold -40 -s"

          while ( ( cmd | getline result ) > 0 ) {
            tmpfile=tmpfile "\n" result
          }

          close(cmd)

          expanderz=tmpfile
        } 
      }

      # remove markdown
      if (tempmarkdown=="false") {
        ind=0
        premd=""

        split(expanderz,mda,"\n")

        for (l in mda) {
          line=mda[l]
          if (line ~ /^```/) {
            if(ind!="1"){ind="1"}
            else{ind="0"}
            premd=premd "\n"
          }
          else {
            gsub("[`*]","",line)
            if(ind=="1"){line="   " line}
            premd=premd line "\n"
          }
        }

        expanderz=premd

      }

      return expanderz
    }

    function templateinit(){
      tempwrap=0
      temptarget=""
      tempmarkdown="true"
      gothead=0
      doprint=1
    }

    BEGIN {
      sqo="'"'"'"
      sqol=sqo "\"" sqo "\"" sqo
      reading=0

      aafrm="___%s[%s-%s]=\"%s\"\n"
      iafrm="___%s+=(\"%s\")\n"

      amani["name"]=name
    }

    mark=0
    $0=="---" && reading==0 {reading="yaml";mark=1}
    $0=="..." && reading=="yaml" {reading="manifest";mark=1}
    $0=="___START___" && reading=="manifest" {
      reading="templates"
      mark=1
      templateinit()
    }

    mark!=1 && reading=="templates" {

      if ($0 ~ /^___PRINT_TEMPLATE___.*/) {gothead=0}

      else if (gothead==1) {
        split($0,apa,"%%")

        if (apa[2] ~ /^if\s.*/) {
          getif(gensub("if ","","g",apa[2]))
        }

        else if (apa[2] ~ /^fi$/) { doprint=1 }

        else {
          if ($0 != "") {
            for (k in apa) {
              if (k%2==0) {
                sub("%%"apa[k]"%%",tempexpand(apa[k]),$0)
                print "sss" apa[k]  >> temptarget
              }
            }
          }

          if (doprint==1)
            print >> temptarget
        }
      }

      else if (/^[.]{3}$/) {
        gothead=1
        printf "" > temptarget
      }

      else if ($0 !~ /^[-]{3}$/) {
        if ($1 == "wrap:") {tempwrap=$2}
        else if ($1 == "target:") {temptarget=$2}
        else if ($1 == "markdown:") {tempmarkdown=$2}
      }

    }

    mark!=1 && reading=="manifest" {
      # esacpe single quotes
      gsub(sqo,sqol)

      if (match($0,/[[:space:]]*[#] (additional|long|option|env)-(.*)[[:space:]]*$/,ma)) {

        if (curvar && avar[curvar]=="X") {
          amani[curvar]="INCHAIN"
          if (chain == 0) {chain=curvar}
          else {chain=curvar " " chain }
        }

        curvar=ma[1]"-"ma[2]
        amani[curvar]="X"
        start=1
      }

      else if (start==1 && $0 !~ /^[[:space:]]*$/) {start++;blanks=0}
      if (start==2) {
        if (chain != 0) {
          amani[curvar]="CHAIN=" chain "\n" $0
          chain=0
        } 
        else
          amani[curvar]=$0
        start++
      }
      
      else if (start>2 && $0 ~ /^[[:space:]]*$/) {blanks++}
      else if (start>2) {
        nl="\n"
        for (i=0;i<blanks;i++){
          nl=nl "\n"
        }
        amani[curvar]=amani[curvar] nl $0
        blanks=0
      }
    }

    mark!=1 && reading=="yaml" && /./ && match($0,/([[:space:]]*)([-]{,1})[[:space:]]*([0-9a-zA-Z_-]*)([:]{,1})[[:space:]]*(.*)[[:space:]]*$/,ma) {
      iskey=islist=0
      curind=length(ma[1])
      rol=ma[5]

      if (curind > lastind) {parkey=lastkey;asindx=0;isindx=0}
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
          amani[parkey]=gensub(/^[[:space:]]*/,"","g",$0)
          binx++
        }

        else {
          amani[parkey]=amani[parkey] gensub(/^[[:space:]]*/," ","g",$0)
        }
      }

      else if (block=="block" && (curind>0 || $0 ~ /^[[:space:]]*$/)) {
        iskey=0
        if   (binx==0) {
          amani[parkey]=gensub(/^[[:space:]]*/,"","g",$0)
          binx++
        }

        else {
          amani[parkey]=amani[parkey] gensub("^[[:space:]]{"lastind"}","\n","g",$0)
        }

        # SYNOPSIS
        if (parkey="synopsis") {
          synline=gensub(/^[[:space:]]*/,"","g",$0)
          synline=gensub(/[][]/,"","g",synline)
          synline=gensub(/[*]{2}.*/,"","g",synline)
          synline=gensub(/[|]/," | ","g",synline)

          oline=synline"  "
          split(synline,asl," ")
          
          curopt=curlink=0
          curarg=curshrt=curlng=""

          for (i in asl) {
            field=asl[i]

            if (field == "|") {curlink=lastopt}

            # longoptions:
            else if (match(field,/^--(\w+)/,ma)) {
              curlng=ma[1]
              gsub(field" ","`"field"` ",oline)
              if (curlink!=0) var=curlink; else var=""
              lastopt=curlng
              optar[curlng]["short"]=var
              lastkey=curlng
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
            else {
              optar[lastkey]["arg"]=field
            }
          }
        }
      }

      else if (ma[2]=="-") {
        islist=1
        listitem=gensub(/^[[:space:]]*[-][[:space:]]*/,"","g",$0)
      }

      # associative array
      if (curind>0 && iskey==1) {
        gsub(/[$]/,"\\$",rol)
        amani[gensub("-","_","g",parkey)][asindx++][curkey]=rol
      } 

      # indexed array list
      else if (curind>0 && iskey==0 && islist==1) {
        amani[gensub("-","_","g",parkey)][isindx++]=listitem
      } 

      # indexed array brackets
      else if (iskey==1 && rol ~ /^[[]/) {
        thislist=gensub(/[][]/,"","g",rol)
        gsub(/[[:space:]]*/,"",thislist)
        isindx=0
        split(thislist,la,",")
        for (li in la) {
          amani[gensub("-","_","g",curkey)][isindx++]=la[li]
        }
      } 

      # normal key
      else if (rol !~ /^[[>|{]/ && rol ~ /./ && iskey==1) {
        amani[curkey]=rol
      }


      if (iskey==1) {lastkey=curkey;curkey=""}
      if (lastind!=curind) {lastind=curind}
    }

    END {

    }


  ' <(
    cat "$dir/manifest.md"
    [[ -d $dir/manifest.d ]] \
      && cat "$dir/manifest.d/"*
    echo "___START___"
    for d in "$gendir"/* ; do
      [[ -d $d ]] || continue

      [[ -f $d/template ]] && {
        cat "$d/template"
        echo "___PRINT_TEMPLATE___${d##*/}"
      }
    done
  )
}
