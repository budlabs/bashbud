## import file content with cat

Sometimes it can be desired to import files that with content not defined in the manifest.
This can be done by using the **cat** function within templates:  

```text
example 1. import single file import:
%%cat FILE%%

example 2. import all files in a directory:
%%cat DIR/*%%

example 3. import the n last modified files in a directory:
%%cat DIR/* n%%

example 4. import single file, exclude lines matching PATTERN:
%%cat -v 'PATTERN' FILE%%

example 5. import the three last modified files in a directory, exclude lines matching PATTERN:
%%cat -v 'PATTERN' DIR/* 3%%
```

If the imported file have the extension `md` (*FILE.md*),
line wrapping will be applied to all paragraphs according to the wrap key in the templates front matter.

Lets add two directories and some files to our example project:  

```text
PROJECT_DIR/
    manifest.md
    doc/
      test1.md
      test2.md
      test3.md
    functions/
      hello.sh
      cleanup.sh
```

**doc/test1.md**  
```text
# test1 file

this is just a test file made to demonstrate how the `cat` function in **bashbud** templates work.
```

**doc/test2.md**  
```text
test2 file

more stupid
test files  
last line ended with two spaces
```

**doc/test3.md**  
```text


test3 file

this file have two leading and trailing blank lines


```

**functions/hello.sh**  
```text
#!/bin/bash

# usage:
# hello NAME
#
# prints 'hello NAME' to stdout
hello() { echo "hello $1" ;}
```

**functions/cleanup.sh**  
```text
#!/bin/bash

# cleanup function
DEATH() {
    exit
}
```

Now lets try the different ways the **cat** function can be used.  

**__template**  
```text
---
target: cat-example1.txt
markdown: false
wrap: 20
...
example 1. import single file import:
%%cat doc/test1.md%%

text after import ...
```

**PROJECT_DIR/cat-example1.txt**  
```
example 1. import single file import:
# test1 file

this is just a test
file made to
demonstrate how the
cat function in
bashbud templates
work.

text after import ...
```

Notice how markdown markup is stripped from the file content and that the paragraph is wrapped at column 20.
Also notice that the first line from the template is not wrapped,
this is because the line is part of the template and not considered a markdown paragraph by `bashbud`.  

**__template**  
```text
---
target: cat-example2.txt
markdown: true
wrap: 20
...
example 2. import all files in a directory:
%%cat doc/*%%

text after import ...
```

**PROJECT_DIR/cat-example2.txt**  
```
example 2. import all files in a directory:
# test1 file

this is just a test
file made to
demonstrate how the
`cat` function in
**bashbud** templates
work.

test2 file
more stupid test
files
last line ended
with two spaces



test3 file
this file have two
leading and
trailing blank
lines



text after import ...
```

A blank line is automatically added after each file is imported. Take notice how wrapping and linebreaks are applied.  

For this next example, let's assume `test3.md` is the last modified file and `test1.md` was the first modified file.  

**__template**  
```text
---
target: cat-example3.txt
markdown: true
wrap: 0
...
example 3. import the n last modified files in a directory:
%%cat doc/* 2%%

text after import ...
```

**PROJECT_DIR/cat-example3.txt**  
```
example 3. import the n last modified files in a directory:
test2 file
more stupid test files  
last line ended with two spaces



test3 file
this file have two leading and trailing blank lines


text after import ...
```


**__template**  
```text
---
target: cat-example5.txt
markdown: true
wrap: 20
...
example 5. import all files in a directory, exclude lines matching PATTERN , (lines with a leading hash):
%%cat -v '^#' functions/*%%

text after import ...
```

**PROJECT_DIR/cat-example5.txt**  
```
example 5. import all files in a directory, exclude lines matching PATTERN , (lines with a leading hash):

hello() { echo "hello $1" ;}


DEATH() {
    exit
}

text after import ...
```

Notice how none of the lines are wrapped since the files imported aren't markdown files with the `md` extension.
