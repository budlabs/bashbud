function cat(e,r,trg,cea,catsort,catorder,nfiles,narg,ea,filetype,cattype,catv,catfile,catdir,tmpfile) {
  catv=""
  nfiles=0
  split(e,ea," ")
  catsort="name"
  catorder="asc"

  # number of arguments
  narg = length(ea)

  # target is the last argument
  trg = ea[narg]
  trg = dir "/" trg

  catfile=gensub(".*/","","g",trg)
  catdir=gensub(catfile,"","g",trg)

  Optind = 1    # skip ea[0] (cat)

  # parse options:
  # -v 'REGEX'  - grep -v 'REGEX'
  # -t          - sort by time (defaults to name)
  # -d          - sort order descending (defaults to asc)
  # -n INT      - print the INT first results (defaults to all)
  
  # ascending (A before B)  
  # decending (New before old)

  while ((cea = getopt(narg-1, ea, "v:tdn:")) != -1) {
    switch (cea) {
      case "v":
        catv = Optarg
      break

      case "t":
        catsort = "time"
      break

      case "d":
        catorder = "desc"
      break

      case "n":
        if (Optarg ~ /^[0-9]*$/)
          nfiles = Optarg
      break
    }
  }

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

      cmd = "find " catdir " -maxdepth 1 -type f "

      if (catsort == "time") {
        cmd = cmd "-printf \"%C@ %p\\n\" | sort -n"
        if (catorder == "desc")
          cmd = cmd "r"
        cmd = cmd "| cut -d ' ' -f2-9 "
      }
      else if (catorder == "desc")
        cmd = cmd "| sort -r"
      else
        cmd = cmd "| sort"

      if (nfiles > 0) {
        cmd = cmd "| head -" nfiles " "
      }

      cmd = cmd "| xargs "


      # if markdown files append new lines at EOF
      if (filetype == "md")
        cmd = cmd "-i sh -c \"cat {} && echo\""
      else
        cmd = cmd "cat"

    } else {
      cmd = "cat " trg
    }

    if (catv != "") {
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
