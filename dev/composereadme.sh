#!/usr/bin/env bash

___composereadme(){

  local rmdir="${___dir:-.}/doc/readme"

  # TITLE
  printf '# **%s** - %s\n' "${___name}" "${___description}"

  declare -A content
  tocfrm='\[ [%s](#%s) \] '

  echo
  echo -n "#### "

  # [TOC]

  [[ -n ${___info[long-description]:-} ]] && {
    content[about]=about
    printf "${tocfrm}" "${content[about]}" "${content[about]}"
  }

  [[ -f $rmdir/install.md ]] && {
    content[install]=installation
    printf "${tocfrm}" "${content[install]}" "${content[install]}"
  }

  [[ -n "${___synopsis:-}" ]] && {
    content[usage]=usage
    printf "${tocfrm}" "${content[usage]}" "${content[usage]}"
  }

  [[ -d "${___dir}/doc/release" ]] && [[ "$(ls -A "${___dir}/doc/release")" ]] && {
    content[updates]=updates
    printf "${tocfrm}" "${content[updates]}" "${content[updates]}"
  }

  echo
  echo

  # [BANNER]
  [[ -f $rmdir/banner.md ]] && {
    cat "$rmdir/banner.md"
    echo
  }

  # [INSTALLATION]
  [[ -n ${content[install]:-} ]] && {
    echo "# ${content[install]}"
    cat "$rmdir/install.md"
    echo
  }

  # [LONG DESCRIPTION]
  [[ -n ${content[about]:-} ]] && {
    echo "# ${content[about]}"
    echo "${___info[long-description]}"
    echo
  }

  # [USAGE] (synopsis+options)
  [[ -n ${content[usage]:-} ]] && {
    echo "# ${content[usage]}"
    echo
    echo '```shell'
    echo "${___synopsis}" | awk '{gsub(/[`*]/,"");print}'
    echo '```'

    for o in $(printf '%s\n' "${!___info[@]}" | sort); do
      [[ $o =~ ^options ]] || continue
      lo=${o#*-}
      [[ -z ${___info[option-${lo}]:-} ]] && continue
      so="${___info[$o]:-}"
      echo
      [[ $so ]] \
        && printf '`--%s`|`-%s`' "$lo" "$so" \
        || printf '`--%s`' "$lo" 
      echo " ${___info[optarg-${lo}]:-}  "
      printf '%s\n\n' "${___info[option-${lo}]:-}"
    done
    
  }

  echo
  # [UPDATES]
  [[ -n ${content[updates]:-} ]] && {
    echo "# ${content[updates]}"
    echo
    (
      cd ${___dir}/doc/release || exit 1
      rels=($(ls -t *.md | head -3))
      for r in "${rels[@]}"; do
        echo "**${r%.md}**  "
        cat "$r"
        echo
      done
    )
    echo
  }

  # [FOOTER]
  [[ -f $rmdir/footer.md ]] && {
    echo "---"
    echo
    cat "$rmdir/footer.md"
    echo
  }
}
