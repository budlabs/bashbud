## printformat

`printf` functionality is available and is defined like this:  

```text
%%printf 'STRINGFORMAT' 'S1' 'S2' ...%%
OR
%%printf "STRINGFORMAT" "S1" "S2" ...%%
```

STRINGFORMAT and strings needs to be enclosed in the same type of quotes.

EXAMPLE
-------


**~/scripts/hello/manifest.md**  
```text
---
updated:       2018-12-14
version:       1.165
author:        budRich
created:       2001-11-09
dependencies:  [bash, gawk, sed]
...
```

 
**__template**  
```text
---
target:   printformat1.txt
markdown: false
wrap:     50
...
normal loop
%%for d in dependencies%%
%%d%%
%%done%%

with printformat
%%for d in dependencies%%
%%printf '%s,' 'd'%%
%%done%%
```

**printformat1.txt**  
```text
normal loop
bash
gawk
sed

with printformat
bash,gawk,sed,
```
