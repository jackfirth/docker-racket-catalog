#lang racket

(require rackunit
         "routes.rkt")

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

(module+ test
  
  (test-case
   "GET-PUT /pkg/:name - Package details route"
   
   (test-case
    "PUT /pkg/:name"
    (check-route-up "/pkg/foo")
    (check-route-up "/pkg/bar")
    (check-route-put "/pkg/foo" foo-pkg-details)
    (check-route-put "/pkg/bar" bar-pkg-details))
   
   (test-case
    "GET /pkg/:name"
    (check-route-up "/pkg/foo")
    (check-route-up "/pkg/bar")
    (check-route-get "/pkg/foo" foo-pkg-details)
    (check-route-get "/pkg/bar" bar-pkg-details))
   
   (test-case
    "GET /pkgs - Package catalog summary route"
    (check-route-up "/pkgs")
    (check-route-get "/pkgs" '("bar" "foo")))
   
   (test-case
    "GET /pkgs-all - Entire package catalog route"
    (check-route-up "/pkgs-all")
    (check-route-get "/pkgs-all" (hash "foo" foo-pkg-details
                                       "bar" bar-pkg-details)))))
   
   