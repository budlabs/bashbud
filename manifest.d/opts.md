# options-bump-description

The current working direcory will be set as PROJECT_DIR if none is specified.
When a project is *bumped*, 
`bashbud` will read the *manifest.md* file in PROJECT_DIR,
(*or exit if no manifest.md file exists*).
If a generator **type** is specified in the **front matter** 
(the *YAML* section starting the document)
of the *manifest.md* file,
that generator will be used to update the project based on the content of the *manifest.md* file
and the *manifest.d* directory (*if it exists*).
If a directory named *bashbud* exists within *PROJECT_DIR*,
that directory will be used as a generator.

# options-new-description

Creates a new project at TARGET_DIR
(*if TARGET_DIR doesnt exist, if it does script will exit*),
based on GENERATOR.
If GENERATOR is omitted the **default** generator will be used.
After all files are copied and linked,
the project is *bumped*
(*same as:* `bashbud --bump TARGET_DIR`).

# options-link-description

Add any missing links from the generators `__link` directory,
to `PROJECT_DIR`.

# options-help-description

Show help and exit.

# options-version-description

Show version and exit.
