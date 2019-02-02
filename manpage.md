`bashbud` - Generate documents and manage projects

SYNOPSIS
--------
```text
bashbud --new|-n    [GENERATOR] **TARGET_DIR**
bashbud --bump|-b   [PROJECT_DIR]
bashbud --link|-l [PROJECT_DIR]
bashbud --get|-g KEY [PROJECT_DIR]
bashbud --set|-s KEY VALUE [PROJECT_DIR]
bashbud --help|-h
bashbud --version|-v
```

DESCRIPTION
-----------
`bashbud` can be used to quickly create new
scripts with cli-option support and automatic
documentation applied.


OPTIONS
-------

`--new`|`-n`  
Creates a new project at TARGET_DIR (*if
TARGET_DIR doesnt exist, if it does script will
exit*), based on GENERATOR. If GENERATOR is
omitted the **default** generator will be used.
After all files are copied and linked, the project
is *bumped* (*same as:* `bashbud --bump
TARGET_DIR`).

`--bump`|`-b`  
The current working direcory will be set as
PROJECT_DIR if none is specified. When a project
is *bumped*,  `bashbud` will read the
*manifest.md* file in PROJECT_DIR, (*or exit if no
manifest.md file exists*). If a generator **type**
is specified in the **front matter**  (the *YAML*
section starting the document) of the
*manifest.md* file, that generator will be used to
update the project based on the content of the
*manifest.md* file and the *manifest.d* directory
(*if it exists*). If a directory named *bashbud*
exists within *PROJECT_DIR*, that directory will
be used as a generator.

`--link`|`-l`  
Add any missing links from the generators
`__link` directory, to `PROJECT_DIR`.

`--get`|`-g` KEY  
Get the value from a key in the YAML frontmatter
of the manifest.md. If last argument is a
directory, the manifest in that directory will be
used, otherwise the current directory is assumed.

`--set`|`-s` VALUE  
Set the value of KEY in the YAML frontmatter of
the manifest.md to VALUE. If last argument is a
directory, the manifest in that directory will be
used, otherwise the current directory is assumed.

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.

arbe
# bashbud project

A project in the bashbud context refers to a
directory and it's content that contains a
[manifest.md] file.

# the manifest


The manifest is the only mandatory thing
`bashbud` needs to operate on a [project].  The
manifest consist of three parts:

1. comment area
2. front matter
3. manifest body


Below is an example of how a manifest can look
like:  

**PROJECT_DIR/manifest.md**  
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


## manifest front matter


