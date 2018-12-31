## manifest front matter

The manifest front matter is the only mandatory part of the manifest. 
It needs to be defined before the manifest body in the `manifest.md` file,
in [YAML] format (starting with three dashes (`---`) and ending with thre dots (`...`).  

The front matter can contain any number of user defined, variables, lists and arrays, but some keys are special.

## special variables in the manifest front matter

The key `generator` tells `bashbud` what [generator] to use,
it is not mandatory and defaults to: `default` if omitted
and is always overridden by a [project specific generator].

Another special variable is [synopsis].
