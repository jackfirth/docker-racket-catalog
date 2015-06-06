#lang racket

(require rackunit
         "fetch.rkt")

(provide check-route-up
         check-route-equal
         check-route-pred)


(define (route->url-string route)
  (string-append "http://catalog:8000" route))

(define fetch-route (compose fetch route->url-string))
(define fetch-route/read (compose fetch/read route->url-string))

(define-check (check-route-up route)
  (check-not-exn (thunk (fetch-route route))))

(define-check (check-route-equal route expected-read-value)
  (check-equal? (fetch-route/read route)
                expected-read-value))

(define-check (check-route-pred route pred)
  (check-pred pred (fetch-route/read route)))
