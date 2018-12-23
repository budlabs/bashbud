## generators

A generator is a directory containing templates and base files used to create or update (*bump*) a project.
See [anatomy of a generator directory](#anatomy_of_a_generator_directory) for the file structure.
When a new project is created
(with the `--new` option)
`bashbud` will do the following:  

1. [determine location of generator](#determine_location_of_generator)
2. [copy base files](#copy_base_files)
3. [create links](#copy_base_files)
4. [process templates](#process_templates)

### determine location of generator

The location of a generator can either be: 

1. project specific
2. user specific
3. system wide

`bashbud` will try these locations in this order and use the first found one. 

Project specific generators are located in the root directory of a project in a directory called *bashbud*.  

user specific generators are located in 
*BASHBUD_DIR* (which defaults to `~/.config/bashbud`) in which a directory named *generators* holds separate directories for each *generator type*.  

system wide generators are located in 
`/usr/share/bashbud` in which a directory named *generators* holds separate directories for each *generator type*. By default the only system wide *generator type* available is *default*.  

The *generator type* is specified in the *front matter* of the projects manifest.
If a project specific generator exists,
that will override any specified *generator type*.
The *generator type* can also be specified when creating a new project wit the `--new` command-line option.

### copy base files

*user specific* and *system wide* generator directories look something like this:  

```text
generators/
  default/      
    __link/     
      lib/
        ERR.sh
    __templates/
      program/
        __template
        __script
      readme/
        __template
    manifest.d/
      opts.md
      envs.md
    main.sh
    manifest.md
```

All files and directories within the root directory of the generator (*default*) that doesn't start with two underscores are referred to in the documentation as base files.
The base files will get copied to PROJECT_DIR when the project is created with the `--new` command-line option.  

```text
PROJECT_DIR/
    manifest.d/
        opts.md
        envs.md
    main.sh
    manifest.md
```

The directory structure inside the `__link` directory will get created in PROJECT_DIR when the project is created with the `--new` command-line option. And all files found (recursively) in the `__link` directory will get hard linked (`ln`) to PROJECT_DIR.  

```text
PROJECT_DIR/
    lib/
        ERR.sh     <- linked
    manifest.d/
        opts.md
        envs.md
    main.sh
    manifest.md
```

The content of the `__templates` directory is only used when a project is updated with the `--bump` command-line option.
It is actually the only part of a generator needed when a PROJECT is updated.  

A project specific generator is a directory named bashbud that only contains template directories:  

```text
PROJECT_DIR/
    bashbud/
        program/
            __template
            __script
        readme/
            __template
    manifest.md
    ...
```


