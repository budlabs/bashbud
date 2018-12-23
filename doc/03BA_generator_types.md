# generator types

A project can use one of three types of generators:

1. Project specific generator (**PSG**)
2. User specific generator (**USG**)
3. System wide generator (**SWG**)

The type is determined based on the generators location.
If the generator is not project specific the value of the key:
`generator` in the projects **manifest** specifies which generator to use.


If no **PSG** exists and no value to the `generator` key in the manifest is declared.
The default **SWG** will be used if no default **USG** exists.


