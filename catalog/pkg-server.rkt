#lang racket

(require "pkg-catalog.rkt"
         "pkg-detail.rkt"
         web-server/http/request-structs
         fancy-app
         spin)

(provide
 (contract-out
  [set-catalog-routes (-> package-catalog? void?)]))


(define (pkg-details-request pkg-catalog req)
  (define/contract name
    string?
    (params req 'name))
  (~s (pkg-details pkg-catalog name)))

(define (set-pkg-details-request pkg-catalog req)
  (displayln (request-post-data/raw req))
  (define/contract name
    string?
    (params req 'name))
  (define/contract details
    pkg-detail?
    (get-req-pkg-details req))
  (set-pkg-details! pkg-catalog name details)
  (~s (pkg-details pkg-catalog name)))

(define (get-req-pkg-details req)
  (read (open-input-string (bytes->string/utf-8 (request-post-data/raw req)))))


(define (set-catalog-routes pkg-catalog)
  (get "/pkgs-all" (thunk (~s (all-pkgs pkg-catalog))))
  (get "/pkgs" (thunk (~s (sort (pkg-names pkg-catalog) string<?))))
  (get "/pkg/:name" (pkg-details-request pkg-catalog _))
  (put "/pkg/:name" (set-pkg-details-request pkg-catalog _)))
