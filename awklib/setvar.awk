function setvar(e,k,v) {
  k=gensub(/\s+.*$/,"","g",e)
  v=gensub(/^\w+\s+/,"","g",e)
  templatevars[k]=v
}
