#lang racket

(require web-server/http/request-structs
         spin
         "pkg-server-logging.rkt"
         "pkg-catalog.rkt"
         "pkg-detail.rkt")

(provide get-pkgs-thunk
         get-pkgs-all-thunk
         pkg-details-request
         set-pkg-details-request
         remove-pkg-details-request)
         

(define ((get-pkgs-thunk pkg-catalog))
  (log-get-pkgs)
  (sort (pkg-names pkg-catalog) string<?))

(define ((get-pkgs-all-thunk pkg-catalog))
  (log-get-all)
  (all-pkgs pkg-catalog))

(define (pkg-details-request pkg-catalog req)
  (define name (req-pkg-name req))
  (log-get name)
  (pkg-details pkg-catalog name))

(define (set-pkg-details-request pkg-catalog req)
  (define name (req-pkg-name req))
  (log-put name)
  (define/contract details
    pkg-detail?
    (get-req-pkg-details req))
  (set-pkg-details! pkg-catalog name details)
  (pkg-details pkg-catalog name))

(define (remove-pkg-details-request pkg-catalog req)
  (define name (req-pkg-name req))
  (log-delete name)
  (remove-pkg-details! pkg-catalog name)
  #t)


(define (get-req-pkg-details req)
  (read (open-input-string (bytes->string/utf-8 (request-post-data/raw req)))))

(define/contract (req-pkg-name req)
  (-> request? string?)
  (params req 'name))
