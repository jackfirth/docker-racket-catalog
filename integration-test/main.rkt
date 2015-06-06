#lang racket

(require rackunit
         "routes.rkt")


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
