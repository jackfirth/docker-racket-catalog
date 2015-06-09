#lang racket

(require "pkg-catalog.rkt"
         "pkg-detail.rkt"
         web-server/http/request-structs
         racket/place/distributed
         fancy-app
         spin)

(provide
 (contract-out
  [set-catalog-routes (-> package-catalog? void?)]))

(define (log-get name)
  (displayln/f (string-append "GET " name)))

(define (log-delete name)
  (displayln/f (string-append "DELETE " name)))

(define (log-get-pkgs)
  (displayln/f "GET PKGS"))

(define (log-get-all)
  (displayln/f "GET ALL PKG DETAILS"))

(define (log-put name)
  (displayln/f (string-append "PUT " name)))

(define (pkg-details-request pkg-catalog req)
  (define name (req-pkg-name req))
  (log-get name)
  (~s (pkg-details pkg-catalog name)))

(define (set-pkg-details-request pkg-catalog req)
  (define name (req-pkg-name req))
  (log-put name)
  (define/contract details
    pkg-detail?
    (get-req-pkg-details req))
  (set-pkg-details! pkg-catalog name details)
  (~s (pkg-details pkg-catalog name)))

(define (get-req-pkg-details req)
  (read (open-input-string (bytes->string/utf-8 (request-post-data/raw req)))))

(define/contract (req-pkg-name req)
  (-> request? string?)
  (params req 'name))

(define (remove-pkg-details-request pkg-catalog req)
  (define name (req-pkg-name req))
  (log-delete name)
  (remove-pkg-details! pkg-catalog name)
  "ok")

(define ((get-pkgs-all-thunk pkg-catalog))
  (log-get-all)
  (~s (all-pkgs pkg-catalog)))

(define ((get-pkgs-thunk pkg-catalog))
  (log-get-pkgs)
  (~s (sort (pkg-names pkg-catalog) string<?)))

(define (set-catalog-routes pkg-catalog)
  (get "/pkgs-all" (get-pkgs-all-thunk pkg-catalog))
  (get "/pkgs" (get-pkgs-thunk pkg-catalog))
  (get "/pkg/:name" (pkg-details-request pkg-catalog _))
  (put "/pkg/:name" (set-pkg-details-request pkg-catalog _))
  (delete "/pkg/:name" (remove-pkg-details-request pkg-catalog _)))
