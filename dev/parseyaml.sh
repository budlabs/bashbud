#!/usr/bin/env bash

___parseyaml(){
  local f="$1"

  awk '
    BEGIN {
      aafrm="___%s[%s-%s]=\"%s\"\n"
      iafrm="___%s+=(\"%s\")\n"
    }
    /./ && match($0,/([[:space:]]*)([-]{,1})[[:space:]]*([0-9a-zA-Z_-]*)([:]{,1})[[:space:]]*(.*)[[:space:]]*$/,ma) {
      iskey=islist=0
      curind=length(ma[1])
      rol=ma[5]

      if (curind > lastind) {parkey=lastkey;asindx=0}
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
        gsub(/[$]/,"\\$",rol)
        printf  aafrm, gensub("-","_","g",parkey), asindx++, curkey, rol
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
