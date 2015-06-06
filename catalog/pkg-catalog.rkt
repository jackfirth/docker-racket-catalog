#lang racket

(require "pkg-detail.rkt")

(provide
 (contract-out
  [struct package-catalog
    ([all-pkgs-thunk (-> (hash/c string? pkg-detail?))]
     [pkg-names-thunk (-> (listof string?))]
     [pkg-details-proc (-> string? pkg-detail?)])]
  [all-pkgs (-> package-catalog? (hash/c string? pkg-detail?))]
  [pkg-names (-> package-catalog? (listof string?))]
  [pkg-details (-> package-catalog? string? pkg-detail?)]
  [package-dict->package-catalog (-> (hash/c string? pkg-detail?) package-catalog?)]))

(module+ test
  (require rackunit))


(struct package-catalog (all-pkgs-thunk pkg-names-thunk pkg-details-proc))

(define (all-pkgs catalog)
  ((package-catalog-all-pkgs-thunk catalog)))

(define (pkg-names catalog)
  ((package-catalog-pkg-names-thunk catalog)))

(define (pkg-details catalog name)
  ((package-catalog-pkg-details-proc catalog) name))

(define (package-dict->package-catalog pkg-dict)
  (define (all-pkgs-thunk) pkg-dict)
  (define (pkg-names-thunk)
    (dict-keys pkg-dict))
  (define (pkg-details-proc name)
    (dict-ref pkg-dict name))
  (package-catalog all-pkgs-thunk pkg-names-thunk pkg-details-proc))

(module+ test
  (test-begin
   (define foo-pkg-details #hasheq((source . "path/to/foo")
                                   (checksum . 0)
                                   (name . "foo")))
   (define bar-pkg-details #hasheq((source . "path/to/bar")
                                   (checksum . 0)
                                   (name . "bar")))
   (define pkg-dict (hash "foo" foo-pkg-details
                          "bar" bar-pkg-details))
   (define pkg-catalog (package-dict->package-catalog pkg-dict))
   (check-pred package-catalog? pkg-catalog)
   (check-equal? (all-pkgs pkg-catalog) pkg-dict)
   (check-equal? (sort (pkg-names pkg-catalog) string<?) '("bar" "foo"))
   (check-equal? (pkg-details pkg-catalog "foo") foo-pkg-details)))
