function wrapcheck(e,r,mdbody) {
  
  r=""
  # wrap paragraphs
  split(e,mdbody,"\n")

  for (k in mdbody) {
    mdline=mdbody[k]
    if (mdline ~ /%%%WRAPTHIS%%%$/) {
      sub(/%%%WRAPTHIS%%%$/,"",mdline)
      if (templatevars["wrap"]>0)
        mdline=wrap(mdline,templatevars["wrap"])
    }
    if (r=="") {r=mdline}
    else {r=r "\n" mdline}
  }

  return r
}
