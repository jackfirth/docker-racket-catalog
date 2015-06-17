#lang racket

(require fancy-app
         net/url
         "main.rkt"
         "call-response.rkt")

(provide wrap-read
         base-read-requester)


(define (map-response f base-response)
  (response (response-code base-response)
            (response-headers base-response)
            (f (response-body base-response))))

(define read/response
  (map-response (compose read open-input-string) _))

(define write/body
  (compose string->bytes/utf-8 ~s))

(define wrap-read
  (compose requester-pure
           (wrap-requester-response read/response _)
           (wrap-requester-body write/body _)
           (wrap-requester-headers (list "Content-Type: application/racket") _)))

(define base-read-requester (wrap-read base-requester))
