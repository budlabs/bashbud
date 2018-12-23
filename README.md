# bashbud - Boilerplate and template maker for bash scripts 

**bashbud** works like a static site generator
(*hugo*,*jekyll*,*etc.*), generating documents based on
templates with content written in markdown. 

It is intended to be used for bash script projects, but it
can be used to genrate other type of documents. 

It is written in **AWK** and **BASH**. **bashbud** itself
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

```text
--new|-n   [GENERATOR] **TARGET_DIR**
--bump|-b  [PROJECT_DIR]
--help|-h
--version|-v
```


`--new`|`-n`  
This will create a new script named
"BASHBUD_NEW_SCRIPT_DIR/NAME/NAME.sh" and copy the info
template to the same directory. The bashbud.sh lib script
will get linked to the lib directory of the script.

`--bump`|`-b`  
`bump` option will update PROJECT by setting update date in
`manifest.md` to the current date, and also bump the verion
number with (current version + 0.001). It will also
temporarly set the project in development mode (if it isn't
already) and generate readme and manpage files for PROJECT.

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.

---

See the [bashbud wiki] or the manpage `bashbud(1)` for a
detailed description on how **bashbud** works and what it
can do.

## updates

### HELLO BASHBUD
**0.01-alfa** - *2018-12-14*

First public release of bashbud. Considered a pre-release,
breaking changes will probably be done before considered
stable.


## license

All **bashbud** scripts are licensed with the **MIT license**


