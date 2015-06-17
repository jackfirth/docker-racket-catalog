#lang racket

(require "rest-struct.rkt"
         fancy-app)

(provide wrap-requester
         wrap-requester-url
         wrap-requester-body
         wrap-requester-response
         wrap-requester-headers)


(define (wrap-requester wrapper requester-to-wrap)
  (requester (wrapper (requester-get requester-to-wrap))
             (wrapper (requester-put requester-to-wrap))
             (wrapper (requester-post requester-to-wrap))
             (wrapper (requester-delete requester-to-wrap))))


(define (wrap-requester-url url-func requester)
  (define ((wrapper handler) url #:headers [headers '()] . rest)
    (apply handler (url-func url) #:headers headers rest))
  (wrap-requester wrapper requester))

(define (wrap-requester-body body-func requester)
  (define ((wrapper handler) url #:headers [headers '()] . rest)
    (apply handler url #:headers headers (map body-func rest)))
  (wrap-requester wrapper requester))

(define (wrap-requester-response response-func requester)
  (define ((wrapper handler) url #:headers [headers '()] . rest)
    (response-func (apply handler url #:headers headers rest)))
  (wrap-requester wrapper requester))

(define (wrap-requester-headers base-headers requester)
  (define ((wrapper handler) url #:headers [headers '()] . rest)
    (apply handler url #:headers (append base-headers headers) rest))
  (wrap-requester wrapper requester))
