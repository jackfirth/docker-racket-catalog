# docker-racket-catalog [![Circle CI](https://circleci.com/gh/jackfirth/docker-racket-catalog.svg?style=svg)](https://circleci.com/gh/jackfirth/docker-racket-catalog)

Dockerized Racket webserver running a Racket package catalog 

Deployed via Tutum at http://catalog.racket-catalog.jackfirth.svc.tutum.io:8000/pkgs

See the [package catalog protocol docs](http://docs.racket-lang.org/pkg/catalog-protocol.html) for a description of the available routes.

TODO:

- ~~Add REST pkg creation protocol~~
- ~~Add REST pkg mutation protocol~~
- Add package deletion
- Add authentication layer
- Add better error handling for malformed inputs on package creation/mutation
- Add frontend app
- Add version-query support
