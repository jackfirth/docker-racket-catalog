#lang racket

(require "pkg-catalog.rkt"
         spin)

(provide
 (contract-out
  [set-catalog-routes (-> package-catalog? void?)]))


(define (set-catalog-routes pkg-catalog)
  (get "/pkgs-all" (thunk (~s (all-pkgs pkg-catalog))))
  (get "/pkgs" (thunk (~s (sort (pkg-names pkg-catalog) string<?))))
  (define (pkg-details-request req)
    (define name (params req 'name))
    (~s (pkg-details pkg-catalog name)))
  (get "/pkg/:name" pkg-details-request))
