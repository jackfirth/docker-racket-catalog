#lang racket

(require net/url)

(define (fetch url-string)
  (call/input-url (string->url url-string) get-pure-port port->string))

(define (fetch/read url-string)
  (read (open-input-string (fetch url-string))))

(module+ test
  (require rackunit)
  (check-equal? (fetch "http://catalog:8000") "hi")
  (check-equal? (fetch/read "http://catalog:8000/pkgs") '("foo")))
