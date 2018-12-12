function wrap(text,num,   q, y, z) {
  while (text) {
    q = match(text, / |$/); y += q
    if (y > num) {
      z = z RS; y = q - 1
    }
    else if (z) z = z FS
    z = z substr(text, 1, q - 1)
    text = substr(text, q + 1)
  }
  return z
}
