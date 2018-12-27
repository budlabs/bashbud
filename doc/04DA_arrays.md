## array definitions

Arrays can only be **created** in the manifest **front matter**.
Keys can be added to arrays from the manifest **body**.

EXAMPLE
-------

**manifest.md**  
```text
---
author:        budRich
environ:
    BASHBUD_DIR: $XDG_CONFIG_HOME/bashbud
    BASHBUD_DATEFORMAT: %Y-%m-%d
dependencies:  [bash, gawk, sed]
see_also:
    - bash(1)
    - awk(1)
    - sed(1)
...
# environ-BASHBUD_DIR-description

Configuration directory for bashbud.

# environ-BASHBUD_DIR-info

XDG_CONFIG_HOME is usually ~/.config

# environ-BASHBUD_DATEFORMAT-description

Date format to use in created/updated keys in the
manifest front matter.  

See `date(1)` for available formats.
```

This will yield the following variables and arrays available for templates:  

```text
author='budRich'
environ[BASHBUD_DIR][default]='$XDG_CONFIG_HOME/bashbud'
environ[BASHBUD_DIR][description]='Configuration directory for bashbud.'
environ[BASHBUD_DIR][info]='XDG_CONFIG_HOME is usually ~/.config'
environ[BASHBUD_DATEFORMAT][default]='%Y-%m-%d'
environ[BASHBUD_DATEFORMAT][description]='Date format to use in created/updated keys in the manifest front matter.  

See `date(1)` for available formats.'
dependencies[bash][index]=0
dependencies[gawk][index]=1
dependencies[sed][index]=2
see_also[bash(1)][index]=0
see_also[awk(1)][index]=1
see_also[sed(1)][index]=2
```

Notice how the dashes are used to specify the array keys in the manifest.
(*environ-BASHBUD_DATEFORMAT-description*)  

## accessing arrays in templates with loops

The big advantage of using arrays is that they can be used in loops.

Loops are defined like this:
```text
%%for ELEMENT_ALIAS in ARRAY%%
LOOP BODY
%%done%%
```

Lets use the **manifest** above in a template:  

**__template**  
```text
---
target:   array_output.txt
markdown: false
wrap:     50
...
Environment variables:

%%for e in environ%%
%%e%%
%%done%%
```

this will result in the following file:  
**array_output.txt**  
```text
Environment variables:

BASHBUD_DIR
BASHBUD_DATEFORMAT
```

one more example, 
using the same **manifest**

**__template**  
```text
---
target:   array_output.txt
markdown: false
wrap:     50
...
Environment variables:
%%for e in environ%%

%%e%%

%%e[description]%%
defaults to: %%e[default]%%
%%done%%
```

this will result in the following file:  
**array_output.txt**  
```text
Environment variables:

BASHBUD_DIR

Configuration directory for bashbud.
defaults to: $XDG_CONFIG_HOME/bashbud

BASHBUD_DATEFORMAT

Date format to use in created/updated keys in the
manifest front matter.  

See date(1) for available formats.
defaults to: %Y-%m-%d
```

