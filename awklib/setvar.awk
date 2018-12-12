function setvar(e,k,v) {
  k=gensub(/\s+.*$/,"","g",e)
  v=gensub(/^\w+\s+/,"","g",e)
  print k
  print v
  templatevars[k]=tempexpand(v)
  print templatevars["target"]
}
