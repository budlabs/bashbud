function expandbody(body,r,lastif,toreplace,toexpand) {

  lastif=0
  doprint=1
  r=""

  split(body,bodylines,"\n")
  for (lbline in bodylines) {

    split(bodylines[lbline],lapa,"%%")

    if (lapa[2] ~ /^if\s.*/) {
      if (lastif==0) {
        lastif+=getif(gensub("if ","","g",lapa[2])) 
      }
      else
        lastif++

      if (lastif==0) 
        doprint=1
      else
        doprint=0
    }      

    else if (lapa[2] ~ /^else$/) { 
      if (lastif==1)
        doprint=1
      else
        doprint=0
    }
    else if (lapa[2] ~ /^fi$/) {
      lastif--
      if (lastif<1) {lastif=0;doprint=1} 
    }
    else if (lapa[2] ~ /^var\s.*$/) {
      setvar(gensub(/^var /,"","g",lapa[2]))
    }


    else if (doprint==1) {

      if(lapa[2] ~ /^cat\s.*/) {
        bodylines[lbline]=cat(gensub(/^cat /,"","g",lapa[2]))
      }

      else if (lapa[2] !~ /^printf\s.*/) {
        for (l in lapa) {
          if (l%2==0) {
            toexpand=lapa[l]
            toreplace=gensub("[*]","[*]","g",lapa[l])
            toreplace=gensub("[[]","@@@@","g",toreplace)
            toreplace=gensub("[]]","[]]","g",toreplace)
            toreplace=gensub("@@@@","[[]","g",toreplace)
            sub("%%"toreplace"%%",tempexpand(toexpand),bodylines[lbline])
          }
        }
      }

      else {
        bodylines[lbline]=printformat(gensub("printf ","","g",lapa[2]))
      }

      if (r=="") {r=bodylines[lbline]}
      else {r=r bodylines[lbline]}
      if  (lapa[2] !~ /^printf\s.*/) {r=r "\n"}
    }
  }

  return r
}
