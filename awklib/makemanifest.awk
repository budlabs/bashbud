# loop manifest array
# reorder to amani array
function makemanifest(oname,okey,oarr,obj,ii,kk,kkk,k) {

  # concatenate markdown
  for (k in amantemp) {
    
    amantemp[k]=mdcat(amantemp[k])
    # if (k == "environ-BASHBUD_DATEFORMAT-description")
    #   print amantemp[k]
  }

  # fix chains
  for (k in achain) {
    amantemp[k]=amantemp[achain[k]]
  }

  for (k in amantemp) {
    # if key contains dashes, assume array
    split(k,oarr,"-")
    if (length(oarr)>1) {
      ii="X"
      obj=oarr[1]
      oname=oarr[2]
      okey=oarr[3]

      for (i=0;i<length(amani[obj]);i++) {
        for (kk in amani[obj][i]) {
          kkk=kk
          break
        }

        if (kkk == oname) {
          ii = i
          break
        }
      }

      if (ii != "X") {
        amani[obj][ii][kkk][okey]=amantemp[k]
      }
    }

    # no dashes just move to amani
    else {
      amani[k]=amantemp[k]
    }
  }

}
