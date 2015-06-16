#lang racket

(require fancy-app
         net/url
         "rest.rkt"
         "rest-read.rkt")

(provide make-pkg-catalog-requester
         pkg-catalog-requester)


(define (wrap-route-url base requester)
  (wrap-requester-url (compose string->url (string-append base _)) requester)) 

(define make-pkg-catalog-requester (wrap-route-url _ base-read-requester))
(define pkg-catalog-requester (make-pkg-catalog-requester "http://pkgs.racket-lang.org"))
