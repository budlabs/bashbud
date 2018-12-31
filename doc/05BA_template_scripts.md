## template scripts

A **template script** needs to be named `__script` 
and placed in the same directory as a `__template` file.
It will get executed with full path to the *target* of the template
as a command line parameter.
(*the target is defined in the front matter of the __template*).

EXAMPLE
-------

```
PROJECT_DIR/
  bashbud/
    manual/
      __template
      __script
    info/
      __template
    __post-apply
    __pre-apply
  manifest.md
```

Above is an example project with a **Project Specific Generator**
(*the bashbud/ directory*), containing two templates (*manual and info*).

**PROJECT_DIR/bashbud/manual/__template**  
```
---
target: manual.md
markdown: true
...
some content
```


**PROJECT_DIR/bashbud/manual/__script**  
```
#!/usr/bin/env bash

targetfile="$1"
echo "$targetfile is generated"
```

When this project is updated with the `--bump` command line option, 
after the manual template have been processed and the file: `PROJECT_DIR/manual.md` have been generated.
`PROJECT_DIR/bashbud/manual/__script` will get executed and the result will be:  
`PROJECT_DIR/manual.md is generated`

The scripts doesn't have to be written in bash, it should work as expected with f.i. python or perl scripts as long as they are executable and have the appropriate shebang.
