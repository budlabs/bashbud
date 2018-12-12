---
description: >
  Boilerplate and template maker for bash scripts
updated:       2018-12-12
version:       1.005
author:        budRich
repo:          https://github.com/budlabs
created:       2018-09-20
dependencies:  [bash, gawk, sed]
see-also:      [bash(1), awk(1), sed(1)]
environ:
    BASHBUD_DIR: $XDG_CONFIG_HOME/bashbud
    BASHBUD_PROJECTS_DIR: $BASHBUD_DIR/projects
    BASHBUD_SCRIPTS_DIR: $BASHBUD_DIR/scripts
    BASHBUD_PROJECTS_PATH: $BASHBUD_PROJECTS_DIR
    BASHBUD_INFO_FOLD: 80
synopsis: |
    --new|-n   [GENERATOR] **TARGET_DIR**
    --bump|-b  PROJECT
    --help|-h
    --version|-v
...

# long-description

`bashbud` can be used to quickly create new scripts with cli-option support and automatic documentation applied.
