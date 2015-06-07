#lang racket

(require "pkg-detail.rkt")

(provide
 (contract-out
  [struct package-catalog
    ([all-pkgs-thunk (-> pkg-hash/c)]
     [pkg-names-thunk (-> (listof string?))]
     [pkg-details-proc (-> string? pkg-detail?)]
     [set-pkg-details-proc (-> string? pkg-detail? void?)])]
  [pkg-hash/c contract?]
  [all-pkgs (-> package-catalog? pkg-hash/c)]
  [pkg-names (-> package-catalog? (listof string?))]
  [pkg-details (-> package-catalog? string? pkg-detail?)]
  [set-pkg-details! (-> package-catalog? string? pkg-detail? void?)]
  [package-dict->package-catalog (-> pkg-hash/c package-catalog?)]))

(module+ test
  (require rackunit))


(define pkg-hash/c
  (hash/c string? pkg-detail?))

(struct package-catalog
  (all-pkgs-thunk pkg-names-thunk pkg-details-proc set-pkg-details-proc))

(define (all-pkgs catalog)
  ((package-catalog-all-pkgs-thunk catalog)))

(define (pkg-names catalog)
  ((package-catalog-pkg-names-thunk catalog)))

(define (pkg-details catalog name)
  ((package-catalog-pkg-details-proc catalog) name))

(define (set-pkg-details! catalog name details)
  ((package-catalog-set-pkg-details-proc catalog) name details))

(define (package-dict->package-catalog pkg-dict)
  (define mutable-pkg-dict (make-hash (dict->list pkg-dict)))
  (define (all-pkgs-thunk) (dict-copy mutable-pkg-dict))
  (define (pkg-names-thunk)
    (dict-keys mutable-pkg-dict))
  (define (pkg-details-proc name)
    (dict-ref mutable-pkg-dict name))
  (define (set-pkg-details-proc name details)
    (dict-set! mutable-pkg-dict name details))
  (package-catalog all-pkgs-thunk
                   pkg-names-thunk
                   pkg-details-proc
                   set-pkg-details-proc))

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
   (define pkg-dict-mutable (make-hash (dict->list pkg-dict)))
   (define pkg-catalog (package-dict->package-catalog pkg-dict))
   (check-pred package-catalog? pkg-catalog)
   (check-equal? (all-pkgs pkg-catalog) pkg-dict-mutable)
   (check-equal? (sort (pkg-names pkg-catalog) string<?) '("bar" "foo"))
   (check-equal? (pkg-details pkg-catalog "foo") foo-pkg-details)))
