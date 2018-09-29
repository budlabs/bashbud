# `bashbud` - Boilerplate and template maker for bash scripts

SYNOPSIS
--------

bashbud `--help`|`-h`  
bashbud `--version`|`-v`  
bashbud `--lib`  
bashbud `--mode`|`-m` [MODE] **PROJECT**  
bashbud `--publish`|`-p` PROJECT **PATH**  
bashbud `--new`|`-n`  PROJECT  
bashbud `--bump`|`-b` PROJECT  
bashbud `--lorem` PROJECT  


DESCRIPTION
-----------

`bashbud` can be used to quickly create new scripts with cli-option support and automatic documentation applied.


OPTIONS
-------

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


ENVIRONMENT
-----------

**BASHBUD_NEW_SCRIPT_PATH**  
Path to a directory where new scripts are linked. It is recommended to have this directory in PATH.

**BASHBUD_ALL_SCRIPTS_PATH**  
Array of directories, separated by **:** in which `bashbud` projects cand be stored. Used to list and search for projects.

**BASHBUD_NEW_SCRIPT_DIR**  
Path to directory where new scripts are placed.


DEPENDENCIES
------------

bash  
gawk  
sed  