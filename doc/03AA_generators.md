## generators

A generator is a directory containing templates and base files used to create or update (*bump*) a project.
When a new project is created
(with the `--new` option)
`bashbud` will do the following:  

1. [determine location of generator](#determine_location_of_generator)
2. [copy base files](#copy_base_files)
3. [create links](#copy_base_files)
4. [process templates](#process_templates)

When a project is updated with the `--bump` command-line option, it will process the templates and scripts corresponding to the projects generator.

