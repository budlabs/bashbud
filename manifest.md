---
description: >
  Boilerplate and template maker for bash scripts
updated:       2018-10-17
version:       0.035
author:        budRich
repo:          https://github.com/budlabs
created:       2018-09-20
dependencies:  [bash, gawk, sed]
see-also:      [bash(1), awk(1), sed(1)]
environment-variables:
    BASHBUD_DIR: $XDG_CONFIG_HOME/bashbud
    BASHBUD_PROJECTS_DIR: $BASHBUD_DIR/projects
    BASHBUD_SCRIPTS_DIR: $BASHBUD_DIR/scripts
    BASHBUD_PROJECTS_PATH: $BASHBUD_PROJECTS_DIR
    BASHBUD_INFO_FOLD: 80
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
