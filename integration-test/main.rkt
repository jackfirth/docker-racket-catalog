#lang racket

(require rackunit
         "rest/main.rkt"
         "rest/rest-catalog.rkt")

(module+ test
  (define current-requester (make-parameter #f))
  
  (define-check (check-get-not-exn location)
    (check-not-exn (thunk (get (current-requester) location))))
  (define-check (check-get location response)
    (check-equal? (get (current-requester) location) response))
  (define-check (check-put location body response)
    (check-equal? (put (current-requester) location body) response))
  (define-check (check-get-exn exn-pred location)
    (check-exn exn-pred (thunk (get (current-requester) location))))
  
  (define catalog-container-requester (make-pkg-catalog-requester "http://catalog:8000"))
  
  (parameterize ([current-requester catalog-container-requester])
    (check-get-not-exn "/pkgs")))
