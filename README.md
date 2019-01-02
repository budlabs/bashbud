# bashbud - Generate documents and manage projects 

**bashbud** works like a static site generator
(*hugo*,*jekyll*,*etc.*), generating documents based on
templates with content written in markdown. 

**bashbud** was created to organize and structure bash
script projects, but it can be used to generate any type of
document, and be used for other programming (or
non-programming) projects.

It is written in **gawk** and **bash**. **bashbud** itself
is used to generate the documentation.

## installation

If you are using **Arch linux**, you can install the
bashbud package from [AUR]. 

Or follow the instructions below to install from source: 

```text
git clone https://github.com/budlabs/bashbud.git
cd bashbud
sudo make install

```


## usage

`bashbud` can be used to quickly create new scripts with
cli-option support and automatic documentation applied.


### commandline options


`--new`|`-n`  
Creates a new project at TARGET_DIR (*if TARGET_DIR doesnt
exist, if it does script will exit*), based on GENERATOR. If
GENERATOR is omitted the **default** generator will be used.
After all files are copied and linked, the project is
*bumped* (*same as:* `bashbud --bump TARGET_DIR`).

`--bump`|`-b`  
The current working direcory will be set as PROJECT_DIR if
none is specified. When a project is *bumped*,  `bashbud`
will read the *manifest.md* file in PROJECT_DIR, (*or exit
if no manifest.md file exists*). If a generator **type** is
specified in the **front matter**  (the *YAML* section
starting the document) of the *manifest.md* file, that
generator will be used to update the project based on the
content of the *manifest.md* file and the *manifest.d*
directory (*if it exists*). If a directory named *bashbud*
exists within *PROJECT_DIR*, that directory will be used as
a generator.

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.

---

See the [bashbud wiki] or the manpage `bashbud(1)` for a
detailed description on how **bashbud** works and what it
can do.

[bashbud wiki]: https://github.com/budRich/bashbud/wiki 
[AUR]: https://aur.archlinux.org/packages/bashbud

## updates

## BUD IS BACK

**2019-01-01** 
First public release, read the wiki,  report the issues, 
stay calm and keep kyle.


## license

**bashbud** is licensed with the **MIT license**


