#!/bin/env bash

___hardstdin(){
  # include __stdin if it is used in main script
  grep '.*__stdin.*' "${___source}"  > /dev/null 2>&1 && {
    printf '%s\n' '__=""' '__stdin=""' 'read -N1 -t0.01 __  && {'
    echo '  (( $? <= 128 ))  && {'
    printf '    %s\n' \
      "IFS= read -rd '' __stdin" \
      '__stdin="$__$__stdin"'
    printf '  }\n}\n'
  }
  echo
}
