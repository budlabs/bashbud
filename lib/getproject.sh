getproject(){
  local name

  name="$1"
  
  listprojects | awk -v srch="$name" '
    $1 == srch {
      print "curmode=" $2
      print "curpath=\"" $3 "\""
      exit
    }
  '
}
