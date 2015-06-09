#lang racket

(require "pkg-catalog.rkt"
         "redis-names.rkt"
         "redis-read.rkt"
         redis)

(provide
 (contract-out
  [redis-catalog package-catalog?]
  [set-redis-catalog! (-> package-catalog? void)]))


(define/redis (redis-all-packages)
  (if (EXISTS all-pkgs-key)
      (GET/read all-pkgs-key)
      (hash)))

(define/redis (redis-package-names)
  (if (EXISTS pkg-names-key)
      (GET/read pkg-names-key)
      (list)))

(define/redis (redis-package-details name)
  (define pkg-key (pkg-details-key name))
  (if (EXISTS pkg-key)
      (GET/read pkg-key)
      #f))

(define (all-pkgs-set all-pkgs details)
  (define pkg-name (hash-ref details 'name))
  (hash-set all-pkgs pkg-name details))

(define (pkg-names-add pkg-names name)
  (sort (set->list (set-add (list->set pkg-names) name)) string<?))

(define (pkg-names-remove pkg-names name)
  (sort (set->list (set-remove (list->set pkg-names) name)) string<?))

(define (pkg-names-set pkg-names details)
  (define pkg-name (hash-ref details 'name))
  (pkg-names-add pkg-names pkg-name))

(define/redis (redis-set-package-details! name details)
  (SET/write (pkg-details-key name) details)
  (define all-pkgs (redis-all-packages))
  (define pkg-names (redis-package-names))
  (SET/write all-pkgs-key (all-pkgs-set all-pkgs details))
  (SET/write pkg-names-key (pkg-names-set pkg-names details))
  (void))

(define/redis (redis-remove-package-details! name)
  (DEL name)
  (define all-pkgs (redis-all-packages))
  (define pkg-names (redis-package-names))
  (SET/write all-pkgs-key (hash-remove all-pkgs name))
  (SET/write pkg-names-key (pkg-names-remove pkg-names name))
  (void))


(define redis-catalog
  (package-catalog redis-all-packages
                   redis-package-names
                   redis-package-details
                   redis-set-package-details!
                   redis-remove-package-details!))


(define/redis (set-redis-catalog! source-pkg-catalog)
  (SET/write all-pkgs-key (all-pkgs source-pkg-catalog))
  (SET/write pkg-names-key (pkg-names source-pkg-catalog))
  (for ([(k v) (in-dict (all-pkgs source-pkg-catalog))])
    (SET/write (pkg-details-key k) v)))
