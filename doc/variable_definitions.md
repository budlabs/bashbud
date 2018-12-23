### variable definition

Variables to be used inside templates can only be defined in the *manifest*.
Variables can either be defined in the **manifest front matter** in YAML format.
Or in the manifest body in markdown format.
The name of a variable created in the **manifest body** is the name of the last defined heading 
(*a line starting with one or more hashes:* `#`).
A variables can only consist of alphanumeric characters and underscores (`_`).
Normal dashes (`-`) have a special function and should only be used when referring to arrays.
Leading and trailing blank new lines will not be included in the variable.

EXAMPLE
-------

**manifest.md**  
```text
---
author:        budRich
...
# my_great_variable

This is a test **variable**
to demonstrate how definitions work.



# another_variable
test 2 this line ends with two spaces  
line number two

line number three


line number four, ending with two spaces  

line number five
```

The **manifest.md** above will have the following variables:

(*written in bash format for clarity*)  

```text
author='budRich'
my_great_variable='This is a test **variable** to demonstrate how definitions work'
another_variable='test 2 this line ends with two spaces
line number two
line number three

line number four, ending with two spaces  

line number five'
```

Notice how line breaks are handled.
Paragraphs are concatenated to one line.
To make a hard linebreak in markdown, end the line with two spaces `  `. 
Blank lines are translated to a linebreak character, to add an actual blank line, 
add two blank lines
or
two spaces followed by a blank line.
