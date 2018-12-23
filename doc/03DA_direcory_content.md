# directory content

**USG** and **SWG** generator directories look something like this:  

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


