# if statements

If statements are defined like this in the templates:  
```text
%%if EXPRESSION%%
...
%%%fi%%
```

*EXPRESSION* can be just the name of a variable or array. Or a comparison (`=` or `!=`):  

**~/scripts/hello/manifest.md**  
```text
---
updated:       2018-12-14
version:       1.165
author:        budRich
created:       2001-11-09
environ:
    BASHBUD_DIR: $XDG_CONFIG_HOME/bashbud
    BASHBUD_DATEFORMAT: %Y-%m-%d
...
# long_description

simple **test program** that will print hello world to `stdout`.

# environ-BASHBUD_DIR-info

bashbud config dir location.
```



**__template**  
```text
---
target:   if_statements1.txt
markdown: false
wrap:     50
...
%%if environ%%

Environ variables info:
%%for e in environ%%
%%if e[info]%%
info about %%e%%:
%%e[info]%%
%%else%%
no info about %%e%%.
%%fi%%

%%done%%
%%fi%%
%%if onions%%
we have onions
%%fi%%
%%if author = budRich%%
budrich wrote this
%%else%%
this was written by %%author%%
%%fi%%
```

this will result in the following file:  
**if_statements1.txt**  
```text
Environment variables info:

info about BASHBUD_DIR:
bashbud config dir location.

no info about BASHBUD_TIMEFORMAT

budrich wrote this
```

