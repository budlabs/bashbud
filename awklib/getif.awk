function getif(expression,trg,txa,r) {
  r=1

  split(expression,txa," ")

  if (txa[1] ~ /^amani[[].*/) {
    sub("amani[[]","",txa[1])
    sub("[]]$","",txa[1])
    gsub("[][]"," ",txa[1])
    split(txa[1], astf, " ")
    if (length(astf)==1) {trg=amani[astf[1]]}
    else if (length(astf)==2) {trg=amani[astf[1]][astf[2]]}
    else if (length(astf)==3) {trg=amani[astf[1]][astf[2]][astf[3]]}
    else if (length(astf)==4) {trg=amani[astf[1]][astf[2]][astf[3]][astf[4]]}
  }
  else {
    trg=amani[txa[1]]
  }

  if (length(txa)==1 && trg ~ /./) {
    r=0
  } else {
    switch (txa[2]) {
      case "=":
        if (trg == txa[3]) {r=0}
      break

      case "!=":
        if (trg != txa[3]) {r=0}
      break
    }
  }

  return r
}
