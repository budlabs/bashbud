## the synopsis variable and options array

The key `synopsis` will be translated to an array called *options* when parsed by `bashbud`.
If used properly this will be the only place needed to declare command-line options in a *project*.
Let's take a closer look at the `synopsis` key from the example manifest above.  

```text
synopsis: |
    --help|-h [COMMAND]
    --version|-v
    --new FILE **DIRECTORY**
```


The pipe (`|`) character, after the key definition, is [YAML] syntax meaning that the content of the key should be interpreted literal.
Which in turn means it will preserve linebreaks as they are written.
The indentation specifies the scope.  

Translated to a `bash` variable, it would look like this:  

```text
synopsis'--help|-h [COMMAND]
--version|-v
--new FILE **DIRECTORY**'
```

The above is also what would be printed if `%%synopsis%%` would be used in a [template].


But as mentioned, the content of the synopsis will also get stored in a special array called *options*:   


```text
options[help][long]=help
options[help][short]=h
options[version][long]=version
options[version][short]=v
options[new][long]=new
options[new][arg]=FILE
```

Notice that the option `--help` in the synopsis have an *optional* argument defined,
(`[COMMAND]`) and that it is ignored in the array.
Sometimes it is also desired to have a mandatory argument, 
that doesn't belong to the preceding option.
Such arguments should be enclosed withing double asterisks (`**DIRECTORY**`).
