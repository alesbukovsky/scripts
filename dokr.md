# `dokr.sh`

Provides rudimentary management for local development tools via Docker containers.

Prerequisites:

* [Docker CLI](https://www.docker.com/products/docker-desktop/)
* Environment variable `DOCKER_SPEC_HOME` pointing to a directory with  Compose YAML [specifications](https://docs.docker.com/compose/compose-file)

Specification needs to follow a naming convention, where a unique `name` is eventually passed to the `dokr.sh` as a parameter:

* The YAML file is named `<name>.yaml`.
* Service containers are prefixed with `<name>`.

Usage:
```
dokr.sh [-h] <name> <command>
```

Options:

* `-h`
        
    Show usage description.

* `name`

    Name of the tool to execute the given command for.

* `command`   

    Action to take with given tool:
  
    * `down`: stops the container(s) associated with the tool
    * `up`: starts the container(s) specified for the tool

Examples:

``` 
dokr.sh mongo up
```
