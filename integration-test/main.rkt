#lang racket

(require rackunit
         "routes.rkt")

(define-syntax-rule (matches? pattern v)
  (match v
    [pattern #t]
    [_ #f]))

(define (all-pkgs? v)
  (matches? (hash-table ["foo" (? hash?)]
                        ["bar" (? hash?)])
            v))


(module+ test
  
  (test-case
   "Package catalog summary route"
   (check-route-up "/pkgs")
   (check-route-get "/pkgs" '("bar" "foo")))
  
  (test-case
   "Package details route"
   (check-route-up "/pkg/foo")
   (check-route-up "/pkg/bar")
   (check-route-get-pred "/pkg/foo" hash?)
   (check-route-get-pred "/pkg/bar" hash?))
  
  (test-case
   "Entire package catalog route"
   (check-route-up "/pkgs-all")
   (check-route-get-pred "/pkgs-all" all-pkgs?)))
