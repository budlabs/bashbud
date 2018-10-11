#!/bin/env bash

composelib() {
  local dir f

  dir="$1"

  {
    echo '#!/bin/env bash'
    echo
    for f in "$dir/dev/"*.sh; do
      [[ ${f##*/} = init.sh ]] && continue
      # remove shebang from files
      grep -v '^#!/bin/.*' "$f"
    done
    tail +2 "$dir/dev/init.sh"
  } > "$dir"/lib/base.sh
  
}
