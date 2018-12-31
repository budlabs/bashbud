# generator priority


The priority of generators is as follows:  

1. project specific generator (**PSG**)
2. user specific generator (**USG**)
3. system wide generator (**SWG**)

Below are some examples to illustrate how this works:  


```
/usr/share/bashbud/
  generators/
    default/
      ...
    testgen/
      ...
  licenses/
    ...
  awklib/
    ...
  ...
```


```
BASHBUD_DIR/
    generators/
      default/
        ...
      mygen/
        ...
    licenses/
      ...
    awklib/
      ...
...
```


**project 1 directory**
```
PROJECT_DIR/
  manifest.md
```

**project 1 manifest.md**  
```
---
generator: default
...
```


When project 1 is updated, it will use the templates located in the **USG**: `deault` located in *BASHBUD_DIR*.

If we would change the value of the *generator* key in the manifest to `testgen`.
The templates in **SWG**: `testgen` in `/usr/share/bashbud` would be used to update the project.  

If no generator is specified in the manifest, it will have the default value: `default`. Which would result in the `default` **USG** would be used.  

If we would add a directory containing templates, named `bashbud` to *PROJECT_DIR*, that would would be seen as a **PSG** and have priority over any other generator.  

**project 2 directory**
```
PROJECT_DIR/
  bashbud/
    template1/
      ...
    template2/
      ...
  manifest.md
```

**project 2 manifest.md**  
```
---
generator: mygen
...
```

If project 2 would get updated it would use the templates from the **PSG** in *PROJECT_DIR*, ignoring the **USG** mygen, even if it is specified in the manifest and exist in *BASHBUD_DIR*.
