function printformat(e,s,f,n,r,spliton,txa,cxa,i,l) {

  spliton = substr(e,1,1)
  split(e,txa,spliton)

  f = gensub(/[\\]n/,"\n","g",txa[2])
  i = 0
  for(k in txa) {
    if (k > 3 && k % 2 == 0) {
      i++
      if (txa[k] ~ /^amani.*/) {
        cxa[i] = tempexpand(txa[k])
      }
      else
        cxa[i] = txa[k]
    }
  }

  l = length(cxa)

  if (l == 0)
    r = sprintf(f)
  else if (l == 1)
    r = sprintf(f,cxa[1])
  else if (l == 2)
    r = sprintf(f,cxa[1],cxa[2])
  else if (l == 3)
    r = sprintf(f,cxa[1],cxa[2],cxa[3])
  else if (l == 4)
    r = sprintf(f,cxa[1],cxa[2],cxa[3],cxa[4])

  return r

}

