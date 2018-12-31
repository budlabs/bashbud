## template order

To have templates being processed in a certain order, place a file named
`__order` in the **template directory**.

EXAMPLE
-------

```
PROJECT_DIR/
  bashbud/
    version/
      __template
    about/
      __template
    manual/
      __template
    contact/
      __template
    __order
  manifest.md
```

The project above has a **PSG** (in the bashbud directory) with four templates:
version, about, contact and manual.


**PROJECT_DIR/bashbud/__order**  
```
# order of templates:

manual
apple

about
contact
```

Blank lines, lines starting with `#` and lines that are not names of existing templates are ignored.

Existing templates not included in the `__order` file will be appended in pseudorandom order to the list.

The order of the templates in the example project will look like this:  
```
manual
about
contact
version
```

This can be useful when the result of one template is used in another.
