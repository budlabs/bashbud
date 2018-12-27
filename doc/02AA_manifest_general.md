# the manifest

The manifest is the only mandatory thing `bashbud` needs to operate on a [project]. 
The manifest consist of three parts:

1. comment area
2. front matter
3. manifest body

Below is an example of how a manifest can look like:  

```text
this is just an example
any text before the start of the front matter
will be ignored by bashbud and can be used to write comments.
---
description: >
    When parsed lines with the same intendation
    after a block definition (>) will be concatenated.
version: 1.100
created: 2018-12-15
updated: 2022-10-06
generator: default
author:  budRich
synopsis: |
    --help|-h [COMMAND]
    --version|-v
    --new FILE **DIRECTORY**
...

# long_description
This is just a simple hello world program.
That will print the string "hello world" to `stdout`.  
if not the **new** option is used.

# options-help-description
print help information to `stderr` and exit.

# option-new-description
Creates a file with the string "hello world" to FILE

# options-version-description
Print version info to `stderr` and exit.
```
