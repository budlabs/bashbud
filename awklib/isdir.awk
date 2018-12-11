function isdir(dir) {
  cmd = "[ -d " dir " ]"

  result = system(cmd)

  close(cmd)

  # exist=0 
  return result
}
