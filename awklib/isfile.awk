function isfile(file) {
  cmd = "[ -f " file " ]"

  result = system(cmd)

  close(cmd)

  # exist=0 
  return result
}
