#lang racket

(require net/url
         fancy-app)

(provide fetch
         fetch/read
         put/write
         delete
         delete/read)


(define (fetch url-string)
  (call/input-url (string->url url-string) get-pure-port port->string))

(define (fetch/read url-string)
  (read (open-input-string (fetch url-string))))

(define (put/write url-string v)
  (call/input-url (string->url url-string)
                  (put-pure-port _ (string->bytes/utf-8 (~s v)))
                  (compose read open-input-string port->string)))

(define (delete url-string)
  (call/input-url (string->url url-string)
                  delete-pure-port
                  port->string))

(define (delete/read url-string)
  (read (open-input-string (delete url-string))))
