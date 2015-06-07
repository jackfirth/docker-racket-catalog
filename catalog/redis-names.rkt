#lang racket

(provide all-pkgs-key
         pkg-names-key
         pkg-details-key)

(module+ test
  (require rackunit))


(define all-pkgs-key "ALL_PACKAGE_DETAILS")
(define pkg-names-key "ALL_PACKAGE_NAMES")


(define (pkg-details-key pkg-name)
  (string-append "PKG_" pkg-name))

(module+ test
  (check string=? (pkg-details-key "foo") "PKG_foo"))
