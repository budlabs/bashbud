#!/usr/bin/env bash

# uncomment settings below to use the inofficial
# "strict" bash mode.

# URL to strict mode

# set -o errexit
# set -o pipefail
# set -o nounset

# IFS=$'\n\t'

main(){


  : # do stuff here
}

# The following three lines are needed to use the
# bashbud library.

___source="$(readlink -f "${BASH_SOURCE[0]}")" #bashbud
___dir="$(cd "$(dirname "$___source")" && pwd )" #bashbud
. "${___dir}/lib/bblib.sh" #bashbud

main "${@:-}"
