#lang racket

(require "pkg-catalog.rkt"
         "pkg-detail.rkt"
         "pkg-server-handlers.rkt"
         fancy-app
         spin)

(provide
 (contract-out
  [set-catalog-routes (-> package-catalog? void?)]))

(define (hash-merge hash1 hash2)
  (define key-vals (flatten (hash->list hash2)))
  (apply hash-set* hash1 key-vals))

(define base-headers
  (list (header #"Content-Type" #"application/racket")
        (header #"Content-Disposition" #"inline")))

(define (write-response v #:headers [headers '()])
  (list 200 (append base-headers headers) (~s v)))

(define (write-handler handler #:headers [headers '()])
  (compose (write-response _ #:headers headers) handler))

(define (set-catalog-routes pkg-catalog)
  (get "/pkgs-all" (write-handler (get-pkgs-all-thunk pkg-catalog)))
  (get "/pkgs" (write-handler (get-pkgs-thunk pkg-catalog)))
  (get "/pkg/:name" (write-handler (pkg-details-request pkg-catalog _)))
  (put "/pkg/:name" (write-handler (set-pkg-details-request pkg-catalog _)))
  (delete "/pkg/:name" (write-handler (remove-pkg-details-request pkg-catalog _))))
