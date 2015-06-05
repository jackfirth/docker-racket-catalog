#lang racket

(require spin
         fancy-app)

(define foo-pkg-details
  (hasheq 'source "git://github.com/foo/foo"
          'checksum "foo"
          'author "Foo Foo"
          'description "foo package"
          'tags '("foo")
          'dependencies '()
          'modules '((lib "foo/main.rkt"))))


(define-syntax-rule (thunk-print body ...)
  (thunk (displayln "Request received") body ...))

(get "/" (thunk-print "hi"))

(define get-pkgs (get "/pkgs" _))

(get-pkgs (thunk-print (~s '("foo"))))

(get "/pkg/foo" (thunk-print (~s foo-pkg-details)))

(module+ main
  (displayln "Running...")
  (run #:listen-ip #f #:port 8000))
