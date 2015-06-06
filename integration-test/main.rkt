#lang racket

(require rackunit
         "fetch.rkt")


(define (route->url-string route)
  (string-append "http://catalog:8000" route))

(define-check (check-route-up route)
  (check-not-exn (thunk (fetch (route->url-string route)))))

(define-check (check-route-equal route expected-read-value)
  (check-equal? (fetch/read (route->url-string route))
                expected-read-value))

(define-check (check-route-pred route pred)
  (check-pred pred (fetch/read (route->url-string route))))


(module+ test
  (test-begin
   (check-route-up "/pkgs")
   (check-route-equal "/pkgs" '("bar" "foo"))
   (check-route-up "/pkg/foo")
   (check-route-up "/pkg/bar")
   (check-route-pred "/pkg/foo" hash?)
   (check-route-pred "/pkg/bar" hash?)
   (check-route-up "/pkgs-all")
   (check-route-pred "/pkgs-all" hash?)))
