#lang racket

(require fancy-app
         net/url
         "main.rkt"
         "call-response.rkt")

(provide wrap-read
         base-read-requester)


(define read/response
  (compose read open-input-string))

(define write/body
  (compose string->bytes/utf-8 ~s))

(define wrap-read
  (compose (wrap-requester-response read/response _)
           (wrap-requester-body write/body _)
           requester-pure
           (wrap-requester-headers (list "Content-Type: application/racket") _)))

(define base-read-requester (wrap-read base-requester))
