#lang typed/racket

(require "pkg-detail.rkt"
         "pkg-catalog-types.rkt")

(provide package-dict->package-catalog)

(module+ test
  (require typed/rackunit
           "pkg-catalog-functions.rkt"))


(: package-dict->package-catalog (-> PackageCatalogHash package-catalog))
(define (package-dict->package-catalog pkg-dict)

  (: mutable-pkg-dict PackageCatalogHash)
  (define mutable-pkg-dict (make-hash (hash->list pkg-dict)))

  (: all-pkgs-thunk (-> PackageCatalogHash))
  (define (all-pkgs-thunk) (hash-copy mutable-pkg-dict))

  (: pkg-names-thunk (-> (Listof String)))
  (define (pkg-names-thunk)
    (hash-keys mutable-pkg-dict))

  (: pkg-details-proc (-> String PackageDetail))
  (define (pkg-details-proc name)
    (hash-ref mutable-pkg-dict name))

  (: set-pkg-details-proc (-> String PackageDetail Void))
  (define (set-pkg-details-proc name details)
    (hash-set! mutable-pkg-dict name details))

  (: remove-pkg-details-proc (-> String Void))
  (define (remove-pkg-details-proc name)
    (hash-remove! mutable-pkg-dict name))

  (package-catalog all-pkgs-thunk
                   pkg-names-thunk
                   pkg-details-proc
                   set-pkg-details-proc
                   remove-pkg-details-proc))


(: pkg-catalog-hash-set (-> PackageCatalogHash String PackageDetail PackageCatalogHash))
(define pkg-catalog-hash-set hash-set)


(module+ test
  (: foo-pkg-details PackageDetail)
  (define foo-pkg-details #hasheq((source . "path/to/foo")
                                  (checksum . 0)
                                  (name . "foo")))
  (: bar-pkg-details PackageDetail)
  (define bar-pkg-details #hasheq((source . "path/to/bar")
                                  (checksum . 0)
                                  (name . "bar")))
  (: pkg-dict PackageCatalogHash)
  (define pkg-dict
    (pkg-catalog-hash-set
     (pkg-catalog-hash-set
      ((inst hash String PackageDetail))
      "foo" foo-pkg-details)
     "bar" bar-pkg-details))
  
  (define pkg-dict-mutable (make-hash (hash->list pkg-dict)))
  (define pkg-catalog (package-dict->package-catalog pkg-dict))
  
  (check-equal? (all-pkgs pkg-catalog) pkg-dict-mutable)
  (check-equal? (sort (pkg-names pkg-catalog) string<?) '("bar" "foo"))
  (check-equal? (pkg-details pkg-catalog "foo") foo-pkg-details))
