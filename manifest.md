---
description: >
  Generate documents and manage projects
updated:       2019-01-06
version:       1.292
author:        budRich
repo:          https://github.com/budlabs
created:       2018-09-20
license:       mit
dependencies:  [bash, gawk, sed]
see_also:      [bash(1), awk(1), sed(1)]
environ:
    BASHBUD_DIR: $XDG_CONFIG_HOME/bashbud
synopsis: |
    --new|-n    [GENERATOR] **TARGET_DIR**
    --bump|-b   [PROJECT_DIR]
    --link|-l [PROJECT_DIR]
    --get|-g KEY [PROJECT_DIR]
    --set|-s KEY VALUE [PROJECT_DIR]
    --help|-h
    --version|-v
...

# long_description

`bashbud` can be used to quickly create new scripts with cli-option support and automatic documentation applied.
