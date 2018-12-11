function tempexpand(stuff,premd,txa,astf,expanderz,tmpfile) {
  expanderz=""

  split(stuff,txa," ")


  if (length(txa)==1) {

    if (stuff ~ /^amani[[].*/) {
      sub("amani[[]","",stuff)
      sub("[]]$","",stuff)
      gsub("[][]"," ",stuff)
      split(stuff, astf, " ")
      if (length(astf)==1) {expanderz=amani[astf[1]]}
      else if (length(astf)==2) {expanderz=amani[astf[1]][astf[2]]}
      else if (length(astf)==3) {expanderz=amani[astf[1]][astf[2]][astf[3]]}
      else if (length(astf)==4) {expanderz=amani[astf[1]][astf[2]][astf[3]][astf[4]]}
    }

    else {
      expanderz=amani[stuff]
    }
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
  # fold

  if (length(expanderz)>templatevars["wrap"] && templatevars["wrap"] != 0) {
    tmpfile=""
    cmd = "echo " sqo expanderz sqo " | fold -" templatevars["wrap"] " -s"

    while ( ( cmd | getline result ) > 0 ) {
      tmpfile=tmpfile "\n" result
    }

    close(cmd)
    expanderz=tmpfile
  }
  

  return gensub("\n$","","g",expanderz)
}