The manifest front matter is the only mandatory
part of the manifest.  It needs to be defined
before the manifest body in the `manifest.md`
file, in [YAML] format (starting with three dashes
(`---`) and ending with thre dots (`...`).  

The front matter can contain any number of user
defined, variables, lists and arrays, but some
keys are special.

## special variables in the manifest front matter


The key `generator` tells `bashbud` what
[generator] to use, it is not mandatory and
defaults to: `default` if omitted and is always
overridden by a [project specific generator].

Another special variable is [synopsis].

## the synopsis variable and options array


The key `synopsis` will be translated to an array
called *options* when parsed by `bashbud`. If used
properly this will be the only place needed to
declare command-line options in a *project*. Let's
take a closer look at the `synopsis` key from the
example manifest above.  

```text
synopsis: |
    --help|-h [COMMAND]
    --version|-v
    --new FILE **DIRECTORY**
```



The pipe (`|`) character, after the key
definition, is [YAML] syntax meaning that the
content of the key should be interpreted literal.
Which in turn means it will preserve linebreaks as
they are written. The indentation specifies the
scope.  

Translated to a `bash` variable, it would look
like this:  

```text
synopsis'--help|-h [COMMAND]
--version|-v
--new FILE **DIRECTORY**'
```


The above is also what would be printed if
`%%synopsis%%` would be used in a [template].


But as mentioned, the content of the synopsis
will also get stored in a special array called
*options*:  


```text
options[help][long]=help
options[help][short]=h
options[version][long]=version
options[version][short]=v
options[new][long]=new
options[new][arg]=FILE
```


Notice that the option `--help` in the synopsis
have an *optional* argument defined, (`[COMMAND]`)
and that it is ignored in the array. Sometimes it
is also desired to have a mandatory argument, 
that doesn't belong to the preceding option. Such
arguments should be enclosed withing double
asterisks (`**DIRECTORY**`).

## manifest body


The manifest body is considered everything after
the manifest front matter in the `manifest.md`
file  **AND** the content of all files in the
directory `manifest.d`. The manifest body is used
to add more variables to the manifest,  but are
here written in markdown instead of YAML. The
reason for this is that it is more convenient to
write prose like text in markdown. Markdown
headings (lines starting with one or more hash:
`#`) will be translated to variables, everything
between headings will be the content of the
variable. It is possible to add keys to arrays
created in the front matter, but it is not
possible to create new arrays in the manifest
body.


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


When `bashbud` processes this project, the
following variables will be available in the
templates:  

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


Notice how the dash (`-`) in the headings in 
**PROJECT_DIR/manifest.d/options.md**  is used to
specify which array and key to use. Also take note
that the linebreak in the `long_description`
variable is translated to a space ` `. This is
markdown syntax, to make a hard linebreak in
markdown end the line with two space characters or
add a blank line after the line to break.

## generators


A generator is a directory containing templates
and base files used to create or update (*bump*) a
project. When a new project is created (with the
`--new` option) `bashbud` will do the following:  

1. [determine location of generator](#determine_location_of_generator)
2. [copy base files](#copy_base_files)
3. [create links](#copy_base_files)
4. [process templates](#process_templates)


When a project is updated with the `--bump`
command-line option, it will process the templates
and scripts corresponding to the projects
generator.


# generator types


A project can use one of three types of
generators:

1. Project specific generator (**PSG**)
2. User specific generator (**USG**)
3. System wide generator (**SWG**)


The type is determined based on the generators
location. If the generator is not project specific
the value of the key: `generator` in the projects
**manifest** specifies which generator to use.


If no **PSG** exists and no value to the
`generator` key in the manifest is declared. The
`default` **SWG** will be used if no `default`
**USG** exists.



# Project specific generators (**PSG**)


A **PSG** is unique to a certain project. A
**PSG** is defined by creating a directory in a
projects root directory named `bashbud` that
contain templates. This directory have the same
file structure as a `__templates` directory of a
**USG**.

**PSG** have highest priority of generators and
is used if a **PSG** directory exist, even if the
`generator` key in the **manifest** have a value.

The purpose and advantage of using a **PSG** for
a project is that it makes the *bashbud build*
portable. Anyone can clone the project and use
`bashbud --bump` to get the same output. **PSG**
is the recommended generator type, especially for
public projects.


The disadvantage of using a **PSG** instead of
the other generator types:

1. A **PSG** is unique to a project, meaning that changes done to the generator will not apply to other bashbud generators. This can however be done by using [linked generators].
2. A **PSG** can not be used to create a new bashbud project, only update.



Below is an example of how the file tree would
look like in a project using a **PSG**:  


```text
PROJECT_DIR/
    bashbud/
        readme/
            __template
        program/
            __template
            __script
    manifest.d/
        ...
    manifest.md
    ...
```


When this project would get updated with the
`--bump` command-line option,  the templates
within the subdirectories of the *bashbud*
directory would get get processed.

# user specific generators (**USG**)


user specific generators are located in 
*BASHBUD_DIR* (which defaults to
`~/.config/bashbud`) in which a directory named
*generators* holds all available **USG**.

Below is an example representation of the files
and directories in a **USG** (and a **SWG**)

```text
BASHBUD_DIR/
  generators/
    default/      
      __link/     
        lib/
          ERR.sh
      __templates/
        program/
          __template
          __script
        readme/
          __template
      manifest.d/
        opts.md
        envs.md
      main.sh
      manifest.md
    nextgen/      
      __link/     
        ...
      __templates/
        ...
      manifest.md
```


Two **USG** exist in the filetree above:
`default` and `nextgen`. All files and directories
within the root directory of the generator
(*default*) that doesn't start with two
underscores are referred to in the documentation
as base files. The base files will get copied to
PROJECT_DIR when the project is created with the
`--new` command-line option.  

```text
PROJECT_DIR/
    manifest.d/
        opts.md
        envs.md
    main.sh
    manifest.md
```


The directory structure inside the `__link`
directory will get created in PROJECT_DIR when the
project is created with the `--new` command-line
option. And all files found (recursively) in the
`__link` directory will get hard linked (`ln`) to
PROJECT_DIR.  

```text
PROJECT_DIR/
    lib/
        ERR.sh     <- linked
    manifest.d/
        opts.md
        envs.md
    main.sh
    manifest.md
```


The content of the `__templates` directory is
only used when a project is updated with the
`--bump` command-line option. The `__templates`
directory is actually the only part of a generator
needed when a PROJECT is updated.  Since a **PSG**
can only be used to `--bump` a project,  a **PSG**
generator consists of only the `__templates`
directory, renamed to `bashbud` and place in the
root of *PROJECT_DIR*.

# system wide generator (**SWG**)


A **SWG** have the exact same file structure as a
[user specific generator], the only difference
being it's location in the filesystem.

A **SWG** is located in
`/usr/share/bashbud/generators/` while a **USG**
is located in `BASHBUD_DIR/generators/`.

If a both a **SWG** and a **USG** have the same
name, **USG** will have priority.

By default there only exist one **SWG**:
`default`.

# linked generators


Creating a **USG** (or a **SWG**), that instead
of having its templates located in
`GENERATOR_DIR/__templates`, have them at
`GENERATOR_DIR/__link/bashbud`. Will have the
effect that whenever a new project is created it
will have a **PSG** (`PROJECT_DIR/bashbud`), and
the templates being linked to
`GENERATOR_DIR/__link/bashbud`. This solves the
issues of local projects not being able to share
templates while still being fully portable.  It is
also a way to use `--new` with **PSG**.

This is the recommended way of using bashbud.

# generator priority



The priority of generators is as follows:  

1. project specific generator (**PSG**)
2. user specific generator (**USG**)
3. system wide generator (**SWG**)


Below are some examples to illustrate how this
works:  


```
/usr/share/bashbud/
  generators/
    default/
      ...
    testgen/
      ...
  licenses/
    ...
  awklib/
    ...
  ...
```



```
BASHBUD_DIR/
    generators/
      default/
        ...
      mygen/
        ...
    licenses/
      ...
    awklib/
      ...
...
```



**project 1 directory**
```
PROJECT_DIR/
  manifest.md
```


**project 1 manifest.md**  
```
---
generator: default
...
```



When project 1 is updated, it will use the
templates located in the **USG**: `deault` located
in *BASHBUD_DIR*.

If we would change the value of the *generator*
key in the manifest to `testgen`. The templates in
**SWG**: `testgen` in `/usr/share/bashbud` would
be used to update the project.  

If no generator is specified in the manifest, it
will have the default value: `default`. Which
would result in the `default` **USG** would be
used.  

If we would add a directory containing templates,
named `bashbud` to *PROJECT_DIR*, that would would
be seen as a **PSG** and have priority over any
other generator.  

**project 2 directory**
```
PROJECT_DIR/
  bashbud/
    template1/
      ...
    template2/
      ...
  manifest.md
```


**project 2 manifest.md**  
```
---
generator: mygen
...
```


If project 2 would get updated it would use the
templates from the **PSG** in *PROJECT_DIR*,
ignoring the **USG** mygen, even if it is
specified in the manifest and exist in
*BASHBUD_DIR*.

# templates


Templates are processed as the last action when
the `--new` command-line option is used or as the
sole action when the `--bump` command-line option
is used.

A template consist of three parts:  

1. Comment area
2. YAML front matter
3. Template body


below is a simple template example:  

```text
function that prints script name and version
information to stderr.
---
target:   lib/printversion.sh
markdown: false
wrap:     50
...
___printversion(){
  
cat << 'EOB' >&2
%%name%% - version: %%version%%
updated: %%updated%% by %%author%%
EOB
}
```


### the template front matter


A **YAML front matter** is mandatory in all
templates, but none of the keys, except
**target**, in the front matter is.

The front matter needs to start with three dashes
(`---`) as the only content of a line, and end
with three dots (`...`) as the only content of a
line. The front matter needs to be defined
**before** the **template body**. Any text before
the start of the front matter will be ignored by
`bashbud` and can be used to write comments about
the template it self.  

### template front matter keys


| key      | description | default |
|:---------|:------------|:--------|
| target   | destination of the generated file relative to the current **PROJECT**s *manifest.md*. | - |
| markdown | if set to false, all expanded variables and imported markdown files will have their markdown stripped | false |
| wrap     | if set to an integer higher then 0 all expanded variables and imported markdown files paragraphs will get wrapped at the column specified. This applies even if the **markdown key** is set to false. | 0 |


### template body


`bashbud` will parse the **template body** and
evaluate and expand the expressions defined within
double percentage symbols (`%%`).  

# variable expansion


the simplest expression that can be defined in a
**template body** is variable expansion. Simply
write the name of a variable defined in the
*manifest* and it will get expanded in the
generated file.

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


The following would happen (*assuming no other
files exists*):  

1. Since no **generator type** is defined in the **manifest** default will be assumed and found in `BASHBUD_DIR` (which defaults to `~/.config/bashbud`).
2. 5 variables will get defined (updated, version, author, created and long_description) that can be used in the templates.
3. All lines in the content body will get evaluated, (*in our example above there is only one line*).
4. The result of the evaluated template will be the content of the file defined as **target** in the **templates** front matter.


**~/scripts/hello/created.txt**  
```text
hello was created 2001-11-09.
```


`%%name%%` is a special variable that contains
the name of the directory that holds
*manifest.md*, in this case: *hello*  

One more example, with the same `manifest.md` but
with a `__template` looking like this:  

```text
---
target:   created.txt
markdown: true
wrap:     50
...
%%name%% was created %%created%%.
%%long_description%%
```


the value of markdown is changed to *true* and
the variable *long_description* is added. The
processed result will look like this:  

```text
hello was created 2001-11-09.
simple **test program** that will print hello 
world to `stdout`.
```


Long description is now included with the
markdown markup, notice also that the text is
wrapped at the first space before column 50.

# if statements


If statements are defined like this in the
templates:  
```text
%%if EXPRESSION%%
...
%%%fi%%
```


*EXPRESSION* can be just the name of a variable
or array. Or a comparison (`=` or `!=`):  

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



## array definitions


Arrays can only be **created** in the manifest
**front matter**. Keys can be added to arrays from
the manifest **body**.

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


This will yield the following variables and
arrays available for templates:  

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


Notice how the dashes are used to specify the
array keys in the manifest.
(*environ-BASHBUD_DATEFORMAT-description*)  

## accessing arrays in templates with loops


The big advantage of using arrays is that they
can be used in loops.

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


one more example,  using the same **manifest**

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



## printformat


`printf` functionality is available and is
defined like this:  

```text
%%printf 'STRINGFORMAT' 'S1' 'S2' ...%%
OR
%%printf "STRINGFORMAT" "S1" "S2" ...%%
```


STRINGFORMAT and strings needs to be enclosed in
the same type of quotes.

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


## import file content with cat


Sometimes it can be desired to import files in a
template. This can be done by using the **cat**
function:  

The syntax for the **cat function** is as
follows:  
`%%cat [OPTIONS] FILE|DIR/*%%`  

The following options are available:  
```
-v 'REGEX'  - grep -v 'REGEX'
-t          - sort by time (defaults to name)
-r          - reverse sort order
-n INT      - print the INT first results (defaults to all)
-p          - print the full path to the file before printing the content
```


EXAMPLE  
-------


```text
example 1. import single file import:
%%cat FILE%%

example 2. import all files in a directory:
%%cat DIR/*%%

example 3. import the n last modified files in a directory:
%%cat -tn n DIR/*%%

example 4. import single file, exclude lines matching PATTERN:
%%cat -v 'PATTERN' FILE%%

example 5. import the three first files in alphabetic order from DIR
and exclude lines matching PATTERN:
%%cat -n 3 -v 'PATTERN' DIR/*%%
```


If the imported file have the extension `md`
(*FILE.md*), line wrapping will be applied to all
paragraphs according to the wrap key in the
templates front matter.

Lets add two directories and some files to our
example project:  

```text
PROJECT_DIR/
    manifest.md
    doc/
      test1.md
      test2.md
      test3.md
    functions/
      hello.sh
      cleanup.sh
```


**doc/test1.md**  
```text
# test1 file

this is just a test file made to demonstrate how the `cat` function in **bashbud** templates work.
```


**doc/test2.md**  
```text
test2 file

more stupid
test files  
last line ended with two spaces
```


**doc/test3.md**  
```text


test3 file

this file have two leading and trailing blank lines


```


**functions/hello.sh**  
```text
#!/bin/bash

# usage:
# hello NAME
#
# prints 'hello NAME' to stdout
hello() { echo "hello $1" ;}
```


**functions/cleanup.sh**  
```text
#!/bin/bash

# cleanup function
DEATH() {
    exit
}
```


Now lets try the different ways the **cat
function** can be used.  

**__template**  
```text
---
target: cat-example1.txt
markdown: false
wrap: 20
...
example 1. import single file import:
%%cat doc/test1.md%%
```


**PROJECT_DIR/cat-example1.txt**  
```
example 1. import single file import:
# test1 file

this is just a test
file made to
demonstrate how the
cat function in
bashbud templates
work.
```


Notice how markdown markup is stripped from the
file content and that the paragraph is wrapped at
column 20. Also notice that the first line from
the template is not wrapped, this is because the
line is part of the template and not considered a
markdown paragraph by `bashbud`.  

**__template**  
```text
---
target: cat-example2.txt
markdown: true
wrap: 20
...
example 2. import all files in a directory:
%%cat doc/*%%
```


**PROJECT_DIR/cat-example2.txt**  
```
example 2. import all files in a directory:
# test1 file

this is just a test
file made to
demonstrate how the
`cat` function in
**bashbud** templates
work.

test2 file
more stupid test
files
last line ended
with two spaces



test3 file
this file have two
leading and
trailing blank
lines


```


A blank line is automatically added after each
file is imported. Take notice how wrapping and
linebreaks are applied.  

For this next example, let's assume `test3.md` is
the last modified file and `test1.md` was the
first modified file.  

**__template**  
```text
---
target: cat-example3.txt
markdown: true
wrap: 0
...
example 3. import the n last modified files in a directory:
%%cat -tn 2 doc/*%%
```


**PROJECT_DIR/cat-example3.txt**  
```
example 3. import the n last modified files in a directory:
test2 file
more stupid test files  
last line ended with two spaces



test3 file
this file have two leading and trailing blank lines

```



**__template**  
```text
---
target: cat-example5.txt
markdown: true
wrap: 20
...
example 5. import all files in a directory, exclude lines matching PATTERN , (lines with a leading hash):
%%cat -v '^#' functions/*%%
```


**PROJECT_DIR/cat-example5.txt**  
```
example 5. import all files in a directory, exclude lines matching PATTERN , (lines with a leading hash):

hello() { echo "hello $1" ;}


DEATH() {
    exit
}
```


Notice how none of the lines are wrapped since
the files imported aren't markdown files with the
`md` extension.

## template order


To have templates being processed in a certain
order, place a file named `__order` in the
**template directory**.

EXAMPLE
-------


```
PROJECT_DIR/
  bashbud/
    version/
      __template
    about/
      __template
    manual/
      __template
    contact/
      __template
    __order
  manifest.md
```


The project above has a **PSG** (in the bashbud
directory) with four templates: version, about,
contact and manual.


**PROJECT_DIR/bashbud/__order**  
```
# order of templates:

manual
apple

about
contact
```


Blank lines, lines starting with `#` and lines
that are not names of existing templates are
ignored.

Existing templates not included in the `__order`
file will be appended in pseudorandom order to the
list.

The order of the templates in the example project
will look like this:  
```
manual
about
contact
version
```


This can be useful when the result of one
template is used in another.

# extension scripts


The functionality of **bashbud** can be extended
with scripts. Before and after some operations are
performed **bashbud** looks for files named and
located in certain places, if these files exist
and is executable, they will be executed.

## template scripts


A **template script** needs to be named
`__script`  and placed in the same directory as a
`__template` file. It will get executed with full
path to the *target* of the template as a command
line parameter. (*the target is defined in the
front matter of the __template*).

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


Above is an example project with a **Project
Specific Generator** (*the bashbud/ directory*),
containing two templates (*manual and info*).

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


When this project is updated with the `--bump`
command line option,  after the manual template
have been processed and the file:
`PROJECT_DIR/manual.md` have been generated.
`PROJECT_DIR/bashbud/manual/__script` will get
executed and the result will be:  
`PROJECT_DIR/manual.md is generated`

The scripts doesn't have to be written in bash,
it should work as expected with f.i. python or
perl scripts as long as they are executable and
have the appropriate shebang.

## bump scripts


Whenever a project is updated with the `--bump`
command line option, **bashbud** will look for
executable files named `__post-apply` and
`__pre-apply` in the root of the templates
directory. `__pre-apply` is executed before any
templates are processed. `__post-apply` is
executed after all templates are processed. When
the scripts are executed, the full path to the new
project is passed.

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


This will increment the version number in the
manifest front matter +0.001 and update the
updated date, before any templates are processed.

It is also possible to execute more scripts by
adding them to directories named: `__pre-apply.d`
and/or `__post-apply.d` , an optional `__order`
file can also be created in these directories to
specify a desired execution order.

EXAMPLE
-------


```text
PROJECT_DIR/bashbud
  ...
  __pre-apply.d
    notify
    __order
  __pre-apply
  ...
```


**PROJECT_DIR/bashbud/__pre-apply.d/notify**  
```
#!/usr/bin/env bash
notify-send "Let's generate!"
```



**PROJECT_DIR/bashbud/__pre-apply.d/__order**  
```
# order to execute pre-apply scripts
notify
banana
```


With this setup, the `__pre-apply` script will
first get executed. The the order will get
determined. In the example `__order` file above to
files are listed **notify** and **banana**, since
**banana** doesn't exist, only **notify** will get
executed.

## generator scripts


Whenever a project is created with the `--new`
command line option, **bashbud** will look for
executable files named `__post-generate` and
`__pre-generate` in the root of the generators
directory. `__pre-generate` is executed before a
generated is created. `__post-generate` is
executed after after a generator is created. When
the scripts are executed, the full path to the new
project is passed.

EXAMPLE
-------


```
BASHBUD_DIR/
    generators/
        default/
            templates/
               ...
            __pre-generate
            __post-generate
            ...
            manifest.md

```



**BASHBUD_DIR/generators/default/__post-generate**
```
#!/usr/bin/env bash

today="$(date +%Y-%m-%d)"
projectdir="$1"
manifest="$projectdir/manifest.md"

awk -i inplace -v today="$today" '
    $1 == "created:" {
      sub($2,today,$0)
    }
    {print}
' "$manifest"
```



`bashbud --new default ~/projects/newproject`

The command above would first create a new
project at `~/projects/newproject` and then
execute:
`BASHBUD_DIR/generators/default/__post-generate
~/projects/newproject`  
Notice that the path to the new project is passed
to the script, (*in bash that argument can be
accessed with:* `$1`)


ENVIRONMENT
-----------

`BASHBUD_DIR`  
bashbud config dir location.
defaults to: $XDG_CONFIG_HOME/bashbud

DEPENDENCIES
------------
`bash`
`gawk`
`sed`



