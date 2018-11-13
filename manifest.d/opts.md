# option-publish

This will *publish* PROJECT to **PATH** (*if PATH is not given it will default to:* `out/PROJECT.sh`). The published file is a single file script with all files in the `lib` directory appended (excluding `bblib.sh`), this is the fastest and most portable version of the script, and is intended for releases and installed versions.

# option-lorem

This will print all options and environment varialbes declared in `manifest.md` of PROJECT, that are missing descriptions. A file (doc/info/lorem.md) will get created (if it doesn't exist), containing placeholder (lorem impsum) text for all these options/

# option-bump

`bump` option will update PROJECT by setting update date in `manifest.md` to the current date, and also bump the verion number with (current version + 0.001). It will also temporarly set the project in development mode (if it isn't already) and generate readme and manpage files for PROJECT.

# option-lib

If this flag is set all files in *bashbud/dev* will be concatenated into a new `bblib.sh` file. This option is inteded only for developers  developing the `bblib.sh` file.


# option-mode

Toggles the mode of PROJECT between **private** and **development**. MODE can also be explicitly set by specifying it.

# option-new

This will create a new script named "BASHBUD_NEW_SCRIPT_DIR/NAME/NAME.sh" and copy the info template to the same directory. The bashbud.sh lib script will get linked to the lib directory of the script.


# option-help
Show help and exit.

# option-version
Show version and exit.
