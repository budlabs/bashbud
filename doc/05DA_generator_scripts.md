## generator scripts

Whenever a project is created with the `--new` command line option,
**bashbud** will look for executable files named `__post-generate` and `__pre-generate`
in the root of the generators directory.
`__pre-generate` is executed before a generated is created.
`__post-generate` is executed after after a generator is created.
When the scripts are executed,
the full path to the new project is passed.

EXAMPLE
-------

```
BASHBUD_DIR/
    generators/
        default/
            templates/
               ...
            __pre-generate
            __post-generate
            ...
            manifest.md

```

**BASHBUD_DIR/generators/default/__post-generate**
```
#!/usr/bin/env bash

today="$(date +%Y-%m-%d)"
projectdir="$1"
manifest="$projectdir/manifest.md"

awk -i inplace -v today="$today" '
    $1 == "created:" {
      sub($2,today,$0)
    }
    {print}
' "$manifest"
```


`bashbud --new default ~/projects/newproject` 

The command above would first create a new project at `~/projects/newproject`
and then execute: `BASHBUD_DIR/generators/default/__post-generate ~/projects/newproject`  
Notice that the path to the new project is passed to the script,
(*in bash that argument can be accessed with:* `$1`)
