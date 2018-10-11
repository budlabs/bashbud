---
description: >
  Boilerplate and template maker for bash scripts
updated:       2018-09-20
version:       0.001
author:        budRich
repo:          https://github.com/budlabs
created:       2018-09-20
dependencies:  [bash, gawk, sed]
see-also:      [bash(1), awk(1), sed(1)]
environment-variables:
    ENV_VAR_TEST:  $HOME/.config
synopsis: |
    --help|-h
    --version|-v
    [--force] --new|-n *NAME*
...



# option-force

force action on this option

# option-new

This will create a new script named
"BASHBUD_NEW_SCRIPT_DIR/NAME/NAME.sh" and copy the
info template to the same directory. 

The bashbud.sh lib script will get linked to the lib directory of the 'script'.

# option-help
Show help and exit.

# option-version
Show version and exit

# env-BASHBUD_NEW_SCRIPT_DIR

Path to directory where new scripts are placed.

# env-BASHBUD_NEW_SCRIPT_PATH

Path to a directory where new scripts are linked.
It is recommended to have this directory in PATH.
