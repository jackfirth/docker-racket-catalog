#lang racket

(provide
 (contract-out
  [all-pkgs-key string?]
  [pkg-names-key string?]
  [pkg-details-key (-> string? string?)]))

(module+ test
  (require rackunit))


(define all-pkgs-key "ALL_PACKAGE_DETAILS")
(define pkg-names-key "ALL_PACKAGE_NAMES")


(define (pkg-details-key pkg-name)
  (string-append "PKG_" pkg-name))

(module+ test
  (check string=? (pkg-details-key "foo") "PKG_foo"))
