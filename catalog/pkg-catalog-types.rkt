#lang typed/racket

(require "pkg-detail.rkt")

(provide
 (struct-out package-catalog)
 PackageCatalogHash)


(define-type PackageCatalogHash (HashTable String PackageDetail))

(struct package-catalog
  ([all-pkgs-thunk : (-> PackageCatalogHash)]
   [pkg-names-thunk : (-> (Listof String))]
   [pkg-details-proc : (-> String (U PackageDetail #f))]
   [set-pkg-details-proc : (-> String PackageDetail Void)]
   [remove-pkg-details-proc : (-> String Void)]))
