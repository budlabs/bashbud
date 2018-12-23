## manifest body

The manifest body is considered everything after the manifest front matter in the `manifest.md` file 
**AND** the content of all files in the directory `manifest.d`.
The manifest body is used to add more variables to the manifest, 
but are here written in markdown instead of YAML.
The reason for this is that it is more convenient to write prose like text in markdown.
Markdown headings (lines starting with one or more hash: `#`) will be translated to variables,
everything between headings will be the content of the variable.
It is possible to add keys to arrays created in the front matter,
but it is not possible to create new arrays in the manifest body.


Below is a simple example:  

**PROJECT_DIR/manifest.md**

```
---
version: 1.100
created: 2018-12-15
updated: 2022-10-06
generator: default
synopsis: |
    --help|-h [COMMAND]
    --version|-v
    --new FILE **DIRECTORY**
...

# long_description

This is just an **example** of how use
the `manifest` in a *bashbud* project.
```

**PROJECT_DIR/manifest.d/options.md**  

```
# options-help-description

Print help information to stderr and exit

# options-version-description

Print version information to stderr and exit

# options-new-description

Creates a new FILE
```

When `bashbud` processes this project, the following variables will be available in the templates:  

```
version='1.100'
created='2018-12-15'
updated='2018-10-06'
generator='default'
synopsis'--help|-h [COMMAND]
--version|-v
--new FILE **DIRECTORY**'
long_description='This is just an **example** of how use the `manifest` in a *bashbud* project.'
options[help][long]=help
options[help][short]=h
options[help][description]='Print help information to stderr and exit'
options[version][long]=version
options[version][short]=v
options[version][description]='Print version information to stderr and exit'
options[new][long]=new
options[new][arg]=FILE
options[new][description]='Creates a new FILE'
```

Notice how the dash (`-`) in **PROJECT_DIR/manifest.d/options.md** is used to specify which array and key to use.
Also take note that the linebreak in the `long_description` variable is translated to a space ` `.
This is markdown syntax, to make a hard linebreak in markdown end the line with two space characters.
