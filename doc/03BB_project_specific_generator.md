# Project specific generators (**PSG**)

A **PSG** is unique to a certain project.
A **PSG** is defined by creating a directory in a projects root directory named `bashbud` that contain templates.
This directory have the same file structure as a `__templates` directory of a **USG**.

**PSG** have highest priority of generators and is used if a **PSG** directory exist,
even if the `generator` key in the **manifest** have a value.

The purpose and advantage of using a **PSG** for a project is that it makes the *bashbud build* portable. Anyone can clone the project and use `bashbud --bump` to get the same output.
**PSG** is the recommended generator type, especially for public projects.


The disadvantage of using a **PSG** instead of the other generator types:

1. A **PSG** is unique to a project, meaning that changes done to the generator will not apply to other bashbud generators. This can however be done by using [linked generators].
2. A **PSG** can not be used to create a new bashbud project, only update.


Below is an example of how the file tree would look like in a project using a **PSG**:  


```text
PROJECT_DIR/
    bashbud/
        readme/
            __template
        program/
            __template
            __script
    manifest.d/
        ...
    manifest.md
    ...
```

When this project would get updated with the `--bump` command-line option, 
the templates within the subdirectories of the *bashbud* directory would get get processed.
