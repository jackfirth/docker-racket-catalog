#lang racket

(require "pkg-catalog.rkt"
         "pkg-server.rkt"
         "redis-catalog.rkt"
         fancy-app
         spin
         redis)


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
  (make-hash
   `(("foo" . ,foo-pkg-details)
     ("bar" . ,bar-pkg-details))))

(define mock-pkg-catalog
  (package-dict->package-catalog mock-pkg-dict))

(set-catalog-routes redis-catalog)


(module+ main
  (set-redis-catalog! mock-pkg-catalog)
  (displayln "Running...")
  (run #:listen-ip #f
       #:port 8000))
