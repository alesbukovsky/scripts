# `api.sh`

API specification editor launcher for MacOS.

An editor's detached Docker container is started, if not already running. A Chrome browser window / tab is open with the editor's main page. Upon stopping, the container is deleted, along with any associated volume(s).

Prerequisites:

* [Docker CLI](https://www.docker.com/products/docker-desktop/)

Usage:
```
api.sh [-h] [-p <port>] <type>
```

Options:

* `-h`
        
    Show usage description.

* `-p <port>`

    Local port to attach the editor to, default is `9001`.

* `type`   

    Specification / editor type:
  
    * `async`: [AsyncAPI](https://www.asyncapi.com/docs/reference/specification/v3.0.0) Studio
    * `open`: [OpenAPI](https://spec.openapis.org/oas/latest.html) / Swagger Editor

Examples:

``` 
api.sh -p 9090 open
```
