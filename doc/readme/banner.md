I am banon

**bashbud** was created to simplify documentation and creation of bashscripts. All global configurations and info for a script is defined in YAML format and all documentation is written in markdown. The YAML and markdown can all be written in the same file (`manifest.md`) or in any number of markdown files. **bahsbud** will generate sevearl different files based on the content in the *manifest*. A readme file in markdown, a man page in troff format and the main script itself will all contain information and variables defined in the manifest.  

Commandline options are defined in a WYSIWYG style by writing a synopsis in the YAML part of the manifest. The values passed to the options will be available in the script as global variables named: `__LONG_OPTION_NAME`.
