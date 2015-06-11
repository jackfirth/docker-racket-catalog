#lang racket

(require "pkg-catalog.rkt"
         "pkg-detail.rkt"
         "pkg-server-logging.rkt"
         web-server/http/request-structs
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

(define (pkg-details-request pkg-catalog req)
  (define name (req-pkg-name req))
  (log-get name)
  (write-response (pkg-details pkg-catalog name)))

(define (set-pkg-details-request pkg-catalog req)
  (define name (req-pkg-name req))
  (log-put name)
  (define/contract details
    pkg-detail?
    (get-req-pkg-details req))
  (set-pkg-details! pkg-catalog name details)
  (write-response (pkg-details pkg-catalog name)))

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
  (write-response (all-pkgs pkg-catalog)))

(define ((get-pkgs-thunk pkg-catalog))
  (log-get-pkgs)
  (write-response (sort (pkg-names pkg-catalog) string<?)))

(define (set-catalog-routes pkg-catalog)
  (get "/pkgs-all" (get-pkgs-all-thunk pkg-catalog))
  (get "/pkgs" (get-pkgs-thunk pkg-catalog))
  (get "/pkg/:name" (pkg-details-request pkg-catalog _))
  (put "/pkg/:name" (set-pkg-details-request pkg-catalog _))
  (delete "/pkg/:name" (remove-pkg-details-request pkg-catalog _)))
