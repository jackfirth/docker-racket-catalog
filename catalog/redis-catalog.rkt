#lang racket

(require "pkg-catalog.rkt"
         "redis-names.rkt"
         "redis-read.rkt")

(provide
 (contract-out
  [redis-catalog package-catalog?]
  [set-redis-catalog! (-> package-catalog? void)]))


(define/redis (redis-all-packages)
  (GET/read all-pkgs-key))

(define/redis (redis-package-names)
  (GET/read pkg-names-key))

(define/redis (redis-package-details name)
  (GET/read (pkg-details-key name)))


(define redis-catalog
  (package-catalog redis-all-packages
                   redis-package-names
                   redis-package-details))


(define/redis (set-redis-catalog! pkg-catalog)
  (SET/write all-pkgs-key (all-pkgs pkg-catalog))
  (SET/write pkg-names-key (pkg-names pkg-catalog))
  (for ([(k v) (in-dict (all-pkgs pkg-catalog))])
    (SET/write (pkg-details-key k) v)))
