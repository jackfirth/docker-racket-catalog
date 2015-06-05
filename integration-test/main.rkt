#lang racket

(require net/url)

(define (fetch url-string)
  (call/input-url (string->url url-string) get-pure-port port->string))

(define (fetch/read url-string)
  (read (open-input-string (fetch url-string))))

(module+ test
  (require rackunit)
  (test-begin
   (check-not-exn (thunk (fetch "http://catalog:8000/pkgs")))
   (check-equal? (fetch/read "http://catalog:8000/pkgs") '("foo"))
   (check-pred hash? (fetch/read "http://catalog:8000/pkg/foo"))))
