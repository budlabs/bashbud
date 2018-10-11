# **bashbud** - Boilerplate and template maker for bash scripts

#### \[ [about](#about) \] \[ [installation](#installation) \] \[ [usage](#usage) \] 

**bashbud** was created to simplify documentation and creation of bashscripts. All global configurations and info for a script is defined in YAML format and all documentation is written in markdown. The YAML and markdown can all be written in the same file (`manifest.md`) or in any number of markdown files. **bahsbud** will generate sevearl different files based on the content in the *manifest*. A readme file in markdown, a man page in troff format and the main script itself will all contain information and variables defined in the manifest.  

Commandline options are defined in a WYSIWYG style by writing a synopsis in the YAML part of the manifest. The values passed to the options will be available in the script as global variables named: `__LONG_OPTION_NAME`.

# installation
After cloning this repo, execute: `sudo make install` in the same directory as `Makefile`. After doing so you can execute `bashbud` with the options described below.  

**bashbud** will by default store user settings and new projects in the path described in the [ENVIRONMENT variable] **BASHBUD_NEW_SCRIPT_DIR**, which defaults to **XDG_CONFIG_HOME**/bashbud (*usually ~/.config/bashbud*).  

For more information, `bashbud --help` or `man bashbud`, or see the quickstart guide.

# about
`bashbud` can be used to quickly create new scripts with cli-option support and automatic documentation applied.

# usage

```shell
bashbud --help|-h  
bashbud --version|-v  
bashbud --lib  
bashbud --mode|-m [MODE] PROJECT  
bashbud --publish|-p PROJECT PATH  
bashbud --new|-n  PROJECT  
bashbud --bump|-b PROJECT  
bashbud --lorem PROJECT  

```

`--bump`|`-b` PROJECT  
`bump` option will update PROJECT by setting update date in `manifest.md` to the current date, and also bump the verion number with (current version + 0.001). It will also temporarly set the project in development mode (if it isn't already) and generate readme and manpage files for PROJECT.


`--help`|`-h`   
Show help and exit.


`--lib`   
If this flag is set all files in *bashbud/dev* will be concatenated into a new `bblib.sh` file. This option is inteded only for developers  developing the `bblib.sh` file.


`--lorem` PROJECT  
This will print all options and environment varialbes declared in `manifest.md` of PROJECT, that are missing descriptions. A file (doc/info/lorem.md) will get created (if it doesn't exist), containing placeholder (lorem impsum) text for all these options/


`--mode`|`-m` MODE  
Toggles the mode of PROJECT between **private** and **development**. MODE can also be explicitly set by specifying it.


`--new`|`-n` PROJECT  
This will create a new script named "BASHBUD_NEW_SCRIPT_DIR/NAME/NAME.sh" and copy the info template to the same directory. The bashbud.sh lib script will get linked to the lib directory of the script.


`--publish`|`-p` PROJECT  
This will *publish* PROJECT to **PATH** (*if PATH is not given it will default to:* `out/PROJECT.sh`). The published file is a single file script with all files in the `lib` directory appended (excluding `bblib.sh`), this is the fastest and most portable version of the script, and is intended for releases and installed versions.


`--version`|`-v`   
Show version and exit.


