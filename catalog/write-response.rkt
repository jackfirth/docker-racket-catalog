#lang racket

(require web-server/http/request-structs
         fancy-app)

(provide
 (contract-out
  [response? flat-contract?]
  [write-forbidden-response (-> any/c response?)]
  [write-ok-handler (-> (unconstrained-domain-> any/c) (unconstrained-domain-> response?))]))


(define response?
  (list/c exact-positive-integer? (listof header?) string?))

(define base-headers
  (list (header #"Content-Type" #"application/racket")
        (header #"Content-Disposition" #"inline")))

(define (write-response code v)
  (list code base-headers (~s v)))

(define write-ok-response (write-response 200 _))
(define write-forbidden-response (write-response 403 _))

(define (write-handler code handler)
  (compose (write-response code _) handler))

(define write-ok-handler (write-handler 200 _))
