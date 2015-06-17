#lang racket

(require "pkg-catalog.rkt"
         "pkg-detail.rkt"
         "pkg-server-handlers.rkt"
         "pkg-server-access-control.rkt"
         "write-response.rkt"
         fancy-app
         spin)

(provide
 (contract-out
  [set-catalog-routes (-> package-catalog? void?)]))

(define (pkgs-all-handler pkg-catalog)
  (write-ok-handler (get-pkgs-all-thunk pkg-catalog)))

(define (pkgs-handler pkg-catalog)
  (write-ok-handler (get-pkgs-thunk pkg-catalog)))

(define (get-pkg-handler pkg-catalog)
  (write-ok-handler (pkg-details-request pkg-catalog _)))

(define (put-pkg-handler pkg-catalog)
  (author-only-handler pkg-catalog
                       (write-ok-handler (set-pkg-details-request pkg-catalog _))
                       _))

(define (delete-pkg-handler pkg-catalog)
  (author-only-handler pkg-catalog
                       (write-ok-handler (remove-pkg-details-request pkg-catalog _))
                       _))

(define (set-catalog-routes pkg-catalog)
  (get "/pkgs-all" (pkgs-all-handler pkg-catalog))
  (get "/pkgs" (pkgs-handler pkg-catalog))
  (get "/pkg/:name" (get-pkg-handler pkg-catalog))
  (put "/pkg/:name" (put-pkg-handler pkg-catalog))
  (delete "/pkg/:name" (delete-pkg-handler pkg-catalog)))
