## bashbud - make(1) bash scripting better

The **bashbud** script/command is a very simple
`cp(1)` wrapper that simply merge a directory
from `~/.config/bashbud/` into a target
directory. The directories in `~/.config/bashbud`
are called *templates*, and the default template
is called *default*. The default templates have a
carefully created **Makefile**, that makes(no pun
intended) bash script maintenance pleasant.
Especially in regards to managing commandline
options and documentation.  

There is a [tutorial in the wiki], that walks you
through all the functionality of the **bashbud**
command and what the **Makefile** does.


[tutorial in the wiki]: https://github.com/budlabs/bashbud/wiki

## installation

If you use **Arch Linux** you can get **bashbud**
from [AUR].  

Make dependencies: **GNU** make, **GNU** awk, lowdown  

(*configure the installation in `config.mak`, if needed*)

```
$ git clone https://github.com/budlabs/bashbud.git
$ cd bashbud
$ make
# make install
$ bashbud -v
bashbud - version: 1.99
updated: 2022-04-14 by budRich
```  

[AUR]: https://aur.archlinux.org/packages/bashbud


## usage

`bashbud [OPTIONS] [TARGET_DIRECTORY]`  

**TARGET_DIRECTOY** will default to current
working directory.  

### options

    -c, --config-dir DIRECTORY | override the default (~/.config/bashbud)               
    -t, --template TEMPLATE    | TEMPLATE is the name of a directory in BASHBUD_DIR     
    -n, --new DIRECTORY        | same as: --template default                            
    -v, --version              | print version info and exit                            
    -h, --help                 | print help and exit                                    
    -a, --add                  | add FILE to (mandatory --template) TEMPLATE            
    -f, --force DIRECTORY      | Overwrite already existing files imported from template
    -u, --update               | update TEMPLATE based on current directory             
