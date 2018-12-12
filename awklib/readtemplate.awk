function readtemplate(r) {
  # end of template expand whole body
  # print to file, reset vars 
  if ($0 ~ /^___PRINT_TEMPLATE___.*/) {
    print templatevars["target"]
    if (templatevars["target"] != "")
      print expandbody(doca[0]) > templatevars["target"]
    templateinit()
  }

  # read template
  else if (gothead==1) {

    split($0,apa,"%%")
    
    if (apa[2] ~ /^for\s.*/) {
      currentbody++
      doca[currentbody]=""
      loopa[currentbody]=apa[2]
    }

    else if (apa[2] ~ /^done$/) {
      doca[currentbody-1] = doca[currentbody-1] loop(currentbody)
      currentbody--
    }

    else {
      r=$0
      if (currentbody==0 && apa[2] ~ /^printf\s.*/) {
        r=printformat(gensub("printf ","","g",apa[2]))
      } else {r = r "\n"}

      doca[currentbody]=doca[currentbody] r
      
    }
  }

  # end of head, reset temptarget
  else if (/^[.]{3}$/) {
    gothead=1
  }

  # read head variables
  else if ($0 !~ /^[-]{3}$/) {
    if ($1 == "wrap:") {templatevars["wrap"]=$2}
    else if ($1 == "target:") {templatevars["target"]=dir "/" $2}
    else if ($1 == "markdown:") {templatevars["markdown"]=$2}
  }

}
