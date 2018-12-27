# concatenate markdown
# normal lines not ending with double space
# will have "\n" replaced with a space.
# blank lines will be replaced with a single "\n"
# lists, headings, tables code lines will end with "\n"
function mdcat(e,k,r,incode,mdbody,mdline,thisline,lastline) {
  split(e,mdbody,"\n")
  r=""

  for (k in mdbody) {
    mdline=mdbody[k]

    # toggle code block
    if (mdline ~ /^[`]{3}.*/) {
      incode = !incode
      thisline="tilde"
    }

    # line ending with doublespace
    else if (mdline ~ /.*[ ]{2,}$/) {
      thisline="dspace"
    }

    # HR
    else if (mdline ~ /^[-].*/) {
      thisline="hr"
    }

    # heading
    else if (mdline ~  /^\s*[#]+\s.*/) {
      thisline="heading"
    }

    # numbered list: /^\s*[0-9]+[.])\s.*/
    else if (mdline ~ /^\s*[0-9]+[.]\s.*/) {
      thisline="list"
    }

    # unnumbered list: /^\s*[*]\s.*/
    else if (mdline ~ /^\s*[*]\s.*/) {
      thisline="list"
    }

    # blank line
    else if (mdline ~ /^[[:space:]]*$/) {
      thisline="blank"
    }

    else {
      thisline="normal"
    }

    if (incode && thisline != "tilde") {
      thisline="code"
    }

    if (r=="") {r=mdline}
    else {

      if (lastline ~ /normal|dspace/) {
        if (!(thisline ~ /normal|dspace/ && lastline=="normal")) {
          r=r "%%%WRAPTHIS%%%"
        }
      }

      if (thisline == "code") {
        r=r mdline "\n"
      }

      else if (thisline ~ /^(heading|hr|tilde)$/) {
        r=r "\n" mdline "\n"
      }

      else if (thisline=="normal" || thisline=="dspace") {
        if (lastline=="normal")
          r=r " " mdline
        else if (mdline ~ /^\s+/) {
          r=r "\n" mdline
          # nowrap
        }
        else
          r=r "\n" mdline
      }

      else if (thisline=="blank") {
        r=r "\n"
      }

      else if (thisline == "list") {
        
        if (lastline == "list")
          r=r mdline "\n"
        else
          r=r "\n" mdline "\n"
      }

      else if (thisline == "tilde") {
        r=r mdline "\n"
      }
    }

    lastline=thisline
  }

  split("",mdbody)
  split(r,mdbody,"\n")
  
  if (length(mdbody) == 1 && lastline ~ /normal|dspace/) {
    r = r "%%%WRAPTHIS%%%"
  }

  return r
}
  
