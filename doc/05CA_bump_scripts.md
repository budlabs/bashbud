## bump scripts

Whenever a project is updated with the `--bump` command line option,
**bashbud** will look for executable files named `__post-apply` and `__pre-apply`
in the root of the templates directory.
`__pre-apply` is executed before any templates are processed.
`__post-apply` is executed after all templates are processed.
When the scripts are executed,
the full path to the new project is passed.

EXAMPLE
-------

**PROJECT_DIR/bashbud/__pre-apply**  
```
#!/usr/bin/env bash

# increment version number
# set updated to today in manifest.md

today="$(date +%Y-%m-%d)"
projectdir="$1"
manifest="$projectdir/manifest.md"

awk -i inplace -v today="$today" '
    $1 == "version:" {
      newver=$2 + 0.001
      sub($2,newver,$0)
      bump=0
    }
    $1 == "updated:" {
      sub($2,today,$0)
    }
    {print}
' "$manifest"
```

This will increment the version number in the manifest front matter +0.001
and update the updated date, before any templates are processed.
