function readyaml() {
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
      synline=gensub(/[*]{2}.*/,"","g",synline)
      synline=gensub(/[|]/," | ","g",synline)

      oline=synline"  "
      split(synline,asl," ")
      
      curlink=0
      curarg=curshrt=curlng=""

      for (i in asl) {
        field=asl[i]

        if (field == "|") {curlink=lastopt}


        # longoptions:
        else if (match(field,/^[[]?--(\w+)/,ma)) {
          curlng=ma[1]
          if (optnum[curlng] !~ /./) {optnum[curlng] = curopt++}
          gsub(/[][]/,"",field)
          gsub(field" ","`"field"` ",oline)
          if (curlink!=0) var=curlink; else var=""
          lastopt=curlng
          amani["options"][optnum[curlng]][curlng]["short"]=var
          # amani["options"][curlng]["long"]=curlng
          lastkey=curlng
          curlink=0
        }

        # shortoption:
        else if (match(field,/^[[]?[-]([a-zA-Z])/,ma)) {
          curshrt=ma[1]
          gsub(field" ","`"field"` ",oline)
          lastopt=curshrt
          if (curlink!=0) amani["options"][optnum[curlink]][curlink]["short"]=curshrt
          lastkey=curlink
          curlink=0
        }

        # arguments
        else if (match(field,/^[^[](\w+)[]]?$/,ma)) {
          amani["options"][optnum[lastkey]][lastkey]["arg"]=ma[1]
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
    # gsub(/[$]/,"\\$",rol)

    amani[gensub("-","_","g",parkey)][asindx++][gensub("-","_","g",curkey)]["default"]=rol
  } 

  # indexed array list
  else if (curind>0 && iskey==0 && islist==1) {
    amani[gensub("-","_","g",parkey)][isindx][listitem]["index"]=isindx
    isindx++
  } 

  # indexed array brackets
  else if (iskey==1 && rol ~ /^[[]/) {
    thislist=gensub(/[][]/,"","g",rol)
    gsub(/[[:space:]]*/,"",thislist)
    isindx=0
    split(thislist,la,",")
    for (li in la) {
      amani[gensub("-","_","g",curkey)][isindx][la[li]]["index"]=isindx
      isindx++
      # amani[gensub("-","_","g",curkey)][isindx++]=la[li]
    }
  } 

  # normal key
  else if (rol !~ /^[[>|{]/ && rol ~ /./ && iskey==1) {
    amani[curkey]=rol
  }


  if (iskey==1) {lastkey=curkey;curkey=""}
  if (lastind!=curind) {lastind=curind}
}
