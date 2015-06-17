#lang racket

(provide foo-pkg-details
         bar-pkg-details
         foo-bar-pkgs)


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


(define foo-bar-pkgs
  (hash "foo" foo-pkg-details
        "bar" bar-pkg-details))
