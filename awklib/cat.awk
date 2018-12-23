function cat(e,r,trg,nfiles,filetype,cattype,catv,catfile,catdir,tmpfile) {
  catv=""
  nfiles=0
  split(e,ea," ")

  if (ea[1] == "-v") {catv=ea[2];trg=ea[3]}
  else {trg=ea[1]}

  trg = dir "/" trg

  catfile=gensub(".*/","","g",trg)
  catdir=gensub(catfile,"","g",trg)

  # if last arg is an int
  if (ea[length(ea)] ~ /^[0-9]*$/)
    nfiles=ea[length(ea)]

  # if fil ends with *: dir
  if (catfile == "*") {
    cattype="dir"
    catex = isdir(catdir)
  }
  else {
    cattype="file"
    catex = isfile(trg)
    filetype=gensub(/.*[.]/,"","g",trg)
  }

  # catex = 1 - file/dir doesnt exist
  if (catex==1) {r=""} 
  else {

    if (cattype=="dir") {

      # check if all files in dir have md extension
      cmd = "find " catdir " -maxdepth 1 -type f "
      cmd = cmd "| sed s/.*[.]// | sort -u"
      filetype=""
      while ( ( cmd | getline result ) > 0 ) {
        if (filetype == "") 
          filetype=result
        else
          filetype=filetype "\n" result
      }

      close(cmd)


      # find ./tmp -maxdepth 1 -type f | sed s/.*[.]// | sort -u
      cmd = "find " catdir " -maxdepth 1 -type f "
      cmd = cmd "-printf \"%C@ %p\\n\" | sort -rn "
      if (nfiles > 0) {
        cmd = cmd "| head -" nfiles " "
      }
      # if markdown files append new lines at EOF
      cmd = cmd "| cut -d ' ' -f2-9 | xargs "
      if (filetype == "md")
        cmd = cmd "-i sh -c \"cat {} && echo\""
      else
        cmd = cmd "cat"
    } else {
      cmd = "cat " trg
    }

    if (catv!="") {
      cmd = cmd " | grep -v " catv
    }

    tmpfile=""
    while ( ( cmd | getline result ) > 0 ) {
      if (tmpfile == "") 
          tmpfile=result
        else
          tmpfile=tmpfile "\n" result
    }

    close(cmd)

    if (filetype == "md") {
      tmpfile=mdcat(tmpfile)
      tmpfile=wrapcheck(tmpfile)
    }
    r=tmpfile
  } 
  

  return r

}
