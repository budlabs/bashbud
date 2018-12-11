# cb = currentbody
function loop(cb,rets,obj,alias,body,r,i,j,k,repla,atl) {
  rets=""

  split(loopa[cb],la," ")

  obj=la[4]
  alias=la[2]

  body=gensub(/\n$/,"","g",doca[cb])
  # amani["env"][1]["one"]=val1
  for (i=0;i<length(amani[obj]);i++) {
  split(body,atl,"\n")
    for (k in amani[obj][i]) {

      for (l in atl) {
        # replace standalone alias with keyname (%%ALIAS%% -> %%k%%)
        repla = gensub("(.*("sqo"|\"|%|[[:space:]]))+(" alias ")(("sqo"|\"|%|[[:space:]])+.*)", "\\1"k"\\4", "g", atl[l])
        # replace alias[KEY] (%%alias[KEY]%% -> %%amani[obj][i][k][KEY]%%)
        # repla = gensub("^(.*("sqo"|\"|%|[[:space:]]))+(" alias "[[])(.*[]]("sqo"|\"|%|[[:space:]])+.*)$", "\\1amani["obj"]["i"]["k"][\\4", "g", repla)
        repla = gensub("^(.*("sqo"|\"|%|[[:space:]]))+(" alias "[[])(.*[]]("sqo"|\"|%|[[:space:]])+.*)$", "\\1amani["obj"]["i"]["k"][\\4", "g", repla)
        repla = gensub("(.*("sqo"|\"|%|[[:space:]]))+(" obj "[[]" alias "[]])(("sqo"|\"|%|[[:space:]])+.*)", "\\1amani["obj"]["i"]["k"]\\4", "g", repla)
        atl[l]=repla
      }
     

      break
    }

    for (l in atl) { 
      if (l==1) 
        r=atl[l]
      else
        r=r "\n" atl[l]
    }

    r = expandbody(r)
    if (rets=="") {rets=r}
    else {rets=rets r}
  }


  return rets

}
