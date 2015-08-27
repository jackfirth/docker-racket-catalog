# docker-racket-catalog [![Circle CI](https://circleci.com/gh/jackfirth/docker-racket-catalog.svg?style=svg)](https://circleci.com/gh/jackfirth/docker-racket-catalog)

Dockerized Racket webserver running a Racket package catalog backed by a Redis store.

Deployed via Tutum at http://proxy.racket-catalog.jackfirth.svc.tutum.io:8080/

See the [package catalog protocol docs](http://docs.racket-lang.org/pkg/catalog-protocol.html) for a description of the available routes.

TODO:

- ~~Add REST pkg creation protocol~~
- ~~Add REST pkg mutation protocol~~
- ~~Add package deletion~~
- ~~Specify content type~~ (`application/racket`)
- ~~Add identity layer to package server through email in headers~~
- ~~Prevent PUT/DELETE requests to packages for which the current agent is not the author~~
- ~~Fix nonexistant packages not giving 404 errors~~
- ~~Add nginx reverse-proxy which serves up static assets including a compiled frontend app and forwards api requests to the catalog service~~
- Add authentication container that takes a JWT token and verifies it, then forwards valid requests to the internal catalog container with an appropriate email in the headers
- ~~Add frontend app~~
- Support JSON content type responses through content negotiation via headers
- Add better error handling for malformed inputs on package creation/mutation
- Add version-query support
