#lang typed/racket

(require "pkg-detail.rkt"
         "pkg-catalog-types.rkt")

(provide all-pkgs
         pkg-names
         pkg-details
         set-pkg-details!
         remove-pkg-details!)

(: all-pkgs (-> package-catalog PackageCatalogHash))
(define (all-pkgs catalog)
  ((package-catalog-all-pkgs-thunk catalog)))

(: pkg-names (-> package-catalog (Listof String)))
(define (pkg-names catalog)
  ((package-catalog-pkg-names-thunk catalog)))

(: pkg-details (-> package-catalog String PackageDetail))
(define (pkg-details catalog name)
  ((package-catalog-pkg-details-proc catalog) name))

(: set-pkg-details! (-> package-catalog String PackageDetail Void))
(define (set-pkg-details! catalog name details)
  ((package-catalog-set-pkg-details-proc catalog) name details))

(: remove-pkg-details! (-> package-catalog String Void))
(define (remove-pkg-details! catalog name)
  ((package-catalog-remove-pkg-details-proc catalog) name))
