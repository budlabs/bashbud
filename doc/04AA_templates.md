# templates

Templates are processed as the last action when the `--new` command-line option is used
or as the sole action when the `--bump` command-line option is used.

A template consist of three parts:  

1. Comment area
2. YAML front matter
3. Template body

below is a simple template example:  

```text
function that prints script name and version
information to stderr.
---
target:   lib/printversion.sh
markdown: false
wrap:     50
...
___printversion(){
  
cat << 'EOB' >&2
%%name%% - version: %%version%%
updated: %%updated%% by %%author%%
EOB
}
```

### the template front matter

A **YAML front matter** is mandatory in all templates,
but none of the keys, except **target**, in the front matter is.

The front matter needs to start with three dashes (`---`) as the only content of a line,
and end with three dots (`...`) as the only content of a line.
The front matter needs to be defined **before** the **template body**.
Any text before the start of the front matter will be ignored by `bashbud` and can be used to write comments about the template it self.  

### template front matter keys

| key      | description | default |
|:---------|:------------|:--------|
| target   | destination of the generated file relative to the current **PROJECT**s *manifest.md*. | - |
| markdown | if set to false, all expanded variables and imported markdown files will have their markdown stripped | false |
| wrap     | if set to an integer higher then 0 all expanded variables and imported markdown files paragraphs will get wrapped at the column specified. This applies even if the **markdown key** is set to false. | 0 |

### template body

`bashbud` will parse the **template body** and evaluate and expand the expressions defined within double percentage symbols (`%%`).  
