function tempexpand(stuff,premd,txa,astf,nsub,expanderz,tmpfile) {
  expanderz=""

  split(stuff,txa," ")

  if (txa[1] ~ /^amani[[].*/) {
    sub("amani[[]","",txa[1])
    sub("[]]$","",txa[1])
    gsub("[][]"," ",txa[1])
    split(txa[1], astf, " ")
    if (length(astf)==1) {expanderz=amani[astf[1]]}
    else if (length(astf)==2) {expanderz=amani[astf[1]][astf[2]]}
    else if (length(astf)==3) {expanderz=amani[astf[1]][astf[2]][astf[3]]}
    else if (length(astf)==4) {expanderz=amani[astf[1]][astf[2]][astf[3]][astf[4]]}
  }

  else {
    expanderz=amani[txa[1]]
  }

  if (txa[2] ~ /[0-9]*:[0-9]*/) {
    split(txa[2],nsub,":")
    expanderz=substr(expanderz,nsub[1],nsub[2])
  }

  else if (txa[2] == "^^") {
    expanderz=toupper(expanderz)
  }

  # remove markdown
  if (templatevars["markdown"]=="false") {
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

  
  
  if (expanderz !~ /./) {expanderz=stuff}
  else {
    expanderz = wrapcheck(expanderz)
  }
  return gensub("\n$","","g",expanderz)
}
