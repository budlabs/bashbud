# system wide generator (**SWG**)

A **SWG** have the exact same file structure as a [user specific generator],
the only difference being it's location in the filesystem.

A **SWG** is located in `/usr/share/bashbud/generators/` while a **USG** is located in `BASHBUD_DIR/generators/`.

If a both a **SWG** and a **USG** have the same name, **USG** will have priority.

By default there only exist one **SWG**: `default`.
