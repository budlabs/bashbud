# linked generators

Creating a **USG** (or a **SWG**), that instead of having its templates located in `GENERATOR_DIR/__templates`,
have them at `GENERATOR_DIR/__link/bashbud`.
Will have the effect that whenever a new project is created it will have a **PSG** (`PROJECT_DIR/bashbud`), and the templates being linked to `GENERATOR_DIR/__link/bashbud`.
This solves the issues of local projects not being able to share templates while still being fully portable. 
It is also a way to use `--new` with **PSG**.

This is the recommended way of using bashbud.
