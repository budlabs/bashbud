function readmanifest(ma,ach) {
  # esacpe single quotes
  gsub(sqo,sqol)

  if (match($0,/[[:space:]]*[#] (.*)[[:space:]]*$/,ma)) {


    # chain is if multiple variables are defined after
    # each other, then they will contain the same content.
    if (curvar && amantemp[curvar]=="X") {
      amantemp[curvar]="INCHAIN"
      if (chain == 0) {chain=curvar}
      else {chain=curvar " " chain }
    }

    curvar=ma[1]
    amantemp[curvar]="X"
    start=1
  }

  # start on first non blank line after definition
  else if (start==1 && $0 !~ /^[[:space:]]*$/) {
    start=2
  }

  if (start==2) {
    if (chain != 0) {
      split(chain,ach," ")
      for (k in ach) {
        achain[k]=curvar
      }
      chain=0
    } 

    amantemp[curvar]=$0
    start++
  }
  
  else if (start>2) {
    amantemp[curvar]=amantemp[curvar] "\n" $0
  }
}
