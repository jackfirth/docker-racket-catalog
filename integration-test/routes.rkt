#lang racket

(require rackunit
         "fetch.rkt")

(provide check-route-up
         check-route-equal
         check-route-pred)


(define (route->url-string route)
  (string-append "http://catalog:8000" route))

(define-check (check-route-up route)
  (check-not-exn (thunk (fetch (route->url-string route)))))

(define-check (check-route-equal route expected-read-value)
  (check-equal? (fetch/read (route->url-string route))
                expected-read-value))

(define-check (check-route-pred route pred)
  (check-pred pred (fetch/read (route->url-string route))))
