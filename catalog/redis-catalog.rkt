#lang racket

(require "pkg-catalog.rkt"
         redis)

(provide redis-catalog
         set-redis-catalog!)


(define (redis-catalog-connect)
  (connect #:host "redis"))

(define (on-exit exit-thunk body-thunk)
  (dynamic-wind void body-thunk exit-thunk))

(define-syntax-rule (with-custom-redis-connection conn body ...)
  (parameterize ([current-redis-connection conn])
    (on-exit disconnect (thunk body ...))))

(define-syntax-rule (define/redis header body ...)
  (define header
    (with-custom-redis-connection
     (redis-catalog-connect)
     body ...)))

(define read-from-bytes
  (compose read open-input-string bytes->string/utf-8))

(define GET/read
  (compose read-from-bytes GET))

(define (SET/write k v)
  (SET k (~s v)))

(define/redis (redis-all-packages)
  (GET/read "ALL_PACKAGE_DETAILS"))

(define/redis (redis-package-names)
  (GET/read "ALL_PACKAGE_NAMES"))

(define/redis (redis-package-details name)
  (GET/read (string-append "PKG_" name)))

(define redis-catalog
  (package-catalog redis-all-packages
                   redis-package-names
                   redis-package-details))

(define/redis (set-redis-catalog! pkg-catalog)
  (SET/write "ALL_PACKAGE_NAMES" (pkg-names pkg-catalog))
  (SET/write "ALL_PACKAGE_DETAILS" (all-pkgs pkg-catalog))
  (for ([(k v) (in-dict (all-pkgs pkg-catalog))])
    (SET/write (string-append "PKG_" k) v)))
