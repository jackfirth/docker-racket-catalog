#lang racket

(require "pkg-catalog.rkt"
         "pkg-server.rkt"
         fancy-app
         spin)


(define foo-pkg-details
  (hasheq 'source "git://github.com/foo/foo"
          'name "foo"
          'checksum "foo"
          'author "Foo Foo"
          'description "foo package"
          'tags '("foo")
          'dependencies '()
          'modules '((lib "foo/main.rkt"))))

(define bar-pkg-details
  (hasheq 'source "git://github.com/bar/bar"
          'name "bar"
          'checksum "bar"
          'author "Bar Bar"
          'description "bar package"
          'tags '("bar")
          'dependencies '("foo")
          'modules '((lib "bar/main.rkt"))))

(define mock-pkg-dict
  (hash "foo" foo-pkg-details
        "bar" bar-pkg-details))

(define mock-pkg-catalog
  (package-dict->package-catalog mock-pkg-dict))

(set-catalog-routes mock-pkg-catalog)


(module+ main
  (displayln "Running...")
  (run #:listen-ip #f
       #:port 8000))
