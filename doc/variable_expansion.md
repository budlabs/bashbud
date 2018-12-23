### variable expansion

the simplest expression that can be defined in a **template body** is variable expansion.
Simply write the name of a variable defined in the *manifest* and it will get expanded in the generated file.

EXAMPLE
-------

**~/scripts/hello/manifest.md**  
```text
---
updated:       2018-12-14
version:       1.165
author:        budRich
created:       2001-11-09
...
# long_description

simple **test program** that will print hello world to `stdout`.
```


**BASHBUD_DIR/generators/default/__templates/created/__template**  
```text
---
target:   created.txt
markdown: false
wrap:     50
...
%%name%% was created %%created%%.
```


If we would execute the command:  

```shell
$ bashbud --bump ~/scripts/hello
```

The following would happen (*assuming no other files exists*):  

1. Since no **generator type** is defined in the **manifest** default will be assumed and found in `BASHBUD_DIR` (which defaults to `~/.config/bashbud`).
2. 5 variables will get defined (updated, version, author, created and long_description) that can be used in the templates.
3. All lines in the content body will get evaluated, (*in our example above there is only one line*).
4. The result of the evaluated template will be the content of the file defined as **target** in the **templates** front matter.

**~/scripts/hello/created.txt**  
```text
hello was created 2001-11-09.
```

`%%name%%` is a special variable that contains the name of the directory that holds *manifest.md*,
in this case: *hello*  

One more example, with the same `manifest.md` but with a `__template` looking like this:  

```text
---
target:   created.txt
markdown: true
wrap:     50
...
%%name%% was created %%created%%.
%%long_description%%
```

the value of markdown is changed to *true* and the variable *long_description* is added.
The processed result will look like this:  

```text
hello was created 2001-11-09.
simple **test program** that will print hello 
world to `stdout`.
```

Long description is now included with the markdown markup,
notice also that the text is wrapped at the first space before column 50.
