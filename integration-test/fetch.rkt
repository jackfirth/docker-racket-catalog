#lang racket

(require net/url)

(provide fetch fetch/read)


(define (fetch url-string)
  (call/input-url (string->url url-string) get-pure-port port->string))

(define (fetch/read url-string)
  (read (open-input-string (fetch url-string))))
