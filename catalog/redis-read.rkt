#lang racket

(require redis)

(provide define/redis
         GET/read
         SET/write)

(module+ test
  (require rackunit))


(define (redis-container-connect)
  (connect #:host "redis"))

(define (on-exit exit-thunk body-thunk)
  (dynamic-wind void body-thunk exit-thunk))

(define-syntax-rule (with-custom-redis-connection conn body ...)
  (parameterize ([current-redis-connection conn])
    (on-exit disconnect (thunk body ...))))

(define-syntax-rule (with-redis-container-connection body ...)
  (with-custom-redis-connection (redis-container-connect) body ...))

(define-syntax-rule (define/redis header body ...)
  (define header
    (with-redis-container-connection body ...)))


(define read-from-bytes
  (compose read open-input-string bytes->string/utf-8))

(module+ test
  (check-equal? (read-from-bytes #"(\"a\" \"b\" \"c\")")
                '("a" "b" "c")))


(define GET/read
  (compose read-from-bytes GET))

(define (SET/write k v)
  (SET k (~s v)))
