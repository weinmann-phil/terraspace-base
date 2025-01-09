# Terraspace Base Project

This is a base project with deployment code for several standard resources.
It is based entirely on `OpenTofu` as the base technology and the `Terraspace`
wrapper.

It contains all modules I use or have used in deployments that follow a push
principle (i.e. that can be exported and shipped to a customer).

## Deploy

For detailed options on the modules, please refer to the examples within 
each module and their respective README sections.

For thoughts on architecting and deploying different solutions with this
base, please follow up on the documentation within `/docs`.

In principle, the deplooyment should go something like this...

To deploy all the infrastructure stacks:

    terraspace all up

To deploy individual stacks:

    terraspace up demo # where demo is app/stacks/demo

## Terrafile

To use more modules, add them to the [Terrafile](https://terraspace.cloud/docs/terrafile/).

## References

Needless to say, I'm not reinventing the wheel, so I will link here all 
articles and documentations I've gathered and used in putthing this project
together.

- []()
