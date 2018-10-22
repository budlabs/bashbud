# long-description

this text is "long-description", it is currently defined in `doc/info/description.md` but the content of that file could just as well be included in `manifest.md`.  

All files with the `.md` extension in `doc/info` will be appended to `manifest.md` when parsing for info variables.  

An info variable can be either "long-description", "option-LONG_OPTION_NAME" or "env-ENVIRONMENT_VARIABLE_NAME". Where LONG_OPTION_NAME is the name of an option defined in the **synopsis** key in the frontmatter of `manifest.md` . Same with ENVIRONMENT_VARIABLE_NAME, needs to exist in the **environment-varables** dictionary in in the frontmatter of `manifest.md`. Options and environment variables that aren't in the frontmatter of `manifest.md` will be ignored.

The variables are defined by prefixing them with a single `#` (a **H1** markdown header) all text following till a new variable definition or EOF will be the content of that variable (excluding leading and trailing blank lines).  

The content of these variables are used in manpage, readme and `--help` output (with the exception of environment variables being excluded from the readme).
