## if statements

If statements are defined like this in the templates:  
```text
%%if EXPRESSION%%
...
%%%fi%%
```

*EXPRESSION* can be just the name of a variable or array. Or a comparison (`=` or `!=`):  

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
XDG_CONFIG_HOME is usually ~/.config

no info about BASHBUD_TIMEFORMAT

budrich wrote this
```

