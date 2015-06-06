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
  (test-begin
   (check-route-up "/pkgs")
   (check-route-equal "/pkgs" '("bar" "foo"))
   (check-route-up "/pkg/foo")
   (check-route-up "/pkg/bar")
   (check-route-pred "/pkg/foo" hash?)
   (check-route-pred "/pkg/bar" hash?)
   (check-route-up "/pkgs-all")
   (check-route-pred "/pkgs-all" all-pkgs?)))
