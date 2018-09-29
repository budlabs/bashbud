---
description: >
  Boilerplate and template maker for bash scripts
updated:       2018-09-29
version:       0.021
author:        budRich
repo:          https://github.com/budlabs
created:       2018-09-20
dependencies:  [bash, gawk, sed]
see-also:      [bash(1), awk(1), sed(1)]
environment-variables:
    BASHBUD_NEW_SCRIPT_DIR: ~/tmp/bashbud
    BASHBUD_NEW_SCRIPT_PATH: ~/src/bashbud
    BASHBUD_ALL_SCRIPTS_PATH: ~/tmp/bashbud
synopsis: |
    --help|-h
    --version|-v
    --lib
    --mode|-m [MODE] **PROJECT**
    --publish|-p PROJECT **PATH**
    --new|-n  PROJECT
    --bump|-b PROJECT
    --lorem PROJECT
...

# long-description

`bashbud` can be used to quickly create new scripts with cli-option support and automatic documentation applied.
